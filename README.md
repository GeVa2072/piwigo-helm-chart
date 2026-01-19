# piwigo-helm-chart

Helm Chart d'installation de l'image Officiel Piwigo.

## À propos

Ce repository contient un chart Helm pour déployer [Piwigo](https://piwigo.org/), une galerie photo pour le web, sur Kubernetes. Il utilise l'image Docker officielle de [LinuxServer.io](https://github.com/linuxserver/docker-piwigo).

## Installation rapide

```bash
# Cloner le repository
git clone https://github.com/GeVa2072/piwigo-helm-chart.git
cd piwigo-helm-chart

# Installer le chart avec Helm
helm install my-piwigo ./piwigo
```

## Documentation

Pour plus d'informations sur la configuration et l'utilisation, consultez le [README du chart](piwigo/README.md).

## Fonctionnalités

- ✅ Déploiement de Piwigo basé sur le docker-compose officiel
- ✅ Support de la persistence pour les configurations et les images
- ✅ Configuration Ingress pour l'accès externe
- ✅ Support des bases de données externes (MySQL/MariaDB)
- ✅ Configuration des ressources et autoscaling
- ✅ Configuration de sécurité (SecurityContext, ServiceAccount)

## Prérequis

- Kubernetes 1.19+
- Helm 3.0+
- PV provisioner support dans le cluster (si la persistence est activée)

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

