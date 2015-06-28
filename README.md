# Capistrano::Magerun

n98-magerun support for Capistrano 3.x

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.1.0'
gem 'capistrano-magerun'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-magerun

## Usage

Require the module in your `Capfile`:

```ruby
require 'capistrano-magerun'
```

`capistrano-magerun` comes with 3 tasks:

* magerun:install
* magerun:self_update
* magerun:run


By default it is assumed that you have the n98-magerun.phar executable installed and in your
`$PATH` on all target hosts.

### Configuration

Configurable options, shown here with defaults:

```ruby
set :magerun_roles, :all
set :magerun_download_url, 'https://raw.github.com/netz98/n98-magerun/master/n98-magerun.phar'
set :magerun_rootdir, release_path
```

### Installing magerun as part of a deployment

Add the following to `deploy.rb` to manage the installation of magerun during
deployment (n98-magerun.phar is install in the shared path).

```ruby
SSHKit.config.command_map[:'n98-magerun.phar'] = "#{shared_path.join('n98-magerun.phar')}"

namespace :deploy do
  after :starting, 'magerun:install'
end
```

### Accessing magerun commands directly

This library also provides a `magerun:run` task which allows access to any
magerun command.

From the command line you can run

```bash
$ cap production magerun:run['sys:maintenance', '--off']
```

Or from within a rake task using capistrano's `invoke`

```ruby
task :my_custom_magerun_task do
  # invoke 'magerun:run', 'sys:maintenance', '--on' # after a new SSHKit release that includes https://github.com/capistrano/sshkit/pull/58
  Rake::Task['magerun:run'].invoke('sys:maintenance --off') # until then
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Thanks

This code is heavily inspired by [https://github.com/capistrano/composer](https://github.com/capistrano/composer)
