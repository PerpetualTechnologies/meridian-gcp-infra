#💻 Proyecto Google Meridian en GCP

✨ Descripción

Este proyecto implementa una arquitectura en Google Cloud Platform (GCP) para la ejecución programada de notebooks de Google Meridian mediante Google Colab Enterprise. Los datos procesados se almacenan en Cloud Storage y se pueden utilizar para análisis y optimización del mercado automotriz en Perú.

🛠️ Tecnologías Utilizadas

Google Colab Enterprise: Para la ejecución de notebooks en la nube.

Google Cloud Storage (GCS): Para almacenamiento de notebooks y datos CSV.

Google Colab Schedule: Para programar la ejecución automática del notebook.

Terraform: Para la gestión y despliegue de la infraestructura en GCP.

🌐 Arquitectura del Proyecto

💼 1. Cómputo

Google Colab Runtime Template

Tipo de máquina: e2-standard-4

Acceso a internet habilitado

Ubicación: us-west1

Proporciona el entorno de ejecución para el notebook de Meridian.

🏢 2. Almacenamiento

Google Cloud Storage (GCS)

Bucket: meridian-mmm

Archivos almacenados:

Notebook: meridian_lite_weekly.ipynb

Datos CSV: meridian_lite_weekly.csv

Permite almacenar y recuperar datos utilizados por el notebook.

⏰ 3. Programación y Ejecución

Google Colab Schedule

Frecuencia: 0 0 * * * (Ejecución diaria a la medianoche en hora de Lima)

Duración: del 08/03/2025 al 08/04/2025

Tiempo máximo de ejecución: 24 horas (86400s)

Fuente del notebook: gs://meridian-mmm/meridian_lite_weekly.ipynb

Salida de ejecución: gs://meridian-mmm/

Cuenta de servicio: terraform@meridian-mmm-452218.iam.gserviceaccount.com

🛠️ Instalación y Configuración

🔨 Prerrequisitos

Antes de desplegar el proyecto, asegúrate de tener:

Terraform instalado en tu máquina.

Acceso a GCP con los permisos adecuados.

Cuenta de servicio configurada con acceso a Colab Enterprise y GCS.

💪 Despliegue

Clona este repositorio:

git clone https://github.com/tu_usuario/google-meridian-gcp.git
cd google-meridian-gcp

Inicializa Terraform:

terraform init

Aplica la configuración:

terraform apply -auto-approve

💡 Mejoras Futuras

✨ Integración con BigQuery: Para almacenamiento estructurado de datos procesados.

🛈 Notificaciones con Pub/Sub: Para alertas en caso de errores en la ejecución.

🔧 Monitoreo con Cloud Logging: Para mejorar la trazabilidad y depuración.

📘 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo LICENSE para más detalles.

🌟 Desarrollado con Terraform y GCP para optimizar la ejecución de Google Meridian 🚀
