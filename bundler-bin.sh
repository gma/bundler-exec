#!/bin/bash

COMMANDS="ruby rake"

bundler-installed()
{
    which bundle > /dev/null
}

define-bundler-aliases()
{
    if bundler-installed; then
        for command in $COMMANDS; do
            if [ -e Gemfile ]; then
                alias $command="bundle exec $command"
            fi
        done
    fi
}

PROMPT_COMMAND="define-bundler-aliases"
