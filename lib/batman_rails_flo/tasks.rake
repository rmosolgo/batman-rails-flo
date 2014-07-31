namespace :batman do
  desc "Start the live-reload server (fb-flo)"
  task :live_reload do
    puts "Starting the live-reload server (node.js is required)"
    gem_root = File.dirname(File.dirname(File.dirname(__FILE__)))
    cmd = "node #{gem_root}/vendor/assets/javascripts/batman_rails_flo/flo_server.js"
    puts cmd
    IO.popen(cmd) do |data|
      while line = data.gets
        puts line
      end
    end
  end
end