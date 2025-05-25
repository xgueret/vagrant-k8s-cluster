VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes = [
    { hostname: "k8s-controlplan", ip: "192.168.1.70", memory: 4096, cpu: 2 },
    { hostname: "k8s-node1", ip: "192.168.1.71", memory: 2048, cpu: 2 },
    { hostname: "k8s-node2", ip: "192.168.1.72", memory: 2048, cpu: 2 }
  ]

  config.vm.box = "bento/ubuntu-24.04"

  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.hostname = node[:hostname]
      node_config.vm.network "private_network", type: "dhcp"  # NAT (Vagrant gère le SSH ici)
      #node_config.vm.network "public_network", ip: node[:ip]
      # Pour forcer une interface spécifique, décommente la ligne ci-dessous et remplace par ton interface (ex: "wlo1", "eth0")
      node_config.vm.network "public_network", ip: node[:ip], bridge: "wlo1"

      node_config.vm.provider "virtualbox" do |vb|
        vb.memory = node[:memory]
        vb.cpus = node[:cpu]
      end
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.groups = {
      "kube_controlplan" => ["k8s-controlplan"],
      "kube_workers" => ["k8s-node1", "k8s-node2"],
      "kube_cluster:children" => ["kube_controlplan", "kube_workers"]
    }
  end
end
