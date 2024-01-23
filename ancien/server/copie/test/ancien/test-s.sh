# Script pour appliquer les configurations de sécurité à Nginx

# Chemin vers le fichier de configuration de Nginx
nginx_conf="/etc/nginx/nginx.conf"

# Sauvegarde du fichier de configuration d'origine
if [ ! -e "$nginx_conf.bak" ]; then
	cp $nginx_conf $nginx_conf.bak
fi

request_method='$request_method'

# Mise à jour du fichier de configuration avec les nouvelles directives de sécurité
cat <<EOL > $nginx_conf
# nginx.conf

events {
    # Configuration des paramètres d'événements, par exemple, le nombre maximum de connexions simultanées
    worker_connections 2;
}

http {
    # Désactivation de l'information de la version de Nginx
    server_tokens off;

    # ... Autres configurations ...

    server {
        # ... Autres configurations du serveur ...

        # Désactivation des méthodes HTTP non sécurisées
        if ($request_method !~ ^(GET|HEAD|POST)$) {
            return 200;
        }

        # Configuration des headers HTTP pour prévenir certaines attaques
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-XSS-Protection "1; mode=block";

        # ... Autres configurations de sécurité ...
    }
}

EOL

# Redémarrage de Nginx pour appliquer les nouvelles configurations
systemctl restart nginx

# Test avec curl pour montrer la sécurité après la sécurisation

# Remplacez l'URL par celle de votre serveur Nginx
target_url="http://192.168.0.1"

echo "Tests avec sécurité :"
echo "---------------------"

# Test 1 : Vérification de la version de Nginx (devrait être masqué)
curl -I $target_url

# Test 2 : Vérification des méthodes HTTP (devrait être refusé)
curl -X TRACE $target_url

# Test 3 : Vérification des headers HTTP (devrait être filtré)
curl -I -H "Host: evil-attacker.com" $target_url
