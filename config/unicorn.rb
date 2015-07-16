environment = ENV['RACK_ENV'] || ENV['RAILS_ENV']
if environment == 'development'
  root = '/apps/mashesh_demo'
  listen '10.5.3.204:6001'
else
  root = '/apps/mahesh/current'
  listen '10.5.3.203:8078'
end
working_directory root

pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

worker_processes 4
timeout 180

#worker_processes 4


preload_app true
before_fork do |server, worker|
  # Close all open connections
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
  #@resque_pid ||= spawn("bundle exec rake resque:work QUEUES=fast")
end


after_fork do |server, worker|
  # Reopen all connections
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
