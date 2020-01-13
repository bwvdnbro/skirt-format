#!/bin/sh -l

private_key=$1
github_ref=$2
echo "$github_ref"
cd "$GITHUB_WORKSPACE"
clang-format-9 -i *.cpp
if ! git diff --no-ext-diff --quiet --exit-code; then
  git config --local user.email "autoformat@skirt"
  git config --local user.name "skirt-format"
  git commit -am "Autoformatting."
  git remote set-url origin "$(git config --get remote.origin.url | sed 's#http.*com/#git@github.com:#g')"
  eval `ssh-agent -t 60 -s`
  echo "$private_key" | ssh-add -
  mkdir -p ~/.ssh/
  ssh-keyscan github.com >> ~/.ssh/known_hosts
  git push origin HEAD:"$github_ref"
  ssh-agent -k
fi
