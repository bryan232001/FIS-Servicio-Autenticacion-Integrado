🛡️Servidor Integrado de Directorio y Autenticación (FIS-EPN)

Este repositorio contiene mi solución para el sistema de seguridad centralizada de la Facultad de Ingeniería de Sistemas (FIS).
El objetivo fue crear un entorno robusto de autenticación, autorización y gestión de identidades, integrando tecnologías estándar utilizadas a nivel institucional.

 ¿Qué logré con este proyecto?

 Implementación de Single Sign-On (SSO):
Logré que los usuarios de la facultad puedan autenticarse una sola vez para acceder a múltiples servicios de forma segura.

 Directorio Organizado:
Estructuré la jerarquía institucional en OpenLDAP bajo el sufijo:
dc=fis,dc=epn,dc=ec.

 Criptografía Robusta:
Configuré un Reino de Kerberos (FIS.EPN.EC) para asegurar que las credenciales no viajen en texto plano por la red.

 Persistencia en WSL:
Superé el reto de mantener la identidad del servidor
(auth-server.fis.epn.ec) mediante un sistema de detección dinámica de IP.

🗂️ Estructura del Proyecto

La organización del repositorio sigue un esquema modular, pensado para facilitar el mantenimiento y la escalabilidad del sistema:

.
├── configs/
│   └── krb5/            # Archivos de configuración del Reino Kerberos
├── data/
│   └── ldif/            # Definiciones de objetos y estructura del directorio
├── docs/                # Documentación técnica, análisis y diseño
├── README.md            # Guía de usuario y documentación general
└── YungaB-Proyecto2.sh  # Script maestro de despliegue automatizado

⚙️ Instalación Rápida

Para desplegar este servidor en tu propia máquina, sigue estos pasos:

🔹 Paso 1: Clona el repositorio
git clone https://github.com/bryan232001/FIS-Servicio-Autenticacion-Integrado.git
cd FIS-Servicio-Autenticacion-Integrado

🔹 Paso 2: Asigna permisos al orquestador
chmod +x YungaB-Proyecto2.sh

🔹 Paso 3: Ejecuta el despliegue automático
sudo ./YungaB-Proyecto2.sh

 ¿Cómo compruebo que funciona?

No confíes solo en mi palabra 😉
Ejecuta los siguientes comandos para verificar la integración completa:

🔹 Paso 1: Solicita tu ticket de Kerberos
kinit byunga

🔹 Paso 2: Verifica tu ticket activo
klist

🔹 Paso 3: Prueba la autenticación integrada (SSO)
ldapwhoami -Y GSSAPI


Nota:
Si el último comando devuelve el nombre del usuario sin pedir contraseña, el servidor está operando correctamente bajo los estándares de la Escuela Politécnica Nacional.

👤 Estudiante

Bryan Yunga

🎓 Institución:
Escuela Politécnica Nacional
Facultad de Ingeniería de Sistemas (FIS)
