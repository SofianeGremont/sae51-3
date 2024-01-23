#!/bin/bash

target_url="http://192.168.0.2"

echo "Tests sans sécurité :"
echo "---------------------"

# Test 1 : Vérification de Nginx
curl -I "$target_url"

# Test 2 : Vérification des méthodes HTTP autorisées
curl -X TRACE "$target_url"
