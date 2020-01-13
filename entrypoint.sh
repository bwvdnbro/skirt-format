#!/bin/sh -l

private_key=$1
github_ref=$2
github_origin=$3
echo "deploy_key: $deploy_key"
echo "INPUT_PRIVATE_KEY: $INPUT_PRIVATE_KEY"
echo "INPUT_GITHUB_REF: $INPUT_GITHUB_REF"
echo "INPUT_GITHUB_ORIGIN: $INPUT_GITHUB_ORIGIN"
echo "GITHUB_REF: $GITHUB_REF"
echo "GITHUB_SHA: $GITHUB_SHA"
echo "GITHUB_REPOSITORY: $GITHUB_REPOSITORY"
echo "ACTIONS_RUNTIME_URL: $ACTIONS_RUNTIME_URL"
echo "$INPUT_PRIVATE_KEY" > key.txt
echo "$deploy_key" > dkey.txt
diff key.txt dkey.txt
wc key.txt
md5sum key.txt
echo "Ref: $github_ref"
echo "Origin: $github_origin"
eval `ssh-agent -t 60 -s`
mkdir -p ~/.ssh/
ssh-keyscan github.com >> ~/.ssh/known_hosts
mv key.txt ~/.ssh/id_rsa
echo "TEST SSH:"
echo "$deploy_key" | ssh-add -
ssh -T git@github.com
echo "$deploy_key" | ssh-add -
git clone git@github.com:"$GITHUB_REPOSITORY".git repo
cd repo
git checkout "$github_ref"
clang-format-9 -i *.cpp
if ! git diff --no-ext-diff --quiet --exit-code; then
  git config --local user.email "autoformat@skirt"
  git config --local user.name "skirt-format"
  git commit -am "Autoformatting."
  echo "$private_key" | ssh-add -
  git push origin "$github_ref"
fi
ssh-agent -k
