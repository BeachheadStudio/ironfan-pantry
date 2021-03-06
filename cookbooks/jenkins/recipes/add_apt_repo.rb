#
# Cookbook Name::       jenkins
# Description::         Installs a Jenkins CI server using the http://jenkins-ci.org/redhat RPM.  The recipe also generates an ssh private key and stores the ssh public key in the node 'jenkins[:public_key]' attribute for use by the node recipes.
# Recipe::              default
# Author::              Doug MacEachern <dougm@vmware.com>
# Author::              Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2010, VMware, Inc.
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

include_recipe 'apt'

# Add jenkins-ci.org package repo
apt_repository 'jenkins-ci' do
  uri             node[:jenkins][:apt_mirror]
  components      ['binary']
  key             "#{node[:apt][:jenkins][:url]}/jenkins-ci.org.key"
  action          :add
end

# # FIXME: apt provider-ize
# apt_key                = "/tmp/jenkins-ci.org.key"
#
# remote_file apt_key do
#   source "#{node[:apt][:jenkins][:url]}/jenkins-ci.org.key"
#   action :create
# end
#
# execute "add-jenkins_repo-key" do
#   command %Q{echo "Adding jenkins apt repo key" ; apt-key add #{apt_key}}
#   action :nothing
# end
#
# file "/etc/apt/sources.list.d/jenkins.list" do
#   owner   "root"
#   group   "root"
#   mode    0644
#   content "deb #{node[:jenkins][:apt_mirror]} binary/\n"
#   action  :create
#   notifies :run, "execute[add-jenkins_repo-key]",        :immediately
#   notifies :run, resources(:execute => "apt-get update"), :immediately
# end
