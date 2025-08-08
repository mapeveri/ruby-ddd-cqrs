namespace :generate do
  desc "Generates a controller in Api::V1::<folder>::<name> using `rails g controller`"
  task controller: :environment do
    folder = ENV["folder"]
    name   = ENV["name"]

    if folder.nil? || name.nil?
      puts "❌ You must pass folder= and name="
      puts "Example: rake generate:controller folder=Messages name=GetMessages"
      exit 1
    end

    folder_path = folder.downcase
    name_path   = name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    full_path   = "api/v1/#{folder_path}/#{name_path}"

    puts "🔧 Running: rails g controller #{full_path}"
    system("bin/rails g controller #{full_path}")
  end
end
