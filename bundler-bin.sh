#!/bin/bash
#
# bundler-bin provides a Bash function that updates your PATH environment
# variable to include a project's ./bin directory if the project's Ruby gem
# dependencies are being managed with bundler.
#
# You can find bundler here: http://github.com/wycats/bundler
#
# Gems that are managed by bundler will install their scripts in a directory
# called <project-root>/bin, and you should run these commands in preference
# to the commands that are installed with your system's gems. If your
# project's bin directory is not in your path it's very easy to forget to
# specify the correct command, which can cause no end of subtle problems.
# bundler-bin fixes this problem by automatically updating your PATH as you
# change directories. It defines a function for updating PATH via the Bash
# PROMPT_COMMAND hook.
#
# Usage:
#
# 1. Copy bundler-bin.sh to ~/.bundler-bin.sh.
# 2. Set PROJECT_ROOT to the parent directory of your bundled projects
#    (e.g. ~/code). Why is this needed? See update_bundler_path below.
# 3. Source it from your ~/.bashrc file.
#
# For example:
#
#  $ cp bundler-bin/bundler-bin.sh ~/.bundler-bin.sh
#  $ echo "PROJECT_ROOT=~/code" >> ~/.bashrc
#  $ echo "[ -f ~/.bundler-bin.sh ] && source ~/.bundler-bin.sh" >> ~/.bashrc
#
# That's it... cd into a bundled project and try `echo $PATH` to see if
# it works!
#
# Copyright (c) 2010 Graham Ashton
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

## Variables

PROJECT_ROOT="${PROJECT_ROOT:-$HOME/src}"


## Functions

bundled_project_path()
{
    local path="$(pwd)"
    while [ $path != "/" ]; do
        if [ -e "$path/Gemfile" ]; then
            echo $path
            return $(true)
        fi
        path="$(readlink -f $(dirname $path))"
    done
    return $(false)
}

prepend_project_bin()
{
    local current_path="$1"
    local project_path=$(bundled_project_path)
    if [ -n "$project_path" ]; then
        echo -n "$project_path/bin:"
    fi
    echo "$current_path"
}

within_project_root()
{
    local path="$1"
    [[ $path =~ "^$PROJECT_ROOT" ]]
}

update_bundler_path()
{
    local old_ifs=$IFS
    IFS=":"
    local dir
    local new_path=""
    
    # PATH is reconstructed every time the prompt is redrawn. Directories
    # within PROJECT_ROOT are removed, which prevents your PATH from
    # collecting lots of unwanted clutter as you cd between projects.
    for dir in $PATH; do
        if within_project_root $dir; then
            continue
        fi
        if [ -z "$new_path" ]; then
            new_path="$dir"
        else
            new_path="$new_path:$dir"
        fi
    done
    IFS=$old_ifs
    export PATH="$(prepend_project_bin $new_path)"
}

PROMPT_COMMAND=update_bundler_path
