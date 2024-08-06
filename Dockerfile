# Utiliser la dernière version d'Ubuntu
FROM ubuntu:latest

# Mettre à jour les paquets et installer les outils nécessaires
RUN apt-get update && \
    apt-get install -y openssh-server iputils-ping net-tools curl wget vim tree sudo gnupg2 software-properties-common rsync cron && \
    mkdir /var/run/sshd

# Configurer SSH pour permettre la connexion par clé
RUN mkdir /home/ubuntu/.ssh && \
    chmod 700 /home/ubuntu/.ssh

# Copie des clés SSH depuis un fichier externe
COPY authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chmod 600 /home/ubuntu/.ssh/authorized_keys && \
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# Exposer le port SSH
EXPOSE 22

# Commande pour lancer le serveur SSH
CMD ["/usr/sbin/sshd", "-D"]