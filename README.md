# 💻 Proyecto Google Meridian en GCP

## ✨ Descripción
Este proyecto implementa una arquitectura en **Google Cloud Platform (GCP)** para la ejecución programada de notebooks de **Google Meridian** mediante **Google Colab Enterprise**. Los datos procesados se almacenan en **Cloud Storage** y se pueden utilizar para análisis y optimización del mercado automotriz en Perú.

## 🛠️ Tecnologías Utilizadas
- **Google Colab Enterprise**: Para la ejecución de notebooks en la nube.
- **Google Cloud Storage (GCS)**: Para almacenamiento de notebooks y datos CSV.
- **Google Colab Schedule**: Para programar la ejecución automática del notebook.
- **Terraform**: Para la gestión y despliegue de la infraestructura en GCP.

---

## 🌐 Arquitectura del Proyecto

### 💼 1. Cómputo
#### Google Colab Runtime Template
- **Tipo de máquina**: `e2-standard-4`
- **Acceso a internet**: Habilitado
- **Ubicación**: ` name_ubicación `
- **Función**: Proporciona el entorno de ejecución para el notebook de Meridian.

### 🏢 2. Almacenamiento
#### Google Cloud Storage (GCS)
- **Bucket**: `name-bucket`
- **Archivos almacenados**:
  - **Notebook**: `name_notebook.ipynb`
  - **Datos CSV**: `name_csv_datos.csv`
- **Función**: Permite almacenar y recuperar datos utilizados por el notebook.

### ⏰ 3. Programación y Ejecución
#### Google Colab Schedule
- **Frecuencia**: ` ` (Ejecución ** hora de Lima)
- **Duración**: del **00/00/0000 al 00/00/0000**
- **Tiempo máximo de ejecución**: `86400s` (24 horas)
- **Fuente del notebook**: `gs://name-bucket/name_notebook.ipynb`
- **Salida de ejecución**: `gs://name-bucket/`
- **Cuenta de servicio**: ` cuenta_de_servicio `

---

## 🛠️ Instalación y Configuración

### 🔨 Prerrequisitos
Antes de desplegar el proyecto, asegúrate de tener:
- **Terraform** instalado en tu máquina.
- **Acceso a GCP** con los permisos adecuados.
- **Cuenta de servicio** configurada con acceso a Colab Enterprise y GCS.

### 💪 Despliegue
```sh
# Clona este repositorio
git clone https://github.com/PerpetualTecnologies/meridian-gcp-infra.git
cd meridian-gcp-infra

# Inicializa Terraform
terraform init

# Plan Terraform
terraform plan

# Aplica la configuración
terraform apply -auto-approve
```
