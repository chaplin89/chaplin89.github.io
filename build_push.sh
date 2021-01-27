#!/bin/bash

pushd .
git add .
git commit -m "$@"
git push

cd _site
git add .
git commit -m "$@"
git push

popd
