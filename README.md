

This repository contains a Docker Compose file that sets up services for Open OnDemand (https://github.com/OSC/ondemand).



First, clone this repository (https://github.com/matt257/ondemand-compose).

To **build** the services: 
navigate to the directory containing the `docker-compose.yml` file and run:
docker-compose build --no-cache

To **start** the services: 
**build** and navigate to the directory containing the `docker-compose.yml` file then run:
- docker-compose up
- visit localhost
- login to ondemand
  - username: hpc.user
  - password: password


To **stop** the services, 
use:
docker-compose down


## Requirements

- Docker
- Docker Compose

Please ensure that you have the latest versions of Docker and Docker Compose installed on your system.
