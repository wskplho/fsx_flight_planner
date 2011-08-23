namespace :db do
  desc 'Recreate database.'
  task :recreate do
    sh 'rake db:drop db:create db:migrate'
  end

  desc 'Migrate to version 0 and back up.'
  task :remigrate do
    sh 'rake db:migrate VERSION=0 && rake db:migrate'
  end

  desc 'Recreate database and load latest dump data.'
  task :complete_recreate do
    sh "rake db:drop db:create db:migrate && rake db:data:load:latest"
  end

  namespace :data do
    namespace :dump do
      desc 'Dump database into db/dump_yyyymmddhhmmss/.'
      task :latest do
        dir = "dump_#{ Time.now.strftime '%Y%m%d%H%M%S' }"
        sh "rake db:data:dump_dir dir=#{ dir }"
      end
    end

    namespace :load do
      desc 'Load latest dump into database.'
      task :latest do
        latest_dump = File.basename Dir.glob( Rails.root.join('db', 'dump_[0-9]*') ).sort.last
        latest_dump_path = Rails.root.join 'db', latest_dump

        if latest_dump.blank?
          puts 'No dumps found.'
        elsif !File.directory?(latest_dump_path)
          raise "#{ latest_dump_path } doesn't seem to exist."
        else
          sh "rake db:data:load_dir dir=#{ latest_dump }"
        end
      end
    end
  end
end