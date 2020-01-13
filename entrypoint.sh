#!/bin/sh -l

echo "$GITHUB_WORKSPACE"
cd "$GITHUB_WORKSPACE"
clang-format-9 -i *.cpp
git diff
