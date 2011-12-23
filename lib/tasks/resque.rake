require 'resque/tasks'

namespace :resque do
  task :setup => 'environment' do
    ENV['QUEUE'] = '*'
    Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
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
