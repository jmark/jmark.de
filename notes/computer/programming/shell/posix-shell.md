title: Posix Shell Scripting Tricks

author: Johannes Markert

published: September 2016

synopsis: Catalog of posix (ksh/dash/bash) shell scripting tricks.

---

Robust shell scripting
----------------------

### Praembel

Put this at the beginning of your scripts.

    set -u  # error on undefined variables
    set -e  # exit on failed sub-program 

More infos for example [here](http://www.davidpashley.com/articles/writing-robust-shell-scripts/).


Save and reload prefixed environmet variables
---------------------------------------------

In many interactive sessions I use environment variables as poor-man's
configuration for other scripts, gnuplot for example. Now, define a prefix for
the variables you want to save: 'PREFIX_'.

    $ export PREFIX_A='...'
    $ export PREFIX_B='...'

    $ set | grep PREFIX_ | sed 's/^/export /' > my_env_file

Last line also prepends the 'export' command. In order to reload the session
just issue:

    $ source my_env_file


Ideas/Todo
----------

- gnuplot environment variable trick as parameter passing
- trapping
- http://wiki.bash-hackers.org/start
- http://mywiki.wooledge.org/BashGuide
