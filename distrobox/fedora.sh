#!/bin/bash 

PACKAGES_TO_INSTALL=(
  foo
  bar #dummy
  foobar
)

# $1: name of the distrobox
custom_install() {
  echo "inside custom install"
}
