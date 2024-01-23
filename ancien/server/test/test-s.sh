# Script pour appliquer les configurations de sécurité à Nginx
mkdir /etc/nginx/ssl
chmod 700 /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/example.key -out /etc/nginx/ssl/example.crt -subj "/C=US/ST=California/L=San Francisco/O=My Organization/CN=example.com/emailAddress=admin@example.com"
systemctl restart nginx
nginx -s reload

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
		    listen 443 ssl;
		    server_name 192.168.0.2;

		    ssl_certificate /etc/nginx/ssl/example.crt;
		    ssl_certificate_key /etc/nginx/ssl/example.key;

		    server_tokens off;

		    add_header X-Frame-Options "SAMEORIGIN" always;
		    add_header Strict-Transport-Security "max-age=31536000" always;
		    add_header X-Content-Type-Options "nosniff" always;

		    proxy_hide_header X-Powered-By;

		    add_header Referrer-Policy "origin-when-cross-origin" always;
		    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
		    add_header X-XSS-Protection "1; mode=block";

		    client_body_buffer_size 1k;
		    client_max_body_size 1k;
		    location / {
		        root /var/www/html;
		        index index.html;
		        try_files $uri $uri/ =404;
		        limit_except GET HEAD POST {
		            deny all;
		        }
		    }
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
