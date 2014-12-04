DEPRECATION NOTICE

I am no longer working on this cookbook. If you find it useful fork it. Issues are closed.

# chef_logstash cookbook

This is a Library Style cookbook that provides Chef Resource Providers to create and
manage your [Logstash](http://logstash.net/) environment.

# Requirements

The following cookbooks are suggested to use this cookbook:

  + [java::openjdk](https://github.com/opscode-cookbooks/java)
  + [runit](https://github.com/opscode-cookbooks/runit)

# Usage

# Resources and Providers

## logstash_instance
The intention is to provide a stable interface to creating instances of
Logstash on your servers. This means creating a instance via
`logstash_instance` will download, install, and setup a functional
instance of Logstash but it does not handle any configuration details.

The following actions are supported and `:create` is the default:

 + `:create` - Creates a named instance of Logstash. This action will
download logstash `:version` to the `:dst_dir`. It creates the `:user`
and `:group` used to run Logstash. And finally it creates the `runit`
resource required to manage the service. It does not _start_ the service
as that is a job for `:enable`.

 + `:enable` - Enables the specified `service_type` or the default `init`.
 + `:update` -
 + `:destroy` -
 + `:nothing` -

These attributes are defined in the resource:

 + `name`
 + `user`
 + `group`
 + `conf_dir`
 + `dst_dir`
 + `service_type` -
 + `service_options` -
 + `install_type` -
 + `install_options` -

Usage example:

    logstash_instance 'default' do
      install_options({
        url:      node.logstash.install_options.fetch(:url),
        checksum: node.logstash.install_options.fetch(:checksum),
        version:  node.logstash.install_options.fetch(:version)
      })
      action   [:create, :enable]
    end

## logstash_config

The following actions are supported and `:create` is the default:

 + `:create` - Creates a named configuration for a specific Logstash plugin.
This action will create a sub-resource based on the `plugin_type` and `plugin`
specified. The `plugin_config` attribute will be passed to the sub-resource
during resource creation. We use the `instance` attribute to link this
configuration to a specific Logstash instance.
 + `:enable` - Ensures the configuration for the specified instance has been loaded.
 + `:update` -
 + `:destroy` - Remove the named configuration.
 + `:nothing` - Does nothing, except define the resource with the associated
attributes.

These attributes are defined in the resource:

 + `instance` - The Logstash instance this plugin is associated with.
 + `plugin` - One of the numerous [Logstash plugins](http://logstash.net/docs/1.1.9/).
 + `plugin_type` - Accepts one of 'input', 'filter', 'output'
 + `plugin_config`- A hash containing the key-value pairs that configure
the plugin.

Usage example:

    logstash_config 'httpd_log_files' do
      instance    'default'
      plugin      'file'
      plugin_type 'input'
      plugin_config({
        path: ['/var/log/httpd/*_log'],
        type: 'httpd'
      })
      action [:create, :enable]
    end

# Contributing

  1. Fork it.
  2. Create a branch (`git checkout -b my_changes`)
  3. Commit your changes (`git commit -am "Added Snark"`)
  4. Push to the branch (`git push origin my_changes`)
  5. Open a [Pull Request][1]
  6. Enjoy a refreshing [Slurm](http://futurama.wikia.com/wiki/Slurm) and wait

## Testing

[![Build Status](https://travis-ci.org/miah/chef_logstash.png)](https://travis-ci.org/miah/chef_logstash)
[![Code Climate](https://codeclimate.com/github/miah/chef_logstash.png)](https://codeclimate.com/github/miah/chef_logstash)
[![Coverage Status](https://coveralls.io/repos/miah/chef_logstash/badge.png?branch=master)](https://coveralls.io/r/miah/chef_logstash?branch=master)

## Code Style

This code follows the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) and all contributions should as well.

The code style is checked by [Rubocop](http://batsov.com/rubocop/) and can be checked by executing `rake test:rubocop` or `rubocop`.

# Author

Author:: Miah Johnson (<miah@chia-pet.org>)

# Donations

[![Gittip](https://www.gittip.com/assets/9.4.5/logo.png)](https://www.gittip.com/miah/)

[![Bitcoin](http://bitcoinprices.com/images/bitcoin.png)](bitcoin:1DT5XQrtAk1M9V5RodvEHddfe7Nqd1kMjN)

# License

    Copyright 2013 Miah Johnson

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

[1]: http://github.com/miah/chef_logstash/pulls
