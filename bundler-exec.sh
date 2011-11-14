#!/bin/bash

rbenv-installed()
{
  which rbenv > /dev/null 2>&1
}


if rbenv-installed; then
  BUNDLED_COMMANDS=$(ls ~/.rbenv/shims)
else

BUNDLED_COMMANDS="${BUNDLED_COMMANDS:-
cap
capify
cucumber
foreman
guard
haml
heroku
html2haml
rackup
rails
rake
rake2thor
rspec
ruby
sass
sass-convert
serve
shotgun
spec
spork
thin
thor
tilt
tt
turn
unicorn
unicorn_rails
}"

fi

## Functions

bundler-installed()
{
  if rbenv-installed; then
    rbenv which bundle > /dev/null 2>&1
  else
    which bundle > /dev/null 2>&1
  fi
}

within-bundled-project()
{
    local dir="$(pwd)"
    while [ "$(dirname $dir)" != "/" ]; do
        [ -f "$dir/Gemfile" ] && return
        dir="$(dirname $dir)"
    done
    false
}

run-with-bundler()
{
    if bundler-installed && within-bundled-project; then
        bundle exec $@
    else
        $@
    fi
}

## Main program

for CMD in $BUNDLED_COMMANDS; do
  if [[ $CMD != 'bundle' ]]; then
    alias $CMD="run-with-bundler $CMD"
  fi
done
