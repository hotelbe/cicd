#!/usr/bin/env bash

_() {
  (
    docker-compose down
    docker-compose rm
  )
}
_