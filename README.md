# Servidor Integrado de Directorio y Autenticación (FIS-EPN)

Este repositorio contiene la implementación de un sistema de gestión de identidades centralizado para la Facultad de Ingeniería de Sistemas (FIS). La solución integra las capacidades de almacenamiento jerárquico de **OpenLDAP** con el protocolo de seguridad de **Kerberos**, permitiendo un entorno de autenticación moderna y eficiente.

---

## 🚀 ¿Qué logré con este proyecto?

* **Implementación de Single Sign-On (SSO):** Logré que los usuarios se autentiquen una sola vez para acceder a múltiples servicios de forma segura.
* **Directorio Organizado:** Estructuración de la jerarquía institucional en OpenLDAP bajo el sufijo `dc=fis,dc=epn,dc=ec`.
* **Criptografía Robusta:** Configuración de un Reino de Kerberos (`FIS.EPN.EC`) para evitar el envío de contraseñas en texto plano.
* **Persistencia en WSL:** Detección dinámica de IP para asegurar que el hostname `auth-server.fis.epn.ec` resuelva correctamente en entornos virtuales.

---

## 📂 Estructura del Proyecto

La organización del repositorio sigue un esquema modular para facilitar el mantenimiento:

```text
.
├── configs/
│   └── krb5/            # Archivos de configuración del Reino Kerberos
├── data/
│   └── ldif/            # Definiciones de objetos y estructura del directorio
├── docs/                # Documentación técnica, análisis y diseño
├── README.md            # Guía de usuario y documentación general
└── YungaB-Proyecto2.sh  # Script maestro de despliegue automatizado
```
🔐 Consideraciones sobre la Seguridad del Ticket

Para facilitar la revisión académica, el sistema utiliza la credencial predeterminada (Contraseña123.)

Sin embargo, el diseño del servidor se centra en demostrar la integridad del ticket de Kerberos.

El protocolo garantiza que el ticket generado sea inalterable y esté protegido por hashes criptográficos, asegurando que el acceso a los servicios sea resistente a intentos de suplantación en
tránsito.

🛠️ Instalación Rápida

Siga estos pasos de forma secuencial para desplegar el servidor en su terminal de Ubuntu WSL:

---

Paso 1: Clonación del repositorio

Descargue el código fuente y acceda al directorio del proyecto:

Bash
```text
git clone https://github.com/bryan232001/FIS-Servicio-Autenticacion-Integrado.git
cd FIS-Servicio-Autenticacion-Integrado
```
Paso 2: Asignación de permisos al orquestador
Otorgue permisos de ejecución al script maestro para poder iniciar la configuración:
Bash
```text
chmod +x YungaB-Proyecto2.sh
```
Paso 3: Ejecución del despliegue automático

Inicie el proceso de configuración automática del servidor. Este paso instalará las dependencias necesarias y sincronizará los servicios de Kerberos y LDAP de forma desatendida:

Bash
```text
sudo ./YungaB-Proyecto2.sh
```

---

✅ Validación del Sistema

Una vez finalizada la instalación, puede verificar la correcta integración de los servicios ejecutando los siguientes comandos en su terminal:


Solicitar Ticket de Identidad: Obtenga su ticket inicial de Kerberos para el usuario institucional vinculado al Reino FIS.EPN.EC:

Bash
```text
kinit byunga
```
Verificar Ticket Activo: Compruebe la validez, el reino (FIS.EPN.EC) y la caducidad de su credencial actual:

Bash
```text
klist
```
Comprobar Acceso al Directorio (SSO): Valide la integración mediante el mecanismo GSSAPI para confirmar que el servidor permite el acceso sin requerir el ingreso manual de contraseñas:

Bash
```text
ldapwhoami -Y GSSAPI
```

---

Nota Final: Si el tercer paso le devuelve el nombre del usuario correctamente (ej. dn:uid=byunga,ou=people,dc=fis,dc=epn,dc=ec), el sistema de Single Sign-On está operando de forma exitosa bajo los estándares de la Politécnica.

Autor: Bryan Yunga

Institución: Escuela Politécnica Nacional - FIS
