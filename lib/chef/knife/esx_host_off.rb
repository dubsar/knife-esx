#
# Author:: Alessandro Scotti (scotti.alessandro@gmail.com)
# Copyright:: Alessandro Scotti (c) 2014
# License:: Apache License, Version 2.0
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

require 'chef/knife/esx_base'

class Chef
	class Knife
		class EsxHostOff < Knife

			include Knife::ESXBase

			banner "knife esx host off (options)"

			def run
				knife = Chef::Config[:knife]
				address, user, password = knife[:esx_host], knife[:esx_username], knife[:esx_password]
				ui.info "#{ui.color("Shutting down #{address} ...", :magenta)}"
				begin
					Net::SSH.start(address, user, password: password) do |ssh|
						ssh.exec! "/sbin/shutdown.sh && /sbin/poweroff"
					end
				rescue
					ui.info "#{ui.color("Error. Is the server up? Is ssh enabled?", :red)}"
					exit 1
				end
				ui.info "#{ui.color("Shutdown.", :magenta)}"
			end
		end
	end
end
