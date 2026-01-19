# Piwigo Helm Chart

Helm Chart d'installation de l'image Officiel Piwigo.

## Description

Ce chart Helm permet de déployer Piwigo (galerie photo) avec une base de données MariaDB sur Kubernetes.

## Installation

### Ajouter le repository (si applicable)
```bash
helm repo add piwigo https://geva2072.github.io/piwigo-helm-chart
helm repo update
```

### Installation du chart
```bash
helm install my-piwigo piwigo/piwigo
```

Ou directement depuis les sources :
```bash
helm install my-piwigo .
```

## Configuration

Les paramètres suivants peuvent être configurés dans `values.yaml` :

### Piwigo Application

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `piwigo.image.repository` | Image Docker Piwigo | `piwigo/piwigo` |
| `piwigo.image.tag` | Tag de l'image | `latest` |
| `piwigo.timezone` | Timezone | `FR` |
| `piwigo.service.type` | Type de service Kubernetes | `ClusterIP` |
| `piwigo.service.port` | Port du service | `80` |
| `piwigo.persistence.gallery.enabled` | Activer la persistance pour la galerie | `true` |
| `piwigo.persistence.gallery.size` | Taille du volume | `10Gi` |
| `piwigo.persistence.script.enabled` | Activer la persistance pour les scripts | `true` |
| `piwigo.persistence.script.size` | Taille du volume | `1Gi` |

### MariaDB Database

| Paramètre | Description | Défaut |
|-----------|-------------|--------|
| `mariadb.enabled` | Activer MariaDB | `true` |
| `mariadb.image.repository` | Image Docker MariaDB | `docker.io/library/mariadb` |
| `mariadb.image.tag` | Tag de l'image | `lts` |
| `mariadb.auth.username` | Utilisateur de base de données | `u` |
| `mariadb.auth.password` | Mot de passe | `p` |
| `mariadb.auth.database` | Nom de la base de données | `d` |
| `mariadb.persistence.enabled` | Activer la persistance | `true` |
| `mariadb.persistence.size` | Taille du volume | `8Gi` |

## Exemple de configuration personnalisée

```yaml
piwigo:
  timezone: "Europe/Paris"
  service:
    type: LoadBalancer

mariadb:
  auth:
    username: "piwigo_user"
    password: "secure_password"
    database: "piwigo_db"
  persistence:
    size: 20Gi
```

Installer avec la configuration personnalisée :
```bash
helm install my-piwigo . -f custom-values.yaml
```

## Désinstallation

```bash
helm uninstall my-piwigo
```

## Basé sur Docker Compose

Ce chart a été créé à partir de la configuration Docker Compose suivante :

```yaml
piwigo:
  image: piwigo/piwigo:latest
  environment:
    - TZ=FR
  ports:
    - 80:80
  volumes:
    - ./gallery:/var/www/html/piwigo/
    - ./script:/usr/local/bin/scripts/

piwigo-db:
  image: docker.io/library/mariadb:lts
  environment:
    - MARIADB_RANDOM_ROOT_PASSWORD=true
    - MARIADB_USER=u
    - MARIADB_DATABASE=d
    - MARIADB_PASSWORD=p
    - TZ=FR
  volumes:
    - ./mysql:/var/lib/mysql
```
