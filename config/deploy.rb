# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "qna"
set :repo_url, "git@github.com:diaz47/qna.git"
set :default_env, { rvm_bin_path: "/usr/local/rvm/bin" }
set :environment, "production"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ice/qna"
set :deploy_user, 'ice'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"


namespace :deploy do
  desc 'Restart app'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
