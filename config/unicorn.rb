worker_processes 2

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true
timeout 30
listen 3000

pid Rails.root + '/tmp/pids/unicorn.pid'

stderr_path "/var/rails/reader/shared/log/unicorn.stderr.log"
stdout_path "/var/rails/reader/shared/log/unicorn.stdout.log"

after_fork do |server, worker|
  # Here we are establishing the connection after forking worker
  # processes
  ActiveRecord::Base.establish_connection
end

before_fork do |server, worker|
  old_pid = Rails.root + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
