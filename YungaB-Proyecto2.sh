#!/bin/bash
# Proyecto 2 FIS-EPN
# Estudiante: Bryan Yunga

# 1. Variables y Detección de Red
DOMAIN="fis.epn.ec"
HOSTNAME="auth-server"
FQDN="$HOSTNAME.$DOMAIN"
# Detecta automáticamente la IP de tu VirtualBox
IP_REAL=$(hostname -I | awk '{print $1}')

echo "--- Iniciando Configuración Automatizada del Reino FIS.EPN.EC ---"

# 2. Configuración de Identidad y Red
sudo hostnamectl set-hostname $FQDN
# Limpia el archivo hosts de entradas antiguas del proyecto
sudo sed -i "/$DOMAIN/d" /etc/hosts
echo "$IP_REAL $FQDN $HOSTNAME" | sudo tee -a /etc/hosts

# 3. Instalación de Servicios
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y slapd ldap-utils krb5-kdc krb5-admin-server

# 4. Solución al Error 80 de SASL (Keytab)
# Creamos el enlace simbólico para que el sistema encuentre la llave
sudo ln -sf /etc/ldap/ldap.keytab /etc/krb5.keytab

# 5. Registro Automático de Usuarios en Kerberos
# Esto evita el error 'Client not found'
echo "Registrando principales de servicio y usuario..."
sudo kadmin.local -q "addprinc -randkey ldap/$FQDN"
sudo kadmin.local -q "ktadd -k /etc/ldap/ldap.keytab ldap/$FQDN"
# Aquí creamos tu usuario con una contraseña por defecto
sudo kadmin.local -q "addprinc -pw Contraseña123 byunga"

# 6. Permisos y Reinicio
sudo chown openldap:openldap /etc/ldap/ldap.keytab
sudo systemctl restart slapd krb5-kdc

echo "--- DESPLIEGUE EXITOSO ---"
echo "IP Detectada: $IP_REAL"
echo "Prueba ahora: kinit byunga (Contraseña: Contraseña123)"
