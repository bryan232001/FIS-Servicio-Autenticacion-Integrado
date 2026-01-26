# Servidor Integrado de Directorio y Autenticación (FIS-EPN)

Este repositorio contiene la implementación de un sistema de gestión de identidades centralizado para la Facultad de Ingeniería de Sistemas (FIS). La solución integra las capacidades de almacenamiento jerárquico de **OpenLDAP** con el protocolo de seguridad de **Kerberos**, permitiendo un entorno de autenticación moderna y eficiente.

---

##  ¿Qué logré con este proyecto?

* **Implementación de Single Sign-On (SSO):** Logré que los usuarios se autentiquen una sola vez para acceder a múltiples servicios de forma segura.
* **Directorio Organizado:** Estructuración profesional del directorio mediante Unidades Organizativas (ou=profesores, ou=estudiantes).
* **Criptografía Robusta:** Configuración de un Reino de Kerberos (`FIS.EPN.EC`) para evitar el envío de contraseñas en texto plano.
* **Persistencia en WSL:** Detección dinámica de IP para asegurar que el hostname `auth-server.fis.epn.ec` resuelva correctamente en entornos virtuales.

---

## Requisitos Críticos de Infraestructura
Para que el protocolo Kerberos opere correctamente, el sistema garantiza dos pilares fundamentales:

1. Sincronización Horaria (NTP): Kerberos requiere que la diferencia horaria entre cliente y servidor sea < 5 minutos para prevenir ataques de denegación.

2. Resolución DNS: El servidor depende de que el hostname institucional resuelva correctamente mediante el archivo /etc/hosts.

##  Estructura del Proyecto

La organización del repositorio sigue un esquema modular para facilitar el mantenimiento:

```text
.
├── configs/
│   └── krb5/            # Archivos de configuración del Reino Kerberos (FIS.EPN.EC)
├── data/
│   └── ldif/            # Definiciones de objetos y estructura del directorio
├── docs/                # Documentación técnica, análisis y diseño
├── README.md            # Guía de usuario y documentación general
└── YungaB-Proyecto2.sh  # Script maestro de despliegue automatizado
```
## Consideraciones sobre la Seguridad del Ticket

Para facilitar la revisión académica, el sistema utiliza la credencial predeterminada (contraseña123)

Sin embargo, el diseño del servidor se centra en demostrar la integridad del ticket de Kerberos.

El protocolo garantiza que el ticket generado sea inalterable y esté protegido por hashes criptográficos, asegurando que el acceso a los servicios sea resistente a intentos de suplantación en
tránsito.

## Instalación Rápida

Siga estos pasos de forma secuencial para desplegar el servidor en su terminal de Ubuntu WSL:

---

Paso 1: Clonación del repositorio

Descargue el código fuente y acceda al directorio del proyecto:

Ejecutar Comandos
```bash
git clone https://github.com/bryan232001/FIS-Servicio-Autenticacion-Integrado.git

cd FIS-Servicio-Autenticacion-Integrado
```
Paso 2: Asignación de permisos al orquestador

Otorgue permisos de ejecución al script maestro para poder iniciar la configuración:

Ejecutar Comando
```bash
chmod +x YungaB-Proyecto2.sh
```
Paso 3: Ejecución del despliegue automático

Inicie el proceso de configuración automática del servidor. Este paso instalará las dependencias necesarias y sincronizará los servicios de Kerberos y LDAP de forma desatendida:

Ejecutar Comando
```bash
sudo ./YungaB-Proyecto2.sh
```

---

 ## Validación del Sistema

Una vez finalizada la instalación, puede verificar la correcta integración de los servicios ejecutando los siguientes comandos en su terminal:


Solicitar Ticket de Identidad: 

Obtenga su ticket inicial de Kerberos para el usuario institucional vinculado al Reino FIS.EPN.EC:

Ejecutar Comando y coloque por unica vez la contraseña que esta predeterminada para todos los usuarios (contraseña123)

```bash
kinit byunga
```
Verificar Ticket Activo: 

Compruebe la validez, el reino (FIS.EPN.EC) y la caducidad de su credencial actual:

Ejecutar Comando
```bash
klist
```
Comprobar Acceso al Directorio (SSO): 

Valide la integración mediante el mecanismo GSSAPI para confirmar que el servidor permite el acceso sin requerir el ingreso manual de contraseñas:

Ejecutar Comando
```bash
ldapwhoami -Y GSSAPI
```

---

## Nota Final: 

Si el tercer paso le devuelve el nombre del usuario correctamente
(ej. dn:uid=byunga,ou=people,dc=fis,dc=epn,dc=ec), el sistema de Single Sign-On está operando de forma exitosa bajo los estándares de la Politécnica.

## Estructura Institucional (Usuarios Reales)
El sistema cuenta con la siguiente jerarquía ya configurada:

| Rol        | Usuario (UID)                    | Unidad Organizativa (OU) |
|------------|----------------------------------|--------------------------|
| Docente    | emafla (Enrique Mafla)            | ou=profesores            |
| Estudiante | byunga (Bryan Yunga)              | ou=estudiantes           |
| Estudiante | abautista (Alexis Bautista)       | ou=estudiantes           |
| Estudiante | acorrea (Adrian Correa)           | ou=estudiantes           |
| Estudiante | svite (Santiago Vite)             | ou=estudiantes           |


##  Guía de Registro de un Nuevo Usuario (Juan Perez)

El sistema está diseñado para gestionar múltiples identidades institucionales. Siga este procedimiento para registrar al usuario **Juan Perez** (`jperez`) y validar el funcionamiento del esquema de Single Sign-On:

---

### Paso 1: Creación del Principal en Kerberos
Defina la identidad y la clave de acceso en el Centro de Distribución de Claves (KDC):

```bash
sudo kadmin.local -q "addprinc jperez"
```
Nota: El sistema le solicitará ingresar una contraseña dos veces (ej. contraseña123).

Paso 2: Creación del Perfil de Identidad (LDIF)

Para que el usuario sea reconocido por el directorio de la facultad, cree un archivo de configuración con sus atributos:

Abra el editor de texto:

Ejecutar comando:

```bash
nano juan_perez.ldif
```
Pegue el siguiente contenido:

```bash
dn: uid=jperez,ou=people,dc=fis,dc=epn,dc=ec
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: Juan Perez
sn: Perez
uid: jperez
uidNumber: 2001
gidNumber: 2001
homeDirectory: /home/jperez
loginShell: /bin/bash
```
Guarde los cambios (Ctrl + O, Enter) y salga del editor (Ctrl + X).

Paso 3: Sincronización con OpenLDAP

Cargue los atributos del usuario al servidor jerárquico utilizando las credenciales de administrador:

Ejecutar comando
```bash
ldapadd -x -D "cn=admin,dc=fis,dc=epn,dc=ec" -W -f juan_perez.ldif
```

Paso 4: Validación de Identidad y SSO

Finalmente, compruebe que el nuevo usuario puede obtener un ticket de seguridad y ser identificado por el directorio mediante GSSAPI:

Ejecutar Comando

## 1. Obtener ticket de Kerberos
```bash
kinit jperez
klist
```

## 2. Verificar identidad en el directorio sin reingresar contraseña
```bash
ldapwhoami -Y GSSAPI
```

Estudiante: Bryan Yunga

Escuela Politécnica Nacional - FIS
