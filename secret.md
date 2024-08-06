### 1. Créer un Secret Kubernetes

Vous devez d'abord créer un Secret Kubernetes qui contient votre clé SSH privée. Voici comment le faire en utilisant un fichier YAML :

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ssh-key-secret
type: Opaque
data:
  ssh-privatekey: <clé_privée_base64>
```

Pour encoder votre clé SSH privée en base64, vous pouvez utiliser la commande suivante :

```sh
cat /chemin/vers/votre/clé/privée | base64 -w 0
```

Remplacez `<clé_privée_base64>` par le résultat de cette commande. Ensuite, vous pouvez créer le Secret dans votre cluster Kubernetes avec la commande suivante :

```sh
kubectl apply -f secret.yaml
```

### 2. Monter le Secret dans un Pod

Ensuite, vous devez modifier votre fichier de déploiement pour monter le Secret en tant que volume dans votre pod. Voici un exemple de configuration :

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ssh-client
spec:
  containers:
  - name: my-container
    image: your-docker-image:latest
    volumeMounts:
    - name: ssh-key-volume
      mountPath: "/root/.ssh"
      readOnly: true
  volumes:
  - name: ssh-key-volume
    secret:
      secretName: ssh-key-secret
      items:
      - key: ssh-privatekey
        path: id_rsa
```

Dans cet exemple :

- Le Secret est monté en tant que volume dans le chemin `/root/.ssh` du conteneur.
- Le fichier `id_rsa` est créé à partir du Secret.

### 3. S'assurer des permissions correctes

Pour des raisons de sécurité, vous devrez peut-être ajuster les permissions du fichier de clé SSH. Vous pouvez le faire en utilisant une init container pour modifier les permissions avant que l'application principale ne démarre :

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ssh-client
spec:
  initContainers:
  - name: init-permissions
    image: busybox
    command: ["sh", "-c", "chmod 400 /root/.ssh/id_rsa"]
    volumeMounts:
    - name: ssh-key-volume
      mountPath: "/root/.ssh"
  containers:
  - name: my-container
    image: your-docker-image:latest
    volumeMounts:
    - name: ssh-key-volume
      mountPath: "/root/.ssh"
      readOnly: true
  volumes:
  - name: ssh-key-volume
    secret:
      secretName: ssh-key-secret
      items:
      - key: ssh-privatekey
        path: id_rsa
```

Dans cet exemple, le conteneur d'initialisation `init-permissions` s'exécute avant le conteneur principal et modifie les permissions de la clé SSH.

### 4. Déploiement

Une fois que vous avez préparé votre fichier de déploiement, vous pouvez déployer votre pod avec la commande suivante :

```sh
kubectl apply -f deployment.yaml
```

Cette configuration vous permet de monter de manière sécurisée une clé SSH privée dans un pod Kubernetes en utilisant les Secrets, sans inclure la clé dans votre image Docker publique.