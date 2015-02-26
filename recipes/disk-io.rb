#
# Cookbook Name:: zabbix-custom-checks
# Recipe:: disk-io
#
# Copyright 2015, Pal David Gergely <nightw17@gmail.com>
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
# Please note that all of the template files used in this recipe are coming
# from here: https://github.com/grundic/zabbix-disk-performance and the
# original author and copyright holder is Grigory Chernyshev and the code was
# licensed under: The MIT License (MIT)

include_recipe "zabbix-custom-checks::default"

template "#{node.zabbix.agent.include_dir}/userparameter_diskstats.conf" do
	source 'disk-io/userparameter_diskstats.conf.erb'
	mode '00644'
	notifies :restart, 'service[zabbix_agentd]', :delayed
end

template "#{node[:zabbix][:external_dir]}/lld-disk.py" do
	source 'disk-io/lld-disk.py.erb'
	mode '00755'
end
