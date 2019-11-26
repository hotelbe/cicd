#!/usr/bin/env bash

_() {
  (
    docker-compose down
    docker-compose rm -fv

    docker-compose build --no-cache --force-rm
    docker-compose up
  )
}
_