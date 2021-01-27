#!/bin/bash

pushd .

bundle exec jekyll build

if [ $? -ne 0]; then
    return
fi

git add .
git commit -m "$@"
git push

cd _site
git add .
git commit -m "$@"
git push

popd
