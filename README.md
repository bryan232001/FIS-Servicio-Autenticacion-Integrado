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

🔐 Consideraciones sobre la Seguridad del Ticket
Para facilitar la revisión académica, el sistema utiliza la credencial predeterminada Contraseña123. Sin embargo, el diseño del servidor se centra en demostrar la integridad del ticket de Kerberos.

Incluso si la clave es conocida en este entorno de prueba, el protocolo garantiza que el ticket generado (TGT) sea inalterable y esté protegido por hashes criptográficos, lo que previene ataques de suplantación en tránsito.

🛠️ Instalación Rápida
Para desplegar este servidor en un entorno Ubuntu (WSL2 o Nativo), siga estos pasos de forma secuencial:

Paso 1: Clonación del repositorio
Descargue el código fuente directamente desde GitHub:

Bash

git clone [https://github.com/bryan232001/FIS-Servicio-Autenticacion-Integrado.git](https://github.com/bryan232001/FIS-Servicio-Autenticacion-Integrado.git)
cd FIS-Servicio-Autenticacion-Integrado
Paso 2: Asignación de permisos al orquestador
Otorgue permisos de ejecución al script maestro:

Bash

chmod +x YungaB-Proyecto2.sh
Paso 3: Ejecución del despliegue automático
Inicie el proceso de configuración automática:

Bash

sudo ./YungaB-Proyecto2.sh
✅ Validación del Sistema
Una vez finalizada la instalación, puede verificar la correcta integración ejecutando estos comandos:

Solicitar Ticket de Identidad: Obtenga su ticket inicial de Kerberos:

Bash

kinit byunga
Verificar Ticket Activo: Compruebe la validez y caducidad de su credencial:

Bash

klist
Comprobar Acceso al Directorio (SSO): Valide la integración mediante GSSAPI sin requerir contraseña adicional:

Bash

ldapwhoami -Y GSSAPI
Nota: Si el tercer paso devuelve el nombre del usuario correctamente, el sistema de Single Sign-On está operando bajo los estándares de la Politécnica.

Autor: Bryan Yunga

Institución: Escuela Politécnica Nacional - FIS