#!/bin/sh -l

cd "$GITHUB_WORKSPACE"
clang-format-9 -i *.cpp
if ! git diff --no-ext-diff --quiet --exit-code; then
  echo ::set-output name=status::"changed"
else
  echo ::set-output name=status::"unchanged"
fi
