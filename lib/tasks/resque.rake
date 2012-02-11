require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  task :setup => 'environment' do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'
    ENV['QUEUE'] = '*'
    Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
    Resque.schedule = YAML.load_file(File.join(Rails.root, 'config', 'resque_scheduler.yml'))
  end

end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"

namespace :queue do
  task :restart_workers => :environment do
    pids = Array.new
    
    Resque.workers.each do |worker|
      pids << worker.to_s.split(/:/).second
    end
    
    if pids.size > 0
      system("kill -QUIT #{pids.join(' ')}")
    end
    
    system("rm $HOME/.god/pids/resque-1.8.0*.pid")
  end
end
