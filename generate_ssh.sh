#!/bin/bash

# Définir le nom du fichier pour la clé SSH
key_name="mykey"

# Définir le chemin complet de la clé privée
key_path="/root/.ssh/${key_name}"

# Créer le répertoire .ssh s'il n'existe pas
mkdir -p /root/.ssh


if [ -f "$key_path" ]; then
    echo "La clé privée $key_path existe déjà. Aucune nouvelle clé ne sera générée."
else
    # Générer la paire de clés SSH
    ssh-keygen -t rsa -b 4096 -f "$key_path" -N ""
fi

