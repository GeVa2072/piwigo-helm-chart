# Piwigo Helm Chart

Ce chart Helm installe [Piwigo](https://piwigo.org/), une galerie photo pour le web, sur un cluster Kubernetes en utilisant l'image officielle de [LinuxServer.io](https://github.com/linuxserver/docker-piwigo).

## Prérequis

- Kubernetes 1.19+
- Helm 3.0+
- PV provisioner support dans le cluster sous-jacent (si la persistence est activée)

## Installation

### Ajouter le repository Helm (à venir)

```bash
helm repo add piwigo https://geva2072.github.io/piwigo-helm-chart
helm repo update
```

### Installer le chart

```bash
# Installation avec les valeurs par défaut
helm install my-piwigo piwigo/piwigo

# Installation avec des valeurs personnalisées
helm install my-piwigo piwigo/piwigo -f values.yaml

# Installation depuis le répertoire local
helm install my-piwigo ./piwigo
```

## Désinstallation

```bash
helm uninstall my-piwigo
```

## Configuration

Le tableau suivant liste les paramètres configurables du chart Piwigo et leurs valeurs par défaut.

### Paramètres de l'image

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `image.repository` | Repository de l'image Piwigo | `lscr.io/linuxserver/piwigo` |
| `image.tag` | Tag de l'image | `latest` |
| `image.pullPolicy` | Politique de pull de l'image | `IfNotPresent` |
| `imagePullSecrets` | Secrets pour pull les images | `[]` |

### Paramètres de déploiement

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `replicaCount` | Nombre de replicas | `1` |
| `nameOverride` | Override du nom du chart | `""` |
| `fullnameOverride` | Override du nom complet | `""` |

### Paramètres du Service Account

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `serviceAccount.create` | Créer un service account | `true` |
| `serviceAccount.annotations` | Annotations pour le service account | `{}` |
| `serviceAccount.name` | Nom du service account | `""` |

### Paramètres de sécurité

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `podSecurityContext.fsGroup` | Group ID pour les volumes | `1000` |
| `securityContext.runAsUser` | User ID pour exécuter le conteneur | `1000` |
| `securityContext.runAsGroup` | Group ID pour exécuter le conteneur | `1000` |
| `securityContext.runAsNonRoot` | Exécuter en tant que non-root | `true` |

### Paramètres du Service

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `service.type` | Type de service Kubernetes | `ClusterIP` |
| `service.port` | Port du service | `80` |
| `service.targetPort` | Port cible du conteneur | `80` |

### Paramètres d'Ingress

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `ingress.enabled` | Activer l'ingress | `false` |
| `ingress.className` | Classe d'ingress | `""` |
| `ingress.annotations` | Annotations pour l'ingress | `{}` |
| `ingress.hosts` | Hosts pour l'ingress | `[{host: piwigo.local, paths: [{path: /, pathType: Prefix}]}]` |
| `ingress.tls` | Configuration TLS | `[]` |

### Paramètres de persistence

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `persistence.config.enabled` | Activer la persistence pour la config | `true` |
| `persistence.config.size` | Taille du PVC pour la config | `1Gi` |
| `persistence.config.storageClass` | StorageClass pour la config | `""` |
| `persistence.config.accessMode` | Mode d'accès pour la config | `ReadWriteOnce` |
| `persistence.config.existingClaim` | PVC existant pour la config | `""` |
| `persistence.gallery.enabled` | Activer la persistence pour la galerie | `true` |
| `persistence.gallery.size` | Taille du PVC pour la galerie | `10Gi` |
| `persistence.gallery.storageClass` | StorageClass pour la galerie | `""` |
| `persistence.gallery.accessMode` | Mode d'accès pour la galerie | `ReadWriteOnce` |
| `persistence.gallery.existingClaim` | PVC existant pour la galerie | `""` |

### Variables d'environnement

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `env.PUID` | User ID pour les permissions | `1000` |
| `env.PGID` | Group ID pour les permissions | `1000` |
| `env.TZ` | Timezone | `Etc/UTC` |

### Paramètres de base de données (optionnel)

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `database.enabled` | Activer la configuration de base de données externe | `false` |
| `database.type` | Type de base de données (mysql, mariadb) | `""` |
| `database.host` | Host de la base de données | `""` |
| `database.port` | Port de la base de données | `3306` |
| `database.name` | Nom de la base de données | `piwigo` |
| `database.user` | Utilisateur de la base de données | `piwigo` |
| `database.password` | Mot de passe de la base de données | `""` |
| `database.existingSecret` | Secret existant contenant le mot de passe | `""` |

### Paramètres de ressources

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `resources.limits` | Limites de ressources | `{}` |
| `resources.requests` | Requêtes de ressources | `{}` |

### Autoscaling

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `autoscaling.enabled` | Activer l'autoscaling | `false` |
| `autoscaling.minReplicas` | Nombre minimum de replicas | `1` |
| `autoscaling.maxReplicas` | Nombre maximum de replicas | `100` |
| `autoscaling.targetCPUUtilizationPercentage` | Pourcentage cible d'utilisation CPU | `80` |

## Exemples de configuration

### Avec Ingress et TLS

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: photos.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: piwigo-tls
      hosts:
        - photos.example.com
```

### Avec base de données MySQL externe

```yaml
database:
  enabled: true
  type: mysql
  host: mysql.default.svc.cluster.local
  port: 3306
  name: piwigo
  user: piwigo
  password: "your-secure-password"
```

### Avec storage personnalisé

```yaml
persistence:
  config:
    enabled: true
    storageClass: fast-ssd
    size: 2Gi
  gallery:
    enabled: true
    storageClass: slow-hdd
    size: 100Gi
```

## Source du docker-compose officiel

Ce chart Helm a été généré à partir du docker-compose officiel de LinuxServer.io:

```yaml
---
services:
  piwigo:
    image: lscr.io/linuxserver/piwigo:latest
    container_name: piwigo
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/piwigo/config:/config
      - /path/to/appdata/gallery:/gallery
    ports:
      - 80:80
    restart: unless-stopped
```

## Support

- [Documentation Piwigo](https://piwigo.org/doc/doku.php)
- [LinuxServer.io Piwigo](https://docs.linuxserver.io/images/docker-piwigo)
- [Issues GitHub](https://github.com/GeVa2072/piwigo-helm-chart/issues)

## License

Ce projet est sous licence MIT - voir le fichier [LICENSE](../LICENSE) pour plus de détails.
