#!/bin/bash
# Proyecto 2 - FIS EPN
# Estudiante: Bryan Yunga

# 1. Variables de Entorno
DOMAIN="fis.epn.ec"
HOSTNAME="auth-server"
FQDN="$HOSTNAME.$DOMAIN"
REALM="FIS.EPN.EC"
IP_FIXED="192.168.234.42"
LDIF_PATH="data/ldif"  # Nueva ruta modular

echo "Iniciando configuración del Servidor Integrado FIS - EPN..."

# 2. Configuración de Identidad (Persistencia en WSL)
sudo hostnamectl set-hostname $FQDN
# Evitar duplicados en /etc/hosts
sudo sed -i "/$FQDN/d" /etc/hosts
echo "$IP_FIXED  $FQDN $HOSTNAME" | sudo tee -a /etc/hosts

# 3. Instalación de Servicios (Completado)
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y slapd ldap-utils krb5-kdc krb5-admin-server apache2 libapache2-mod-auth-gssapi

# 4. Inyectar Configuración desde el Repositorio
# Copiamos el krb5.conf que ya tienes en tu carpeta configs
sudo cp configs/krb5/krb5.conf /etc/krb5.conf

# 5. Configuración de Kerberos FIS.EPN.EC
# Solo crea la base si no existe
if [ ! -f /var/lib/krb5kdc/principal ]; then
    sudo kdb5_util create -s -P changeme
fi

# 6. Estructura de Directorio LDAP (Rutas Actualizadas)
# Usamos los archivos ldif de la nueva carpeta data/ldif/
echo "Cargando estructura jerárquica de la FIS..."
sudo ldapadd -x -D "cn=admin,dc=fis,dc=epn,dc=ec" -w changeme -f $LDIF_PATH/base_raiz.ldif
sudo ldapadd -x -D "cn=admin,dc=fis,dc=epn,dc=ec" -w changeme -f $LDIF_PATH/estructura.ldif
sudo ldapadd -x -D "cn=admin,dc=fis,dc=epn,dc=ec" -w changeme -f $LDIF_PATH/bryan.ldif

# 7. Integración SASL/GSSAPI para LDAP y HTTP
# Agregamos los service principals y exportamos keytabs
sudo kadmin.local -q "addprinc -randkey ldap/$FQDN"
sudo kadmin.local -q "addprinc -randkey HTTP/$FQDN"
sudo kadmin.local -q "ktadd -k /etc/ldap/ldap.keytab ldap/$FQDN"
sudo kadmin.local -q "ktadd -k /etc/apache2/http.keytab HTTP/$FQDN"

# 8. Permisos de Seguridad
sudo chown openldap:openldap /etc/ldap/ldap.keytab
sudo chown www-data:www-data /etc/apache2/http.keytab
sudo chmod 640 /etc/apache2/http.keytab

# 9. Reinicio de Servicios
sudo systemctl restart slapd apache2 krb5-kdc

echo "--------------------------------------------------------"
echo "Configuración completada para el Reino $REALM"
echo "Validación KVNO para HTTP:"
kvno HTTP/$FQDN
echo "--------------------------------------------------------"
