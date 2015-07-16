# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mashesh_demo'
set :repo_url, 'git@github.com:bharathimit/mashesh_demo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/apps/mahesh'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  #%w[start stop restart].each do |command|
  #    desc "#{command} unicorn server"
  #    task command, :roles=> :app, :except=> {:no_release=> true} do
  #    run "/etc/init.d/unicorn_#{application} #{command}"
  #  end
  #end

  #after "deploy:setup", "deploy:setup_config"

  #task :symlink_config, :roles=> :app do
  #  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  #end

  #after "deploy:finalize_update", "deploy:symlink_config"
  #task :check_revision, :roles=> :web do
  #  unless `git rev-parse HEAD` == `git rev-parse origin/master`
  #    puts "WARNING: HEAD is not the same as origin/master"
  #    puts "Run `git push` to sync changes."
  #    exit
  #  end
  #end
  #before "deploy", "deploy:check_revision"

  desc 'Restart application'
  task :restart do
    on roles(:app), :in=> :sequence, :wait=> 5 do
      execute '/etc/init.d/mahesh restart'
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Execute all DB Migrations'
  task :migrate do
    on roles(:db), :in=> :sequence, :wait=> 5 do
      execute 'cd /apps/mahesh/current; RAILS_ENV=staging bundle exec rake db:migrate'
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end


  #after :restart, :clear_cache do
  #  on roles(:web), :in=> :groups, :limit=> 3, :wait=> 10 do
  #    # Here we can do anything such as:
  #    # within release_path do
  #    #   execute :rake, 'cache:clear'
  #    # end
  #  end
  #end

  after :finishing, 'deploy:cleanup'
end
