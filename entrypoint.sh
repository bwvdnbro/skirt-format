#!/bin/sh -l

cd $GITHUB_WORKSPACE
clang-format-9 -i *.cpp
git diff
