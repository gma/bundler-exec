bundler-exec
===========

bundler is a great way to manage the gem dependencies in your Ruby project.

One of bundler's nifty features is the `bundle exec` command which allows
you to run an executable (such as rake) in the context of your bundled gem
dependencies. In other words, you'll only be able to access the gems that
you've told bundler that you want to use.

To run a command in this way you need to prefix it with 'bundle exec', like
so:

    $ bundle exec rake my:task

It's something that you really ought to be doing whenever you run a ruby
script within a bundled project, but, alas, it can become a chore.

Enter bundler-exec, which takes care of automatically pre-pending "bundle
exec" to the beginning of common Ruby commands.

## Usage

 1. Copy bundler-exec.sh to ~/.bundler-exec.sh.
 2. Source it from your ~/.bashrc file.

For example:

    $ curl -L https://github.com/gma/bundler-exec/raw/master/bundler-exec.sh > ~/.bundler-exec.sh
    $ echo "[ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh" >> ~/.bashrc

Er, that's it...

You can get bundler by installing the gem:

    $ gem install bundler

See http://github.com/carlhuda/bundler for more about bundler.
