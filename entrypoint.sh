#!/bin/sh -l

echo "$github_ref"
echo "$github_origin"
cd "$GITHUB_WORKSPACE"
clang-format-9 -i *.cpp
if ! git diff --no-ext-diff --quiet --exit-code; then
  git config --local user.email "autoformat@skirt"
  git config --local user.name "skirt-format"
  git checkout "$github_ref"
  git commit -am "Autoformatting."
  git remote set-url origin "$github_origin"
  eval `ssh-agent -t 60 -s`
  echo "$private_key" | ssh-add -
  mkdir -p ~/.ssh/
  ssh-keyscan github.com >> ~/.ssh/known_hosts
  git push
  ssh-agent -k
fi
