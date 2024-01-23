#!/bin/bash

#Bloquer tout le trafic entrant
ufw default deny incoming
#Autoriser le trafic sortant
ufw default allow outgoing
ufw allow in on eth1 to any port 443
ufw allow in on eth2 to any port 443
ufw allow 22
ufw --force enable

echo "Pare feu activé."
