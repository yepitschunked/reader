require 'resque/tasks'

namespace :resque do
  task :setup => 'environment' do
    ENV['QUEUE'] = '*'
    Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
  end

end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
