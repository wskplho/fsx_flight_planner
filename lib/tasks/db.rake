namespace :db do
  desc 'Rollback and migrate database.'
  task :remigrate do
    sh 'rake db:migrate VERSION=0 && rake db:migrate'
  end
end