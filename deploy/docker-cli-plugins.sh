#!/usr/bin/env bash

set -eu

docker_config="${DOCKER_CONFIG:-${XDG_CONFIG_HOME:-${HOME}/.config}/docker}"
target_dir="${docker_config%/}/cli-plugins"
source_dir="/Applications/Docker.app/Contents/Resources/cli-plugins"

if [[ ! -d "${source_dir}" ]]; then
  exit 0
fi

mkdir -p "${target_dir}"

for plugin in "${source_dir}"/docker-*; do
  [[ -x "${plugin}" ]] || continue
  ln -snfv "${plugin}" "${target_dir}/$(basename "${plugin}")"
done
