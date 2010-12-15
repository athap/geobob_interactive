#load 'vendor/plugins/mysql_tasks/lib/mysql_deploy'

set :keep_releases, 5
set :application,   'geobob'
set :repository,    'git@github.com:jbasdf/geobob.git'
set :branch,        'master'
set :deploy_to,     "/srv/#{application}"
set :deploy_via,    :export
set :monit_group,   "#{application}"
set :scm,           :git
set :git_enable_submodules, 1
set :scm_verbose,   true
set :use_sudo,      false

# This is the same database name for all environments
set :production_database,'geobob_production'

set :environment_host, 'localhost'
set :deploy_via, :remote_cache

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_run_options[:pty] = true # required for svn+ssh:// andf git:// sometimes

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, lambda { source.query_revision(revision) { |cmd| capture(cmd) } }


task :production do
  set :application, 'geobobapp.usu.edu'
  role :web, application
  role :app, application
  role :db, application, :primary => true
  set :environment_database, Proc.new { production_database }
  set :dbuser,        'bob'
  set :dbpass,        'djdu248!#$%dfgj^'
  set :user,          'bob'
  set :password,      '5kEp6UewjCcIoKsYSQamBthPLOAACCDm'
  set :runner,        'bob'
  set :rails_env,     'production'
end

after 'deploy:update_code', :setup_symlinks
task :setup_symlinks, :roles => :app do
  run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  #run "ln -nfs #{shared_path}/config/global_config.yml #{release_path}/config/"
  #run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/"
end


after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
 
  task :stop, :roles => :app do
    # Do nothing.
  end
 
  task :restart, :roles => :app do
    #run "sudo /etc/init.d/apache2 restart"
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  # Seed the database
  task :seed, :roles => :app do
    run("cd #{current_release} && rake db:seed RAILS_ENV=#{rails_env}")
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    puts '*************************************************************************'
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
  
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without development test"
  end
  
  task :lock, :roles => :app do
    run "cd #{current_release} && bundle lock;"
  end
  
  task :unlock, :roles => :app do
    run "cd #{current_release} && bundle unlock;"
  end
end

# HOOKS
after "deploy:update_code" do
  bundler.bundle_new_release
  # ...
end
