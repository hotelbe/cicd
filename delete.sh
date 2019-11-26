#!/usr/bin/env bash

_() {
  (
    docker-compose down
    docker-compose rm
    rm -rf ./opt/postgresql/data
    rm -rf ./opt/sonarqube/data
    rm -rf ./opt/sonarqube/extensions
    rm -rf ./opt/sonarqube/logs
  )
}
_