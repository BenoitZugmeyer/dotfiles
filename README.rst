Here is a subset of the dotfiles I use everyday. You'll find configuration
files for:

* vim
* zsh
* awesome wm
* git
* top

Feel free to contribute or ask anything.

Deploying
---------

Run  ``./deploy.bash``. It is pretty safe:

* compare the repo files to the ones you have in your home
* if a file is missing, it will be hardlinked
* if a file is here and has the same md5sum, it will be removed then
  hardlinked
* else it will do nothing but warn you

If you want to use the awesome gmail widget, you should copy and edit the
.netrc file.
