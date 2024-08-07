# k8s-workstation

### Infos 
la création de PV est dynamique chez OVH. Il ne faut activer que pvc.yaml et non pv.yaml

le PVC sert à la fois au crontask et au pod. 
la clé ssh privée est injectée via un secret (elle n'est pas sur le repo !)

### Cronjob
un cronjob existe il permet de faire une sauvegarde d'un serveur via Rsync avec une connexion ssh. il se lance toutes les 30 minutes et exploite le PVC.

Lancement : 
- secret.yaml
- pvc.yaml
- cronjob.yaml

Pour accéder à la sauvegarde :
- secret.yaml
- pvc.yaml
- pod.yaml

### WIP
la connexion directe via ssh ne fonctionne pas
il est possible de se connecter via kubectl
````
kubectl exec -it ubuntu-pod -- /bin/bash 
```

### lancement
```
./run.sh 
```

### arrêt
```
./stop.sh 
```
