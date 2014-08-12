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

module ESX
	class VM
		def shutdown
			unless host.free_license
				vm_object.ShutdownGuest
			else
				host.remote_command "vim-cmd vmsvc/power.shudown #{vmid}"
			end
		end
	end
end


class Chef
	class Knife
		class EsxVmDown < Knife

			include Knife::ESXBase

			banner "knife esx vm down NAME (options)"

			def run
				unless name_args.size == 1
					ui.info "Virtual Machine Name Missing"
					#show_usage
					exit 1
				end
				vm, name = nil, name_args.first
				connection.virtual_machines.each do |v|
					if v.name.casecmp(name) == 0
						vm = v
						break
					end
				end
				unless vm
					ui.info "#{name} not found"
					exit 1
				end
				unless vm.power_state == "poweredOn"
					ui.info "#{vm.name} is already powered off"
					exit 1
				end
				unless vm.guest_info.vmware_tools_installed?
					ui.info "VMware Tools are not running on #{vm.name}. Shutdown failed."
					exit 1
				end
				ui.info "Shutting down #{vm.name}..."
				vm.shutdown
			end
		end
	end
end

