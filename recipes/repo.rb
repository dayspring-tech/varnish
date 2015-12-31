# Cookbook Name:: varnish
# Recipe:: repo
# Author:: Patrick Connolly <patrick@myplanetdigital.com>
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

if node['platform'] === 'amazon'
  yum_repository 'varnish' do
    description "Varnish #{node['varnish']['version']} repo (el6 - $basearch)"
    url "http://repo.varnish-cache.org/redhat/varnish-#{node['varnish']['version']}/el6/"
    gpgcheck false
    gpgkey 'http://repo.varnish-cache.org/debian/GPG-key.txt'
    priority "5"
    action 'create'
  end
elsif ['debian'].include?(node['platform_family'])
  include_recipe 'apt'
  apt_repository 'varnish-cache' do
    uri "http://repo.varnish-cache.org/#{node['platform']}"
    distribution node['lsb']['codename']
    components ["varnish-#{node['varnish']['version']}"]
    key "http://repo.varnish-cache.org/#{node['platform']}/GPG-key.txt"
    deb_src true
    notifies 'nothing', 'execute[apt-get update]', 'immediately'
  end
elsif ['rhel', 'fedora'].include?(node['platform_family'])
  yum_repository 'varnish' do
    description "Varnish #{node['varnish']['version']} repo (#{node['platform_version']} - $basearch)"
    url "http://repo.varnish-cache.org/redhat/varnish-#{node['varnish']['version']}/el#{node['platform_version'].to_i}/"
    gpgcheck false
    gpgkey 'http://repo.varnish-cache.org/debian/GPG-key.txt'
    action 'create'
  end
end
