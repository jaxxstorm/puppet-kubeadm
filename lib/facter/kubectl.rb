# Kubadmin facts
#
require 'json'

Facter.add(:has_kubectl) do
  setcode do
    Facter::Core::Execution.which('kubectl')
  end
end


Facter.add(:kubernetes_version) do
  confine :kernel => :linux
  kubernetes_json = Facter::Core::Execution.execute('/usr/bin/kubectl version -o json')
  kubernetes_parsed_json = JSON.parse(kubernetes_json)

  versions = {
    "client" => kubernetes_parsed_json['clientVersion']['gitVersion'],
    "server" => kubernetes_parsed_json['serverVersion']['gitVersion'],
  }

  setcode do
    versions
  end

end