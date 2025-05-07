![Docker Build and Push](https://github.com/digikwal/project-z/actions/workflows/docker-build.yml/badge.svg)
![License](https://img.shields.io/github/license/digikwal/project-z)
![Issues](https://img.shields.io/github/issues/digikwal/project-z)

![Image Size](https://img.shields.io/docker/image-size/digikwal/project-z/latest)
![Version](https://img.shields.io/github/v/release/digikwal/project-z)
![Docker Pulls](https://img.shields.io/docker/pulls/digikwal/project-z)

## Project-Z

Project-Z is a Dockerized Project Zomboid server designed for simplicity and efficiency. It includes automated builds, testing, and deployment to Docker Hub, making it easy to host your own Project Zomboid server.

### Features
- Dockerized Setup: Quickly deploy your server using Docker.
- Automated Workflows: CI/CD pipelines for testing and deployment.
- Customizable Configuration: Easily configure server settings via environment variables.
- Soft Reset Support: Reset your server while preserving player-built structures and inventories.

---

### Quick Start
1. Clone the repository:
```bash
git clone https://github.com/digikwal/project-z.git
cd project-z
```
---
2. Copy the example environment file and customize it:
```bash
cp .env.example .env
```
---
3. Start the server using Docker Compose:
```bash
docker-compose up -d
```
4. Access your server and start surviving!
---

### Documentation
For detailed guides and configuration options, visit the docs directory:

- Environment Variables
- Soft Reset Guide
- Required Ports
- Scripts Overview

### CI/CD Workflows
This project uses GitHub Actions for CI/CD. Below are the key workflows:

##### Semantic Release
The `semantic-release.yml` workflow automates versioning and changelog generation. It runs after the `Pre-commit checks` workflow completes successfully.

##### Docker Build and Push
The `docker-build.yml` workflow builds and pushes the Docker image to Docker Hub. It uses metadata from the `Semantic Release` workflow to tag the image appropriately.

### Contributing
We welcome contributions! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Submit a pull request with a clear description of your changes.

### License
This project is licensed under the GNU General Public License v3.0.

### Support

If you encounter any issues, feel free to open an issue in the GitHub repository.

---

Happy surviving!
