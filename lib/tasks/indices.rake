namespace :db do
  desc 'Find missing indices.'
  task :indices => :environment do
    c = ActiveRecord::Base.connection
    c.tables.collect do |t|  
      columns = c.columns(t).collect(&:name).select {|x| x.ends_with?("_id" || x.ends_with("_type"))}
      indexed_columns = c.indexes(t).collect(&:columns).flatten.uniq
      unindexed = columns - indexed_columns
      unless unindexed.empty?
        puts "#{t}: #{unindexed.join(", ")}"
      else
        puts "#{t}: ok"
      end
    end
  end
end