$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require 'bundler/capistrano'
set :rvm_ruby_string, '1.9.2@rails3.2'    


set :application, "Reader"
set :repository,  "git@github.com:wonnage/reader.git"

set :scm, :git
set :scm_user, 'victor'
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "deploy"
ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/var/rails/reader"
set :use_sudo, false

set :rails_env, 'production'

server "reader-test.stillraging.net", :web, :app, :db, :primary => true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

set :rails_env, :production
set :unicorn_binary, "/usr/local/rvm/gems/ruby-1.9.2-p290@rails3.2/bin/unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{try_sudo} RAILS_ENV=production bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "#{try_sudo} [[ -e #{unicorn_pid} ]] && kill `cat #{unicorn_pid}`; true"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} [[ -e #{unicorn_pid} ]] && kill -s QUIT `cat #{unicorn_pid}`; true"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} [[ -e #{unicorn_pid} ]] && kill -s USR2 `cat #{unicorn_pid}`; true"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    reload
    # restart resque workers
    run "cd #{current_path} && rake queue:restart_workers RAILS_ENV=production"
  end
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end
