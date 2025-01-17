#!/usr/bin/env bash

generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#
	EOH
}

LATEST_VERSION=7.3

VERSIONS="
5.6
5.5
7.0
7.1
7.2
7.3
"

for version in ${VERSIONS}; do
    main_version=$(echo ${version} | cut -f1 -d.)

    if [[ "$main_version" == "7" ]]; then
        xdebug_version=xdebug
    else
        xdebug_version=xdebug-2.5.5
    fi

    rm -rf ${version}
    mkdir -p ${version}
    mkdir -p ${version}/apache

    generated_warning > ${version}/Dockerfile
    cat Dockerfile-alpine.template | \
        sed -e 's!%%PHP_VERSION%%!'"${version}-alpine"'!' | \
        sed -e 's!%%XDEBUG_VERSION%%!'"${xdebug_version}"'!' \
        >> ${version}/Dockerfile

    generated_warning > ${version}/apache/Dockerfile
    cat Dockerfile-apache.template | \
        sed -e 's!%%PHP_VERSION%%!'"${version}-apache"'!' | \
        sed -e 's!%%XDEBUG_VERSION%%!'"${xdebug_version}"'!' \
        >> ${version}/apache/Dockerfile
done
