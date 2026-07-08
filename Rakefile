require './src/app'
namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    puts args, App.db_url
    require "sequel/core"
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    puts version
    Sequel.connect(App.db_url) do |db|
      db.extension :pg_enum
      Sequel::Migrator.run(db, "src/migrations", target: version)
    end
  end

  desc "Seed roles, exams, full JEE syllabus, and demo accounts"
  task :seed do
    require 'bundler'
    Bundler.require(:default, App.env)
    App.load!
    require_relative "src/db/seed"
    App::Db::Seed.run!
  end
end


require 'optparse'


namespace :create do
  desc "Creates Model"
  task :models do
    models = []
    OptionParser.new do |opts|
      opts.banner = "Usage: rake create:models [options]"
      opts.on("-n", "--names ARG", String) { |str| models += str.split(',') }
    end.parse!
    puts models
    exit
  end
end

# Usage: DB_URL="your-database-url" rake db:migrate
# To rollback: DB_URL="your-database-url" rake db:migrate[0]