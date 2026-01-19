# Quick Start Guide - Piwigo Helm Chart

## Installation rapide / Quick Installation

### Prérequis / Prerequisites
- Kubernetes cluster (v1.19+)
- Helm 3.x
- kubectl configuré / kubectl configured

### Installation en 3 étapes / 3-step installation

#### 1. Cloner le repository / Clone the repository
```bash
git clone https://github.com/GeVa2072/piwigo-helm-chart.git
cd piwigo-helm-chart
```

#### 2. (Optionnel) Personnaliser les valeurs / (Optional) Customize values
```bash
# Copier le fichier d'exemple / Copy the example file
cp values-example.yaml my-values.yaml

# Éditer avec vos paramètres / Edit with your settings
nano my-values.yaml
```

**Important**: Changez les identifiants de la base de données!
**Important**: Change the database credentials!

```yaml
mariadb:
  auth:
    username: "your_secure_username"
    password: "your_secure_password"
    database: "piwigo_production"
```

#### 3. Installer avec Helm / Install with Helm

Installation par défaut / Default installation:
```bash
helm install my-piwigo .
```

Installation avec valeurs personnalisées / Installation with custom values:
```bash
helm install my-piwigo . -f my-values.yaml
```

### Accéder à Piwigo / Access Piwigo

Suivre les instructions affichées après l'installation:
Follow the instructions displayed after installation:

```bash
export POD_NAME=$(kubectl get pods -l "app.kubernetes.io/name=piwigo,app.kubernetes.io/instance=my-piwigo" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:80
```

Puis ouvrir / Then open: http://localhost:8080

### Configuration initiale de Piwigo / Initial Piwigo Setup

Lors de la première connexion, utiliser:
On first connection, use:

- **Database Host**: `my-piwigo-mariadb` (ou `<release-name>-mariadb`)
- **Database Name**: valeur de `mariadb.auth.database` (défaut: `d`)
- **Database User**: valeur de `mariadb.auth.username` (défaut: `u`)
- **Database Password**: valeur de `mariadb.auth.password` (défaut: `p`)

### Commandes utiles / Useful commands

```bash
# Voir le statut / Check status
helm status my-piwigo
kubectl get pods

# Voir les logs / View logs
kubectl logs -l app.kubernetes.io/name=piwigo

# Mettre à jour / Update
helm upgrade my-piwigo . -f my-values.yaml

# Désinstaller / Uninstall
helm uninstall my-piwigo
```

### Exposition externe / External Exposure

Pour exposer Piwigo à l'extérieur du cluster:
To expose Piwigo outside the cluster:

**Option 1: LoadBalancer** (cloud providers)
```yaml
piwigo:
  service:
    type: LoadBalancer
```

**Option 2: NodePort**
```yaml
piwigo:
  service:
    type: NodePort
```

**Option 3: Ingress** (recommandé / recommended)
Créer un Ingress séparément pour plus de flexibilité.
Create a separate Ingress for more flexibility.

### Troubleshooting

```bash
# Vérifier les événements / Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# Décrire les pods / Describe pods
kubectl describe pod <pod-name>

# Vérifier les PVC / Check PVCs
kubectl get pvc

# Logs MariaDB
kubectl logs -l app.kubernetes.io/name=piwigo-mariadb
```

### Support

Pour plus d'informations, consulter le README.md complet.
For more information, see the full README.md.
