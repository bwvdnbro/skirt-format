#!/bin/sh -l

private_key=$1
github_ref=$2
github_origin=$3
echo "Ref: $github_ref"
echo "Origin: $github_origin"
eval `ssh-agent -t 60 -s`
echo "$private_key" | ssh-add -
mkdir -p ~/.ssh/
ssh-keyscan github.com >> ~/.ssh/known_hosts
git config --local user.email "autoformat@skirt"
git config --local user.name "skirt-format"
git clone "$github_origin" repo
git checkout "$github_ref"
cd repo
clang-format-9 -i *.cpp
if ! git diff --no-ext-diff --quiet --exit-code; then
  git commit -am "Autoformatting."
  echo "$private_key" | ssh-add -
  git push origin "$github_ref"
fi
ssh-agent -k
