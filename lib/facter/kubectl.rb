# Kubadmin facts
#
require 'json'

Facter.add(:has_kubectl) do
  confine :kernel => :linux
  setcode do
    Facter::Util::Resolution.which('kubectl') ? true : false
  end
end


Facter.add(:kubernetes_version) do
  confine :kernel => :linux
  confine :has_kubectl => true

  kubernetes_json = Facter::Core::Execution.execute('/usr/bin/kubectl version -o json')
  kubernetes_parsed_json = JSON.parse(kubernetes_json)



  versions = {
    "client" => kubernetes_parsed_json['clientVersion']['gitVersion'],
  }

  # if the server is installed return that
  if kubernetes_parsed_json.key?('serverVersion')
    version.merge!({"server" => kubernetes_parsed_json['serverVersion']['gitVersion']})
  end


  setcode do
    versions
  end

end
