Servidor Integrado de Directorio y Autenticación (FIS-EPN)
Banner o Logo 
Este repositorio contiene el desarrollo y la configuración de un sistema de gestión de identidades centralizado para la Facultad de Ingeniería de Sistemas (FIS). El proyecto integra las capacidades de almacenamiento jerárquico de OpenLDAP con el protocolo de seguridad de Kerberos, permitiendo un entorno de autenticación moderna y eficiente.
Propósito del Proyecto
El desarrollo de este servidor surgió de la necesidad de implementar un esquema de Single Sign-On (SSO) que sea funcional en entornos de desarrollo como WSL2. A lo largo del proyecto, se lograron los siguientes hitos técnicos:

Centralización: Estructura del directorio institucional bajo el sufijo dc=fis,dc=epn,dc=ec para organizar usuarios y servicios de forma lógica.
Seguridad Distribuida: Implementación de un Reino de Kerberos (FIS.EPN.EC) que elimina la necesidad de enviar contraseñas en texto plano por la red.
Automatización de Red: Lógica de detección dinámica de IP dentro del script maestro para asegurar que el hostname auth-server.fis.epn.ec resuelva correctamente, superando limitaciones de red en entornos virtuales.

Estructura del Proyecto
La organización del repositorio sigue un esquema modular para facilitar el mantenimiento y la escalabilidad del sistema:
text.
├── configs/             # Archivos de configuración
│   └── krb5/            # Configuración del Reino Kerberos
├── data/                # Datos y definiciones
│   └── ldif/            # Definiciones de objetos y estructura del directorio
├── docs/                # Documentación técnica, análisis y diseño
├── README.md            # Guía de usuario y documentación general
└── YungaB-Proyecto2.sh  # Script maestro de despliegue automatizado
Consideraciones sobre la Seguridad del Ticket
Para facilitar la revisión académica, el sistema utiliza la credencial predeterminada Contraseña123. Sin embargo, el diseño del servidor se centra en demostrar la integridad del ticket de Kerberos.
Incluso si la clave es conocida en este escenario de prueba, el protocolo garantiza que el ticket generado (TGT) sea inalterable y esté protegido por hashes criptográficos. Esto asegura que, una vez emitida la identidad digital, el acceso a los servicios sea seguro y resistente a intentos de suplantación en tránsito.
Guía de Despliegue
Para poner en marcha el servidor en un entorno Ubuntu (WSL2 o Nativo), sigue estos pasos:

Obtención del código:Bashgit clone https://github.com/bryan232001/FIS-Servicio-Autenticacion-Integrado.git
cd FIS-Servicio-Autenticacion-Integrado
Ejecución del Orquestador:Bashchmod +x YungaB-Proyecto2.sh
sudo ./YungaB-Proyecto2.sh

El script se encargará de la instalación de dependencias, la configuración del hostname y la inicialización de las bases de datos de seguridad de forma automática.
Validación del Sistema
Puedes verificar la correcta integración de los servicios ejecutando los siguientes comandos en tu terminal:

Solicita un ticket de identidad:Bashkinit byunga
Verifica la validez y expiración del ticket:Bashklist
Comprueba el acceso al directorio:Bashldapwhoami -Y GSSAPI

Si el tercer paso te devuelve el nombre del usuario sin solicitar una contraseña manual, el sistema de Single Sign-On está operando correctamente bajo los estándares de la Politécnica.
Autor

Nombre: Bryan Yunga
Institución: Escuela Politécnica Nacional - FIS