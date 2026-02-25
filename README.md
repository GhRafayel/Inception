# Inception Project

## Description

The Inception project is designed to provide hands-on experience with **containerization** using Docker.  
The goal is to deploy a **WordPress website with a MariaDB database and Nginx reverse proxy**, fully configured with HTTPS, using Docker containers.  

This project demonstrates:

- Container orchestration using `docker-compose`.  
- Persistent storage with Docker volumes.  
- Internal networking between containers.  
- Secure management of sensitive data through environment variables.  

The project includes the following sources:

- `requirements/nginx` → Nginx Dockerfile and configuration files  
- `requirements/wordpress` → WordPress Dockerfile and configuration  
- `requirements/mariadb` → MariaDB Dockerfile and initialization scripts  
- `docker-compose.yml` → Orchestrates all containers, networks, and volumes  
- `.env` → Environment variables for passwords, database name, and WordPress admin credentials  

**Main design choices:**

| Topic | Choice | Reason |
|-------|--------|--------|
| Containerization | Docker | Lightweight, portable, and fast compared to full virtual machines |
| Networking | Custom bridge network | Isolated network allowing containers to communicate securely |
| Data persistence | Docker volumes | Ensures data is persistent across container restarts |
| Secrets management | Environment variables | Simple and sufficient for this project; avoids storing credentials in Dockerfiles |

**Comparisons:**

1. **Virtual Machines vs Docker**  
   - Virtual Machines include full OS images → heavy and slower.  
   - Docker shares host kernel → lightweight, faster startup, and easier orchestration.

2. **Secrets vs Environment Variables**  
   - Secrets are more secure but require Docker Swarm/Kubernetes.  
   - Environment variables are simpler for local projects and sufficient for Inception.

3. **Docker Network vs Host Network**  
   - Docker networks provide isolation and name resolution between containers.  
   - Host network exposes container ports directly to host → less secure and less portable.

4. **Docker Volumes vs Bind Mounts**  
   - Volumes are managed by Docker → more secure and portable.  
   - Bind mounts directly map host directories → useful for development and persistent storage.

---

## Instructions

### Requirements

- Docker ≥ 20.10  
- Docker Compose ≥ 2.0  
- Linux, macOS, or Windows with Docker Desktop  

