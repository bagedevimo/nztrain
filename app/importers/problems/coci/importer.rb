require 'zip/filesystem'

module Problems
  module COCI
    class Importer
      include Problems::COCI::Index

      # find all the problems in the contest
      def process(vid, cid)
        return false if !downloaded?(vid, cid)
        issue = self.issue(vid, cid) or return false
        Dir.mktmpdir do |tmpdir|
          pdfpath = File.expand_path("tasks.pdf", tmpdir)
          FileUtils.copy(File.expand_path(issue[:tasks][:local], DATAPATH), pdfpath)

          importer = PDFImporter.new(pdfpath)
          problems = importer.extract

          issue[:problems] ||= []

          # extract zipped test data
          testpath = File.expand_path("testdata.zip", tmpdir)
          FileUtils.copy(File.expand_path(issue[:testdata][:local], DATAPATH), testpath)

          Zip::File.open(testpath) do |zfs|
            candidate_zips = []
            zfs.dir.foreach('/') do |entry|
              candidate_zips << entry
            end

            solutiondir = File.expand_path("solutions", tmpdir)
            FileUtils.mkdir_p(solutiondir)
            if issue[:solutions] && issue[:solutions][:local]
              # extract solution data
              solutionpath = File.expand_path("solutions.zip", tmpdir)
              FileUtils.copy(File.expand_path(issue[:solutions][:local], DATAPATH), solutionpath)
              Zip::InputStream::open(solutionpath) do |io|
                while (entry = io.get_next_entry)
                  entry.extract(File.expand_path(entry.to_s, solutiondir))
                end
              end
            end

            # determine the problems we need
            problems.each do |problem_data|
              existing = issue[:problems].map{ |p| p[:name] }
              pid = existing.index(problem_data[:name]) || existing.size
              merge_problem!(issue[:problems][pid] ||= {}, problem_data)

              # find zip dir for test data
              simplename = problem_data[:name].mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s.strip.split(' ')[0]
              zipdirs = candidate_zips.select{|entry| entry =~ /\A#{simplename}/ }
              zipdir = (zipdirs.select{|entry| entry == simplename } + zipdirs)[0]

              problem_data[:shortname] = zipdir

              testdatadir = File.expand_path("testdata-#{pid}", tmpdir)
              FileUtils.mkdir_p(testdatadir)
              zfs.dir.foreach(zipdir) do |entry|
                zfs.extract("#{zipdir}/#{entry}", File.expand_path(entry.to_s, testdatadir))
              end

              # make sure the test submission array is present
              issue[:problems][pid][:tests] ||= []

              paths = {tmp: tmpdir, testdata: testdatadir}

              # check if there is a model solution
              %w[.cpp .c].each do |ext|
                mfile = File.expand_path(zipdir + ext, solutiondir)
                paths[:model] = mfile if File.exists?(mfile)
              end

              problem_data[:results] = issue[:results]

              # why bother splitting the solution pdf file?
              if issue[:solutions] && issue[:solutions][:local]
                possible_solution = File.expand_path("solutions.pdf", solutiondir)
                paths[:solution] = possible_solution if File.exists?(possible_solution)
                problem_data[:solution] = {file_attachment_id: issue[:solutions][:file_attachment_id]}
              end

              # create a new pdf file of the task with only the relevant pages
              if problem_data[:pages]
                paths[:statement] = File.expand_path("#{problem_data[:shortname]}-statement.pdf", tmpdir)
                Prawn::Document.generate paths[:statement], skip_page_creation: true do |pdf|
                  problem_data[:pages].each do |pg|
                    pdf.start_new_page(template: pdfpath, template_page: pg)
                  end
                end
              end

              yield(issue[:problems][pid], problem_data, pid, paths) if block_given?
            end
          end

        end
        save
        true
      end

      def merge_problem! problem, updated
        problem.merge!(updated.slice(:name, :points))
        problem[:images] = updated[:images].values
      end

      def upload_statement(problem, data)
      end

    end
  end
end