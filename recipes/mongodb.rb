#
# Cookbook Name:: zabbix-custom-checks
# Recipe:: mongodb
#
# Copyright 2014, Pal David Gergely <nightw17@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "zabbix-custom-checks::default"

# Install PHP with the Mongo PECL package, since it's required for
# the mikoomi script to work
include_recipe 'php'
php_pear 'mongo'

template "#{node[:zabbix][:external_dir]}/mikoomi-mongodb-plugin.php" do
	source "mongodb/mikoomi-mongodb-plugin.php.erb"
	mode "755"
end

template "#{node[:zabbix][:external_dir]}/mikoomi-mongodb-plugin.sh" do
	source "mongodb/mikoomi-mongodb-plugin.sh.erb"
	mode "755"
end

# Adding cron job to run the MongoDB monitoring script in every minute
cron_d 'mongodb-monitoring' do
    user    node[:zabbix][:agent][:user]
    shell   '/bin/bash'
    command "#{node[:zabbix][:external_dir]}/mikoomi-mongodb-plugin.sh -h #{node[:zabbix_custom_checks][:mongodb][:host]} -p #{node[:zabbix_custom_checks][:mongodb][:port]} -z #{node[:zabbix_custom_checks][:mongodb][:node_name_in_zabbix]} > /dev/null 2>&1"
end
