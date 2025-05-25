


# **📦 Cluster Kubernetes Local avec Vagrant, Ansible et kubeadm**

**Déployez un cluster Kubernetes local en quelques minutes** avec :

* **Vagrant** pour gérer les machines virtuelles.
* **Ansible** pour l'automatisation.
* **kubeadm** pour le cluster Kubernetes.
* **Containerd** comme runtime (sans Docker).

---

## **🚀 Fonctionnalités**

✅ Cluster **multi-nœuds** (1 master + 2 workers).
✅ Runtime **Containerd** (conforme aux bonnes pratiques Kubernetes).
✅ **Automatisation complète** via Ansible (rôle `geerlingguy.kubernetes`).
✅ **Réseau Calico** (CNI) préinstallé.
✅ Prêt pour le développement ou l'apprentissage de Kubernetes.

---

## **📦 Prérequis**

* [Vagrant](https://www.vagrantup.com/) (≥ 2.3)
* [VirtualBox](https://www.virtualbox.org/) (ou autre provider Vagrant)
* [Ansible](https://docs.ansible.com/) (≥ 2.9)
* 16 Go RAM + 4 CPU recommandés.

---

## **⚡ Démarrage Rapide**

### **1. Cloner le dépôt**

```bash
git clone https://github.com/votre-repo/k8s-vagrant-ansible.git
cd k8s-vagrant-ansible
```

### **2. Installer les dépendances Ansible**

```bash
ansible-galaxy install -r requirements.yml
```

### **3. Démarrer le cluster**

```bash
vagrant up  # Crée les VMs et provisionne le cluster
```

### **4. Accéder au cluster**

```bash
vagrant ssh master
kubectl get nodes  # Vérifier que tous les nœuds sont "Ready"
```

---

## **🛠️ Structure du Projet**

```
.
├── Vagrantfile          # Configuration des VMs
├── playbook.yml         # Playbook Ansible principal
├── inventories/        # Inventaire dynamique (généré par Vagrant)
├── group_vars/         # Variables Ansible
│   └── all.yml
└── requirements.yml    # Dépendances Ansible
```

---

## **⚙️ Configuration**

### **Variables clés (`group_vars/all.yml`)**

```yaml
kube_version: "1.29.0-00"  # Version de Kubernetes
kube_api_ip: "192.168.56.10"  # IP du master
pod_network_cidr: "10.244.0.0/16"  # Plage IP pour Calico
container_runtime: containerd  # Runtime CRI
```

### **Personnalisation**

* Modifiez `Vagrantfile` pour ajuster les ressources CPU/RAM.
* Changez le CNI en éditant `playbook.yml` (section `Install Calico CNI`).

---

## **🔍 Commandes Utiles**

| Commande                            | Description                             |
| ----------------------------------- | --------------------------------------- |
| `vagrant up`                      | Démarrer le cluster.                   |
| `vagrant destroy -f`              | Tout supprimer.                         |
| `vagrant provision`               | Relancer Ansible sans recréer les VMs. |
| `kubectl get pods -A`(sur master) | Lister les pods système.               |

---

## **🐛 Dépannage**

* **Problèmes de réseau** : Vérifiez que `kubelet` et `containerd` tournent (`systemctl status kubelet`).
* **Échec de `kubeadm join`** : Relancez `vagrant provision worker1`.
* **Erreurs Ansible** : Vérifiez les logs avec `ansible-playbook -vvv playbook.yml`.

---

## **📚 Documentation Complémentaire**

* [Documentation kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
* [Rôle Ansible geerlingguy.kubernetes](https://github.com/geerlingguy/ansible-role-kubernetes)

---

## **🎯 Pour aller plus loin**

* Ajoutez **Argo CD** pour du GitOps.
* Déployez **MetalLB** pour les LoadBalancers locaux.
* Configurez **Prometheus** et **Grafana** pour la supervision
