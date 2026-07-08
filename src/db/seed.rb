module App
  module Db
    module Seed
      # Fixed demo credentials for the three personas the frontend prototype already hardcodes.
      DEMO_PASSWORDS = {
        1 => 'admin123',   # Rahul Sharma (ADMIN)
        2 => 'student123', # Aarav Patel (STUDENT)
        7 => 'parent123'   # Suresh Patel (PARENT)
      }.freeze
      DEFAULT_PASSWORD = 'ChangeMe123!'

      def self.run!
        if App::Models::Role.count > 0
          puts 'Seed data already present (roles table is non-empty) - skipping. Truncate tables first to reseed.'
          return
        end

        sql_path = File.join(App.root, 'src', 'db', 'seed_data.sql')
        App.db.run(File.read(sql_path))
        puts 'Inserted reference + full JEE syllabus seed data.'

        App::Models::User.each do |user|
          user.password = DEMO_PASSWORDS[user.id] || DEFAULT_PASSWORD
          user.save(validate: false)
        end
        puts "Set passwords for #{App::Models::User.count} users."
        puts 'Demo logins:'
        puts '  admin.rahul@jeeprep.com / admin123'
        puts '  aarav.patel@student.com / student123'
        puts '  suresh.patel@parent.com / parent123'
        puts "  (all other seeded users: #{DEFAULT_PASSWORD})"
      end
    end
  end
end
