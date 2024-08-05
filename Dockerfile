# Utiliser la dernière version d'Ubuntu
FROM ubuntu:latest

# Mettre à jour les paquets et installer les outils nécessaires
RUN apt-get update && \
    apt-get install -y openssh-server iputils-ping net-tools curl wget vim tree sudo gnupg2 software-properties-common && \
    mkdir /var/run/sshd

# Installer Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Ajouter un utilisateur avec sudo sans mot de passe
RUN useradd -m -d /home/dockeruser -s /bin/bash dockeruser && \
    echo "dockeruser:dockeruser" | chpasswd && \
    usermod -aG sudo dockeruser && \
    echo "dockeruser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configurer SSH pour permettre la connexion par clé
RUN mkdir /home/dockeruser/.ssh && \
    chmod 700 /home/dockeruser/.ssh

# Copie des clés SSH depuis un fichier externe
COPY authorized_keys /home/dockeruser/.ssh/authorized_keys
RUN chmod 600 /home/dockeruser/.ssh/authorized_keys && \
    chown -R dockeruser:dockeruser /home/dockeruser/.ssh

# Exposer le port SSH
EXPOSE 22

# Commande pour lancer le serveur SSH
CMD ["/usr/sbin/sshd", "-D"]