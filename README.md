# odroid-scripts
Very handy scripts and applications for setting up and using ODROID & Raspberry Pi micro-computers

### NOTICE
I do not represent [Hardkernel](http://www.hardkernel.com) (the makers of ODROID) or the [Raspberry Pi Foundation](https://www.raspberrypi.org) (the makers of Raspberry Pi) nor do I endorse either of them.  I am simply a lover of technology and like to use these products, as well as others, both alone and as part of larger products.

### PURPOSE

The raw startup environment for the command-line interface for Linux is pretty basic.  So years ago I started writing scripts to set up my own environment.  I created a lot of [alias statements](https://www.gnu.org/software/bash/manual/bash.html#Aliases) and [custom functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions) for BASH and setting useful [environment variables](https://www.gnu.org/software/bash/manual/bash.html#Environment).

I also created a lot of BASH scripts and simple C, C++ and (later) [Objective-C](https://en.wikipedia.org/wiki/Objective-C) tools to reduce the amount of typing I had to do to accomplish certain tasks.  For example, to archive a folder (or set of folders) using `tar` using an alternative compression utility, you could, I suppose, type this over and over again each time:

```bash
tar cf - foo | 7za a -an -txz -si -so 2>/dev/null > ~/Downloads/foo-backup-`date +%Y%m%d%H%M%S`.tar.xz
```

or you could create a simple BASH script so that you would only have to type this:

```bash
taritup ~/Downloads/foo-backup foo
```

Which would you rather do?  I thought so.  :)


