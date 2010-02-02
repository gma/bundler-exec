bundler-bin
===========

bundler-bin provides a Bash function that updates your PATH environment
variable to include a project's ./bin directory if the project's Ruby gem
dependencies are being managed with bundler.

You can find bundler here: http://github.com/wycats/bundler

Gems that are managed by bundler will install their scripts in a directory
called `<project-root>/bin`, and you should run these commands in preference
to the commands that are installed with your system's gems. If your
project's bin directory is not in your path it's very easy to forget to
specify the correct command, which can cause no end of subtle problems.
bundler-bin fixes this problem by automatically updating your PATH as you
change directories. It defines a function for updating PATH via the Bash
PROMPT_COMMAND hook.

bundler-bin requires Bash 3.0 or greater to work.

Usage:

 1. Copy bundler-bin.sh to ~/.bundler-bin.sh.
 2. Set PROJECT_ROOT to the parent directory of your bundled projects
    (e.g. ~/code). Why is this needed? See update_bundler_path in the code.
 3. Source it from your ~/.bashrc file.

For example:

    $ cp bundler-bin/bundler-bin.sh ~/.bundler-bin.sh
    $ echo "PROJECT_ROOT=$HOME/code" >> ~/.bashrc
    $ echo "[ -f ~/.bundler-bin.sh ] && source ~/.bundler-bin.sh" >> ~/.bashrc

That's it... cd into a bundled project and try `echo $PATH` to see if
it works!
