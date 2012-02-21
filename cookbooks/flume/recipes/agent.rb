#
# Cookbook Name::       flume
# Description::         Configures Flume Node, installs and starts service
# Recipe::              node
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Infochimps, Inc.
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

include_recipe 'flume'
include_recipe 'runit'

package "flume-node"

service "flume-node" do
  supports      :restart => true, :start=>true, :stop => true
  subscribes    :restart,resources( :template => ["/usr/lib/flume/conf/flume-site.xml","/usr/lib/flume/bin/flume-env.sh"] )
  action        node[:flume][:agent][:run_state]
end

bash "Hack flume-node init script to name physical node after machine" do
  code   "sed -i -r -e 's!^(.*)(flume-daemon.sh.*start node)(.*)$!\\1\\2 -n #{node.name}\\3!g' /etc/init.d/flume-node"
  not_if { File.read('/etc/init.d/flume-node') =~ Regexp.new("start node -n #{node.name}") }
end

announce(:flume, :agent)