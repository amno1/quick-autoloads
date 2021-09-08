# About

Example code to go with my [blog post about generating bare-bone autoload files](http://www.nextpoint.se/?p=890) from autoload cookies in Emacs sources. Obs, I have changed prefix afterwards as to better go with the name of the package.

# Install

You will have to clone this directory and add quick-autoloads.el to your load-path.

# Usage

First you will have to require it:

    (require 'quick-autoloads)

Entry point is gl-gen-autoloads which you have to call from M-: or ielm. There are no interactive commands.

You can pass it a directory tree, or a list of directory trees. For example:

    (ql-gen-autoloads '("~/.emacs.d/elpa" "~/.emacs.d/lisp"))
    
The routine will generate autoloads for all elisp files found recursively in subdirectories of those two.

# License

Gpl 3, see the source code file.
