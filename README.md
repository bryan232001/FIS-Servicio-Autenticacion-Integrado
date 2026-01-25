# Servidor Integrado de Directorio y Autenticación (FIS-EPN)

Este repositorio contiene la implementación de un sistema de gestión de identidades centralizado para la Facultad de Ingeniería de Sistemas (FIS). La solución integra las capacidades de almacenamiento jerárquico de **OpenLDAP** con el protocolo de seguridad de **Kerberos**, permitiendo un entorno de autenticación moderna y eficiente diseñado específicamente para **Windows Subsystem for Linux (WSL2)**.

---

## ¿Qué logré con este proyecto?

* **Implementación de Single Sign-On (SSO):** Logré que los usuarios de la facultad puedan autenticarse una sola vez para acceder a múltiples servicios de forma segura.
* **Directorio Organizado:** Estructuré la jerarquía institucional en OpenLDAP bajo el sufijo `dc=fis,dc=epn,dc=ec`.
* **Criptografía Robusta:** Configuré un Reino de Kerberos (`FIS.EPN.EC`) para asegurar que las credenciales no viajen en texto plano por la red.
* **Persistencia en WSL:** Superé el reto de mantener la identidad del servidor (`auth-server.fis.epn.ec`) mediante un sistema de detección dinámica de IP.

---

## Estructura del Proyecto

La organización del repositorio sigue un esquema modular para facilitar el mantenimiento y la escalabilidad del sistema:

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
## Consideraciones sobre la Seguridad del Ticket
Para facilitar la revisión académica, el sistema utiliza la credencial predeterminada Contraseña123. Sin embargo, el diseño del servidor se centra en demostrar la integridad del ticket de Kerberos.

Incluso si la clave es conocida en este escenario de prueba, el protocolo garantiza que el ticket generado (TGT) sea inalterable y esté protegido por hashes criptográficos. Esto asegura que, una vez emitida la identidad digital, el acceso a los servicios sea seguro y resistente a intentos de suplantación en tránsito.

## Instalación Rápida
Para desplegar este servidor en un entorno Ubuntu (WSL2 o Nativo), siga estos pasos de forma secuencial:

Paso 1: Clonación del repositorio Descargue el código fuente directamente desde GitHub:

Ejecutar comando

```text git clone [https://github.com/bryan232001/FIS-Servicio-Autenticacion-Integrado.git](https://github.com/bryan232001/FIS-Servicio-Autenticacion-Integrado.git)
cd FIS-Servicio-Autenticacion-Integrado ```
Paso 2: Asignación de permisos al orquestador Otorgue permisos de ejecución al script maestro:

Ejecutar comando

```text chmod +x YungaB-Proyecto2.sh ```
Paso 3: Ejecución del despliegue automático Inicie el proceso de configuración automática:

Ejecutar comando

```text sudo ./YungaB-Proyecto2.sh ```
## Validación del Sistema
Una vez finalizada la instalación, puede verificar la correcta integración de los servicios ejecutando los siguientes comandos en su terminal:

1. Solicitar Ticket de Identidad: Obtenga su ticket inicial de Kerberos:

Ejecutar comando

```text kinit byunga```
2. Verificar Ticket Activo: Compruebe la validez y caducidad de su credencial:

Ejecutar comando

```text klist ```
3. Comprobar Acceso al Directorio (SSO): Valide la integración mediante GSSAPI sin requerir contraseña adicional:

Ejecutar comando

```text ldapwhoami -Y GSSAPI ```
Nota: Si el tercer paso le devuelve el nombre del usuario correctamente, el sistema de Single Sign-On está operando bajo los estándares de la Politécnica.

Autor: Bryan Yunga

Institución: Escuela Politécnica Nacional - FIS
