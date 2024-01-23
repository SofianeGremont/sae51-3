#!/bin/bash

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

echo "Sécurité désactivée."
