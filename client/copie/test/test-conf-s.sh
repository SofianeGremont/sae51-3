#!/bin/bash

target_url="192.168.0.2:443"

echo "Tests avec sécurité :"
echo "---------------------"

# Test 1 : Vérification de Nginx
curl -I "$target_url"

# Test 2 : Vérification des méthodes HTTP autorisées
curl -X TRACE "$target_url"
