# Darien Technology Technical Test
## Despliegue de OpenWebUI + Ollama con Modelo LLM Local

## Parte 1

Se debe desplegar una instancia de OpenWebUI conectada a Ollama para ejecutar un modelo LLM local (e.g., Llama3, Qwen, Mistral) con alta disponibilidad, seguridad, manejo  de secretos y monitoreo. La aplicación debe ser accesible mediante el dominio que se definirá posteriormente (ya configurado por el equipo) y utilizar una base de datos.

### Especificaciones Tecnicas

Servidor Ubuntu 24.04 LTS

**Hardware:**
- vCPU: 4
- RAM: 8 GB

**Dominios:**
- OpenWebUI: devops-cc.darienc.com para 
- Monitoreo: devops-monitor-cc.darienc.com

**Repositorio:**
- https://github.com/chriscogley/Darien-Technology-Test

### El Servicio debe tener:

1. Componentes principales: OpenWebUI, Ollama y Base de Datos.
2. Kubernetes.
3. Monitoreo.
4. Seguridad.
5. Despliegue.

## Implementacion

Por las especificaciones del servidor se usa k3s (distribucion de Kubernetes ligera) para correr Kubernetes.

![k3sversion.png](images/k3sversion.png)

Utilizando un solo nodo:

![k3snodes.png](images/k3snodes.png)

Para implementar los componentes principales se lo siguiente:

### Helm

![helmversion .png](images/helmversion.png)

Package Manager para Kubernetes. Utilizado para instalar Cert Manager (Manejo de certificados SSL), Stack de monitoreo (Grafana, Prometheus y sus reglas y dashboards), OpenWebUI, Ollama y Postgresql.

Se utilizo debido a la facilidad que da para desplegar aplicaciones.

### ArgoCD

![argocdversion.png](images/argocdversion.png)

### GitHub

Plataforma de hosting de repositorios Git. El codigo que declara los recursos y elementos para crear los componentes principales que hacen funcionar el sistema se encuentra versionado y guardado en este repositorio: https://github.com/chriscogley/Darien-Technology-Test

La estructura principal del repositorio es la siguiente:

```
.
├── apps
├── bootstrap
├── charts
├── manifests
├── Part 2
├── README.md
├── scripts

```
### Folder apps

Las aplicaciones de ArgoCD. Objetos que usa ArgoCD para instalar cada uno de los componentes necesarios del sistema.

1. 00-namespaces.yaml: Crea los namespaces ai (para poner los recursos usados para la parte de AI) y monitoring (para poner los recursos del stack de observabilidad)
2. app-secrets.yaml: Maneja los secretos. 
3. argocd-ui.yaml: Crea el ingress para ver la UI de ArgoCD.
4. blackbox-exporter.yaml: Usado por el stack de observabilidad para monitorear Ollama.
5. cert-manager.yaml: Para manejar los certificados SSL.
6. cluster-issuer.yaml: Para manejar los certificados SSL.
7. kube-prometheus-stack.yaml: Maneja el stack de observabilidad (Grafana y Prometheus).
8. 

## Workflow:

Developers commit Kubernetes manifests/Helm charts to Git
ArgoCD detects changes in the repository
ArgoCD automatically applies changes to the cluster
ArgoCD monitors application health and sync statu

Herramienta usada para sincronizar y desplegar lo que esta en el repositorio GitHub con Kubernetes. 

## README explicativo (en el repositorio) sobre las decisiones tomadas y que evidencien las configuraciones.

