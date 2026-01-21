#!/bin/bash
# Proyecto 2 - FIS EPN
# Estudiante: Bryan Yunga

# 1. Variables de Entorno
DOMAIN="fis.epn.ec"
HOSTNAME="auth-server"
FQDN="$HOSTNAME.$DOMAIN"
REALM="FIS.EPN.EC"
IP_FIXED="192.168.234.42"

echo "Iniciando configuración del Servidor Integrado FIS..."

# 2. Configuración de Identidad (Persistencia)
sudo hostnamectl set-hostname $FQDN
echo "$IP_FIXED  $FQDN $HOSTNAME" | sudo tee -a /etc/hosts

# 3. Instalación de Servicios
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y slapd ldap-utils krb5-kdc krb5-admin-server krb5-config libsasl2-modules-gssapi-mit chrony

# 4. Configuración de Kerberos  FIS.EPN.EC
# Se asume que krb5.conf ya fue ajustado o se inyecta aquí
sudo kdb5_util create -s -P changeme 

# 5. Integración SASL/GSSAPI para LDAP
# Comandos para agregar el service principal y exportar keytab
sudo kadmin.local -q "addprinc -randkey ldap/$FQDN"
sudo kadmin.local -q "ktadd -k /etc/ldap/ldap.keytab ldap/$FQDN"
sudo chown openldap:openldap /etc/ldap/ldap.keytab

echo "Configuración completada. Sistema listo para validación GSSAPI."
