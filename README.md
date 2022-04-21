# Dotfiles versioning

Uses a combination of Git and [Mackup](https://github.com/lra/mackup) to backup and version dotfiles and application configs.

The applications for which configuration is backed up (including Git and Mackup themselves) are defined in `.mackup.cfg`. When switching to a different machine, configurations may be copied over quickly by first cloning this repository, installing Mackup, then running `mackup restore`.

Note that this process will only import app _configurations_, it will not install the apps themselves.
