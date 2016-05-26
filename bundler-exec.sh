#!/bin/bash

# Automatically run Ruby scripts with "bundle exec" (but only when appropriate).
# http://effectif.com/ruby/automating-bundle-exec
# Github: https://github.com/gma/bundler-exec

## Functions

bundler-installed()
{
    which bundle > /dev/null 2>&1
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
        bundle exec "$@"
    else
        "$@"
    fi
}

## Main program

BUNDLED_COMMANDS="${BUNDLED_COMMANDS:-
cap
capify
chef
chefspec
chef-apply
chef-client
chef-shell
chef-solo
cucumber
foodcritic
foreman
guard
haml
html2haml
jasmine
jekyll
kitchen
knife
middleman
pry
rackup
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
strainer
thin
thor
tilt
tt
turn
unicorn
unicorn_rails
wagon
}"

__bundler_exec_set_aliases() {
    local CMD

    if [ "$ZSH_VERSION" ]; then
        # zsh shell
        # it doesn't iterate on strings the same as Bourne shells by default
        # we need to set an option for that, and to avoid clobbering the whole
        # environment, we sandbox that inside this function
        setopt localoptions shwordsplit
    fi

    for CMD in $BUNDLED_COMMANDS; do
        if [[ $CMD != "bundle" && $CMD != "gem" ]]; then
            alias $CMD="run-with-bundler $CMD"
        fi
    done
}

__bundler_exec_set_aliases
unset -f __bundler_exec_set_aliases
