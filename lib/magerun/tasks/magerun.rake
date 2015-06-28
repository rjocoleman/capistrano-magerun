namespace :magerun do
  desc <<-DESC
    Installs n98-magerun.phar to the shared directory
    In order to use the .phar file, the magerun command needs to be mapped:
      SSHKit.config.command_map[:'n98-magerun.phar'] = "\#{shared_path.join('n98-magerun.phar')}"
    This is best used before deploy:starting:
      namespace :deploy do
        after :starting, 'magerun:install'
      end
  DESC
  task :install do
    on roles fetch(:magerun_roles) do
      within shared_path do
        unless test '[', '-e', 'n98-magerun.phar', ']'
          execute :curl, '--insecure', '-s', '-o', 'n98-magerun.phar', '-L', fetch(:magerun_download_url)
          execute :chmod, '+x', 'n98-magerun.phar'
        end
      end
    end
  end

  task :run, :command do |t, args|
    args.with_defaults(:command => :list)
    on roles fetch(:magerun_roles) do
      within release_path do
        execute :'n98-magerun.phar', args[:command], *args.extras
      end
    end
  end

  desc 'Run the self-update command for n98-magerun.phar'
  task :self_update do
    invoke 'magerun:run', :selfupdate
  end

end

namespace :load do
  task :defaults do

    set :magerun_roles, :all
    set :magerun_download_url, 'https://raw.github.com/netz98/n98-magerun/master/n98-magerun.phar'

  end
end
