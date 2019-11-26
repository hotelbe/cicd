#!/usr/bin/env bash

_() {
  (
    docker-compose build --no-cache --force-rm
    docker-compose up
  )
}
_