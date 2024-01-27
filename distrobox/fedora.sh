#!/bin/bash 

PACKAGES=(
  foo
  bar #dummy
  foobar
)

# $1: name of the distrobox
custom_install() {
  echo "inside custom install"
}
