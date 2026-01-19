# Guide d'Installation Rapide - Piwigo Helm Chart

## Installation Basique

```bash
# Installation avec les paramètres par défaut
helm install piwigo ./piwigo
```

## Scénarios Courants

### 1. Installation avec Ingress (accès depuis l'extérieur)

```bash
helm install piwigo ./piwigo \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=photos.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix
```

### 2. Installation avec Base de Données Externe (MySQL/MariaDB)

```bash
# Créer d'abord un secret pour le mot de passe
kubectl create secret generic piwigo-db-secret \
  --from-literal=password=your-secure-password

# Installer avec la configuration de base de données
helm install piwigo ./piwigo \
  --set database.enabled=true \
  --set database.type=mysql \
  --set database.host=mysql.default.svc.cluster.local \
  --set database.name=piwigo \
  --set database.user=piwigo \
  --set database.existingSecret=piwigo-db-secret
```

### 3. Installation en Production avec Ingress et TLS

```bash
# Installation avec le fichier de valeurs de production
helm install piwigo ./piwigo -f piwigo/values-production.yaml

# Ou avec des paramètres en ligne de commande
helm install piwigo ./piwigo \
  --set image.tag=14.5.0-ls266 \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=photos.example.com \
  --set ingress.tls[0].secretName=piwigo-tls \
  --set ingress.tls[0].hosts[0]=photos.example.com \
  --set persistence.config.storageClass=fast-ssd \
  --set persistence.config.size=2Gi \
  --set persistence.gallery.storageClass=standard \
  --set persistence.gallery.size=100Gi
```

### 4. Installation avec Stockage Existant

```bash
helm install piwigo ./piwigo \
  --set persistence.config.existingClaim=my-existing-config-pvc \
  --set persistence.gallery.existingClaim=my-existing-gallery-pvc
```

### 5. Configuration des Ressources

```bash
helm install piwigo ./piwigo \
  --set resources.requests.cpu=250m \
  --set resources.requests.memory=256Mi \
  --set resources.limits.cpu=500m \
  --set resources.limits.memory=512Mi
```

## Mise à Jour

```bash
# Mettre à jour vers une nouvelle version
helm upgrade piwigo ./piwigo \
  --set image.tag=14.5.0-ls267

# Mettre à jour avec de nouvelles valeurs
helm upgrade piwigo ./piwigo -f my-values.yaml
```

## Désinstallation

```bash
# Désinstaller le chart (conserve les PVC)
helm uninstall piwigo

# Supprimer aussi les PVC
kubectl delete pvc piwigo-config piwigo-gallery
```

## Accès à l'Application

### Avec Port-Forward (développement)

```bash
kubectl port-forward svc/piwigo 8080:80
# Accédez à http://localhost:8080
```

### Avec Ingress

L'application sera accessible à l'URL configurée dans ingress.hosts.

## Vérification de l'Installation

```bash
# Vérifier le statut du déploiement
kubectl get pods -l app.kubernetes.io/name=piwigo

# Voir les logs
kubectl logs -l app.kubernetes.io/name=piwigo -f

# Vérifier les volumes persistants
kubectl get pvc
```

## Dépannage

### Le pod ne démarre pas

```bash
# Vérifier les événements
kubectl describe pod -l app.kubernetes.io/name=piwigo

# Vérifier les logs
kubectl logs -l app.kubernetes.io/name=piwigo
```

### Problèmes de permissions

Vérifiez que les valeurs PUID et PGID correspondent aux permissions de vos volumes.

### Problèmes de base de données

Vérifiez que la base de données est accessible et que les credentials sont corrects:

```bash
# Tester la connexion depuis le pod
kubectl exec -it $(kubectl get pod -l app.kubernetes.io/name=piwigo -o name) -- sh
# Dans le pod:
# telnet mysql-host 3306
```

## Support

- [Documentation Helm Chart](piwigo/README.md)
- [Documentation Piwigo](https://piwigo.org/doc/doku.php)
- [Issues GitHub](https://github.com/GeVa2072/piwigo-helm-chart/issues)
