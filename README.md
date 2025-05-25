# 🚀 Cluster Kubernetes Local avec Vagrant et Ansible

![Stars](https://img.shields.io/github/stars/xgueret/vagrant-k8s-cluster?style=social) ![Last Commit](https://img.shields.io/github/last-commit/xgueret/vagrant-k8s-cluster) ![Status](https://img.shields.io/badge/Status-Active-brightgreen) ![License](https://img.shields.io/badge/License-MIT-blue)
![Terraform](https://img.shields.io/badge/Terraform-≥1.11.0-623CE4) ![Ansible](https://img.shields.io/badge/Ansible-2.14+-EE0000)

Déployez un cluster Kubernetes complet en quelques minutes avec une automatisation complète basée sur **Vagrant**, **Ansible**, et **kubeadm**.

## 📋 Vue d'ensemble

Ce projet vous permet de créer un cluster Kubernetes local multi-nœuds avec :
- **1 nœud de contrôle** (k8s-controlplan)
- **2 nœuds workers** (k8s-node1, k8s-node2)
- Runtime **containerd**
- Réseau **Calico** (CNI)
- **Dashboard Kubernetes** et **Metrics Server** préinstallés

## ✨ Fonctionnalités

- 🔧 **Automatisation complète** avec Ansible (rôles modulaires)
- 🌐 **Réseau bridgé** pour un accès direct aux VMs
- 📊 **Monitoring** avec Dashboard et Metrics Server
- 🛡️ **Sécurité** avec configuration des groupes systemd
- 🎯 **Prêt pour la production** avec bonnes pratiques intégrées
- 🔄 **CI/CD ready** avec hooks pre-commit et linting

## 🛠️ Prérequis

### Logiciels requis
- [Vagrant](https://www.vagrantup.com/) ≥ 2.3
- [VirtualBox](https://www.virtualbox.org/) ≥ 7.0
- [Ansible](https://docs.ansible.com/) ≥ 2.9
- Python 3.8+

### Ressources système
- **RAM** : 8 Go minimum (16 Go recommandés)
- **CPU** : 4 cœurs minimum
- **Stockage** : 20 Go d'espace libre

## 🚀 Installation et démarrage

### 1. Cloner le projet

```bash
git clone <votre-repo>/vagrant-k8s-cluster.git
cd vagrant-k8s-cluster
```

### 2. Installation des dépendances

```bash
# Installer les dépendances Python
pip install -r requirements.txt

# Configuration pre-commit (optionnel mais recommandé)
pre-commit install
```

### 3. Configuration réseau

**Important** : Adaptez l'interface réseau dans le `Vagrantfile` :

```ruby
# Ligne 21 du Vagrantfile - remplacez "wlo1" par votre interface
node_config.vm.network "public_network", ip: node[:ip], bridge: "wlo1"
```

Pour identifier votre interface :
```bash
ip route | grep default
# ou
nmcli device status
```

### 4. Démarrage du cluster

```bash
vagrant up
```

:hourglass: Le processus prend environ 10-15 minutes...

## 🔧 Configuration

### Variables principales (`group_vars/all/main.yml`)

```yaml
k8s_release: "1.33"          # Version majeure de Kubernetes
k8s_version: "1.33.0"        # Version complète
home_dir: "/home/vagrant"    # Répertoire utilisateur
```

### Adresses IP par défaut

| Nœud | IP | Rôle |
|------|-----|------|
| k8s-controlplan | 192.168.1.70 | Control Plane |
| k8s-node1 | 192.168.1.71 | Worker |
| k8s-node2 | 192.168.1.72 | Worker |

## 📁 Structure du projet

```
.
├── Vagrantfile                    # Configuration des VMs
├── playbook.yml                   # Playbook principal Ansible
├── requirements.txt               # Dépendances Python
├── group_vars/all/main.yml       # Variables globales
├── roles/                         # Rôles Ansible modulaires
│   ├── cfg_nodes/                # Configuration de base des nœuds
│   ├── cfg_containerd/           # Installation containerd
│   ├── cfg_kubeadm_kubelet_kubectl/ # Outils Kubernetes
│   ├── inst_runc/                # Runtime runc
│   ├── inst_cni/                 # Plugins CNI
│   ├── inst_cri_tools/           # Outils CRI (crictl)
│   ├── init_kubeadm/             # Initialisation du cluster
│   ├── join_workers/             # Jointure des workers
│   └── kubectl_cheat_sheet/      # Configuration kubectl
├── github/                       # Module Terraform (optionnel)
└── .pre-commit-config.yaml      # Configuration qualité code
```

## 🎯 Utilisation

### Accès au cluster

```bash
# Se connecter au nœud maître
vagrant ssh k8s-controlplan

# Vérifier l'état du cluster
kubectl get nodes
kubectl get pods -A
```

### Commandes utiles

```bash
# Gestion des VMs
vagrant up                    # Démarrer toutes les VMs
vagrant up k8s-controlplan   # Démarrer une VM spécifique
vagrant halt                 # Arrêter toutes les VMs
vagrant destroy -f           # Supprimer toutes les VMs
vagrant provision           # Reprovisioner sans recréer

# Debugging
vagrant status              # État des VMs
vagrant ssh k8s-node1      # Se connecter à un worker
```

### Accès au Dashboard Kubernetes

1. Se connecter au nœud de contrôle :
```bash
vagrant ssh k8s-controlplan
```

2. Créer un tunnel pour accéder au dashboard :
```bash
kubectl proxy --address='0.0.0.0' --accept-hosts='^.*$'
```

3. Accéder via : `http://192.168.1.70:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`

## 🔍 Monitoring et debugging

### Vérification de l'état du cluster

```bash
# État des nœuds
kubectl get nodes -o wide

# État des pods système
kubectl get pods -n kube-system

# Métriques des nœuds (nécessite metrics-server)
kubectl top nodes
kubectl top pods -A
```

### Logs et debugging

```bash
# Logs kubelet
sudo journalctl -u kubelet -f

# Logs containerd
sudo journalctl -u containerd -f

# État des services
sudo systemctl status kubelet
sudo systemctl status containerd
```

## 🛡️ Sécurité et bonnes pratiques

### Fonctionnalités de sécurité intégrées

- Configuration systemd pour containerd et kubelet
- Désactivation du swap
- Configuration réseau sécurisée
- Isolation des pods avec Calico

### Hooks de qualité de code

Le projet inclut des hooks pre-commit pour :
- Validation YAML/Ansible
- Linting du code shell
- Vérification des clés privées
- Formatage automatique



## 🚨 Dépannage

### Problèmes courants

#### 1. Échec de jointure des workers

```bash
# Régénérer le token de jointure
vagrant ssh k8s-controlplan
sudo kubeadm token create --print-join-command

# Reprovisioner un worker
vagrant provision k8s-node1
```

#### 2. Problèmes réseau

```bash
# Vérifier la connectivité
ping 192.168.1.70

# Redémarrer les services réseau
sudo systemctl restart containerd kubelet
```

#### 3. Pods en erreur

```bash
# Diagnostic complet
kubectl describe node k8s-controlplan
kubectl get events --sort-by='.lastTimestamp'
```

### Logs détaillés

```bash
# Logs d'installation Ansible
vagrant up --debug

# Provisioning avec verbosité
vagrant provision --debug
```



## 🔄 Développement et contribution

### Tests locaux

```bash
# Validation des playbooks
ansible-lint playbook.yml

# Tests des hooks
pre-commit run --all-files
```

### Personnalisation

Pour modifier la configuration :

1. **Ressources VM** : Éditez le `Vagrantfile`
2. **Versions Kubernetes** : Modifiez `group_vars/all/main.yml`
3. **Composants supplémentaires** : Ajoutez des rôles dans `roles/`

## 📚 Documentation complémentaire

- [Documentation officielle Kubernetes](https://kubernetes.io/docs/)
- [Guide kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
- [Documentation Calico](https://docs.projectcalico.org/)
- [Ansible best practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

## 🎯 Roadmap

- [ ] Intégration Helm
- [ ] Monitoring avec Prometheus/Grafana
- [ ] Support LoadBalancer (MetalLB)
- [ ] Automatisation GitOps (ArgoCD)



## 👥 Contributors

- **Author**: Xavier GUERET
  [![GitHub followers](https://img.shields.io/github/followers/xgueret?style=social)](https://github.com/xgueret) [![Twitter Follow](https://img.shields.io/twitter/follow/xgueret?style=social)](https://x.com/hixmaster) [![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/xavier-gueret-47bb3019b/)

## ✨ Contributing

Contributions are welcome! Please feel free to submit a [Pull Request](https://github.com/xgueret/vagrant-k8s-cluster/pulls).
