#!/usr/bin/env bats

setup() {
  mkdir tmp
}

teardown() {
  git reset HEAD tmp
  rm -r tmp
}

@test "subsitutes strings in files in path" {
  echo foo > tmp/added
  git add tmp/added
  bin/git-substitute foo bar tmp
  [ `cat tmp/added` = "bar" ]
}

@test "accepts multiple paths" {
  echo foo > tmp/path1
  git add tmp/path1
  echo foo > tmp/path2
  git add tmp/path2
  bin/git-substitute foo bar tmp/path1 tmp/path2
  [ `cat tmp/path1` = "bar" ]
  [ `cat tmp/path2` = "bar" ]
}

@test "ignores files not in repository" {
  echo foo > tmp/unadded
  echo foo > tmp/added
  git add tmp/added
  bin/git-substitute foo bar tmp
  [ `cat tmp/unadded` = "foo" ]
}

@test "ignores files not in path" {
  mkdir tmp/searched
  mkdir tmp/unsearched
  echo foo > tmp/searched/test
  echo foo > tmp/unsearched/test
  git add tmp
  bin/git-substitute foo bar tmp/searched
  [ `cat tmp/unsearched/test` = "foo" ]
}
