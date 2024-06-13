#!/bin/bash

# Définir le nom du fichier pour la clé SSH
key_name="mykey"

# Définir le chemin complet de la clé privée
key_path="/root/.ssh/${key_name}"

# Créer le répertoire .ssh s'il n'existe pas
mkdir -p /root/.ssh

# Obtenir l'IP du conteneur
# Supposons que vous utilisez Docker, vous pouvez utiliser la commande suivante pour obtenir l'IP du conteneur :
container_ip=$(hostname -I | awk '{print $1}')

# Si vous utilisez un autre environnement ou méthode, remplacez la ligne ci-dessus par la méthode appropriée pour obtenir l'IP.

if [ -f "$key_path" ]; then
    echo "La clé privée $key_path existe déjà. Aucune nouvelle clé ne sera générée."
else
    # Générer la paire de clés SSH avec l'IP du conteneur dans le commentaire
    ssh-keygen -t rsa -b 4096 -f "$key_path" -N "" -C "root@${container_ip}"
fi
