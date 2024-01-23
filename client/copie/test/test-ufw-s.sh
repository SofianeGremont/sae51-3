#!/bin/bash

target_url="192.168.0.2"

echo "Tests avec sécurité :"
echo "---------------------"

# Test 1 : Vérification des ports
nmap -Pn $target_url

# Test 2 : accéder au serveur web http
echo " "
echo "Tenter d'accéder au serveur web en http"
curl http://192.168.0.2
