#!/bin/bash

# Script pour appliquer les configurations de sécurité à Nginx
ufw disable

# Test avec curl pour montrer la sécurité après la sécurisation

# Remplacez l'URL par celle de votre serveur Nginx
target_url="192.168.0.2:443"

echo "Tests sans sécurité :"
echo "---------------------"

# Test 1 : Vérification de la version de Nginx (devrait être masquée)
curl -I "$target_url"

# Test 2 : Vérification des méthodes HTTP (devrait être refusée)
curl -X TRACE "$target_url"

# Test 3 : Vérification des headers HTTP (devrait être filtrée)
curl -I -H "Host: evil-attacker.com" "$target_url"
