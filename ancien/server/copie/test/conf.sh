#!/bin/bash

# Script pour revenir à la configuration précédente de Nginx

# Chemin vers le fichier de configuration de Nginx
nginx_conf="/etc/nginx/nginx.conf"

# Chemin vers la sauvegarde du fichier de configuration d'origine
backup_file="$nginx_conf.bak"

# Vérifier si la sauvegarde existe avant de restaurer
if [ -f "$backup_file" ]; then
    # Restaurer le fichier de configuration d'origine
    cp "$backup_file" "$nginx_conf"
    rm "$backup_file"

    # Redémarrer Nginx pour appliquer la configuration d'origine
    systemctl restart nginx

    echo "La configuration a été restaurée à l'état antérieur."
else
    echo "Aucun fichier de sauvegarde trouvé. Aucune action n'a été effectuée."
fi

# Test avec curl pour montrer plusieurs vulnérabilités avant la sécurisation

# Remplacez l'URL par celle de votre serveur Nginx
target_url="http://192.168.0.2"

echo "Tests sans sécurité :"
echo "---------------------"

# Test 1 : Vérification de la version de Nginx
curl -I "$target_url"

# Test 2 : Vérification des méthodes HTTP autorisées (peut montrer une vulnérabilité)
curl -X TRACE "$target_url"

# Test 3 : Vérification des headers HTTP (peut montrer une vulnérabilité)
curl -I -H "Host: evil-attacker.com" "$target_url"
