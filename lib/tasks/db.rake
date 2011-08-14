namespace :db do
  desc 'Recreate database.'
  task :recreate do
    sh 'rake db:drop:all && rake db:create && rake db:migrate'
  end

  desc 'Remigrate back and forth.'
  task :remigrate do
    sh 'rake db:migrate VERSION=0 && rake db:migrate'
  end

  desc 'Complete recreate.'
  task :complete_recreate do
    latest_dump = File.basename Dir.glob( Rails.root.join('db', 'dump_[0-9]*') ).sort.last
    latest_dump_path = Rails.root.join 'db', latest_dump

    if latest_dump && File.directory?(latest_dump_path)
      sh "rake db:drop:all && rake db:create && rake db:migrate && rake db:data:load_dir dir=#{ latest_dump }"
    else
      raise "#{ latest_dump_path } doesn't exist."
    end
  end

  namespace :data do
    desc 'Dump contents of database to db/dump_timenow/tablename.extension'
    task :dump_my do
      now = Time.now.strftime '%Y%m%d%H%M%S'
      dir = ENV['DIR'].blank? ? "dump_#{ now }" : "dump_#{ ENV['DIR'] }"
      #env = ENV['RAILS_ENV'].blank? ? 'development' : ENV['RAILS_ENV']
      sh "rake db:data:dump_dir dir=#{ dir }"
    end
  end
end