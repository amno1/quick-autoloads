# About

Example code with my blog post to generate bare-bone autoload files from autoload cookies in Emacs sources.

# Install

You will have to clone this directory and add quick-autoloads.el to your load-path.

# Usage

You have to 

    (require 'quick-autoloads)

Entry point is gl-gen-autoloads which you have to call from M-: or ielm. There are no interactive commenads.

You can pass it a directory tree, or a list of directory trees. For example:

    (al-gen-autoloads '("~/.emacs.d/elpa" "~/.emacs.d/lisp"))
    
The routine will generate autoloads for all elisp files found recursively in subdirectories of those two.

# License

Gpl 3, see the source code file.
