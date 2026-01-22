Servidor Integrado de Directorio y Autenticación (FIS-EPN)
¡Hola! Este repositorio contiene mi solución para el sistema de seguridad centralizada de la Facultad de Ingeniería de Sistemas (FIS). El objetivo fue crear un entorno donde la identidad y el acceso estén protegidos por estándares industriales, adaptados para funcionar de forma eficiente en Windows Subsystem for Linux (WSL).

¿Qué logré con este proyecto?
Implementé un sistema de Single Sign-On (SSO) que permite a los usuarios de la facultad autenticarse una sola vez para acceder a múltiples servicios.

Directorio: Estructuré la jerarquía de la FIS en OpenLDAP (dc=fis,dc=epn,dc=ec).

Criptografía: Utilicé un Reino de Kerberos (FIS.EPN.EC) para que nadie tenga que enviar su contraseña en texto plano por la red.

Persistencia: Superé el reto de mantener la identidad del servidor (auth-server.fis.epn.ec) en WSL mediante configuraciones avanzadas en wsl.conf.

Lo que necesitas para empezar
Este proyecto fue diseñado y probado exclusivamente en:

Entorno: Ubuntu bajo WSL (Windows Subsystem for Linux).

Permisos: Necesitarás ejecutar los comandos con sudo.

Red: El servidor utiliza la IP estática simulada 192.168.234.42.

Instalación Rápida
Para desplegar este servidor en tu propia máquina, solo sigue estos tres pasos:

Clona el repositorio:

Bash

git clone https://github.com/tu-usuario/tu-repositorio.git
cd tu-repositorio
Prepara el script:

Bash

chmod +x YungaB-Proyecto2.sh
Ejecuta la magia:

Bash

sudo ./YungaB-Proyecto2.sh
El script se encargará de instalar los paquetes, configurar tu hostname y levantar los servicios de Kerberos y LDAP por ti.

¿Cómo compruebo que funciona?
No confíes solo en mi palabra; ejecuta estos comandos en tu terminal para ver la integración en acción:

Pide un ticket de Kerberos: kinit byunga

Verifica tu ticket activo: klist

La prueba final (Identidad vía GSSAPI): ldapwhoami -Y GSSAPI

Si el sistema te reconoce sin pedirte la contraseña de nuevo, ¡la integración es un éxito!


