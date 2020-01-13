#!/bin/sh -l

echo "$GITHUB_WORKSPACE"
cd "$GITHUB_WORKSPACE"
clang-format-9 -i *.cpp
if ! git diff --no-ext-diff --quiet --exit-code; then
  git add .
  git commit -am "Autoformatting."
  git remote set-url origin "$(git config --get remote.origin.url | sed 's#http.*com/#git@github.com:#g')"
  eval `ssh-agent -t 60 -s`
  echo "$private_key" | ssh-add -
  mkdir -p ~/.ssh/
  ssh-keyscan github.com >> ~/.ssh/known_hosts
  git push
  ssh-agent -k
fi
