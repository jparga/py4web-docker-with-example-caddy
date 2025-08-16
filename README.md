## ⚠️ Configuración de Caddy

Por defecto, el archivo de configuración de Caddy (`caddy/Caddyfile`) utiliza el dominio `example.com` y un puerto predeterminado.

**Importante:**
- Debes cambiar `example.com` por el dominio real que vayas a utilizar en producción.
- Si lo consideras necesario, también puedes modificar el puerto para adaptarlo a tu entorno.

Edita el archivo `caddy/Caddyfile` antes de desplegar para evitar problemas de acceso o redirección.

## 🧪 Configuración local de Caddy

Para pruebas en entorno local, puedes utilizar el bloque de configuración con `:80` en el archivo `caddy/Caddyfile`:

```caddyfile
:80 {
	reverse_proxy py4web:8000
}
```

Esto permite acceder a la aplicación desde `http://localhost` sin necesidad de un dominio. Es útil para desarrollo y pruebas antes de desplegar en producción.

**Recuerda:** Este bloque debe usarse solo en local y no en producción. Puedes comentarlo o eliminarlo cuando configures el dominio real.
# py4web + Caddy + MySQL + Fail2Ban en Docker

## 1️⃣ Requisitos
- Docker
- Docker Compose
- Git

## 2️⃣ Instalación
```bash
git clone https://github.com/TU_USUARIO/py4web-docker.git
cd py4web-docker
docker compose up -d --build
```

## 3️⃣ Actualización
```bash
git pull
docker compose up -d --build
```

## 4️⃣ Despliegue automático con deploy.sh

Este proyecto incluye un script de despliegue automático llamado `deploy.sh` que facilita la actualización y el despliegue de la aplicación usando Docker.

### Uso de `deploy.sh`

1. Asegúrate de tener acceso al directorio del proyecto en `/opt/py4web-docker`.
2. Ejecuta el script desde la terminal:

```bash
./deploy.sh
```

El script realiza las siguientes acciones:
- Accede al directorio del proyecto.
- Actualiza el código desde el repositorio Git (rama `main`).
- Reconstruye y levanta los contenedores Docker con `docker compose up -d --build`.
- Muestra mensajes informativos sobre el progreso y finalización del despliegue.

**Nota:** El script está pensado para entornos Linux y requiere permisos adecuados para ejecutar Docker y acceder al directorio de despliegue.
