#!/usr/bin/env bash

set -ue

export GOPATH="${HOME}/.go"
export PATH="${GOPATH}/bin:$PATH"

go get github.com/itchyny/fillin
GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt