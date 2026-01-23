#!/bin/bash
# Proyecto 2 FIS-EPN: Versión actual
# Estudiante: Bryan Yunga

DOMAIN="fis.epn.ec"
REALM="FIS.EPN.EC"
HOSTNAME="auth-server"
FQDN="$HOSTNAME.$DOMAIN"
IP_REAL=$(hostname -I | awk '{print $1}')

echo "--- BIENVENIDOS AL SERVICIO DE AUTENTICACIÓN INTEGRADO ---"
echo "----------------------------------------------------------"
echo "--- Iniciando Configuración Automática Total ---"

# 1. Configurar Hostname e IP
sudo hostnamectl set-hostname $FQDN
sudo sed -i "/$DOMAIN/d" /etc/hosts
echo "$IP_REAL $FQDN $HOSTNAME" | sudo tee -a /etc/hosts

# 2. Pre-configurar Kerberos (ESTO EVITA EL ERROR DE REINO)
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y krb5-kdc krb5-admin-server slapd ldap-utils

echo "Escribiendo configuración de Kerberos..."
sudo tee /etc/krb5.conf <<EOF
[libdefaults]
    default_realm = $REALM

[realms]
    $REALM = {
        kdc = $FQDN
        admin_server = $FQDN
    }

[domain_realm]
    .$DOMAIN = $REALM
    $DOMAIN = $REALM
EOF

# 3. Inicializar la base de datos de Kerberos 
sudo kdb5_util create -s -P Contraseña123

# 4. Crear Principales y Keytabs
sudo kadmin.local -q "addprinc -randkey ldap/$FQDN"
sudo kadmin.local -q "ktadd -k /etc/ldap/ldap.keytab ldap/$FQDN"
sudo kadmin.local -q "addprinc -pw Contraseña123 byunga"

# 5. Permisos y Enlaces
sudo ln -sf /etc/ldap/ldap.keytab /etc/krb5.keytab
sudo chown openldap:openldap /etc/ldap/ldap.keytab

# 6. Reiniciar Servicios
sudo systemctl restart krb5-kdc krb5-admin-server slapd

echo "--- DESPLIEGUE EXITOSO REAL ---"
echo "Prueba ahora: kinit byunga "
