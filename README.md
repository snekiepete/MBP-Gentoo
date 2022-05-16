linux-t2
========

Arch Linux package for Linux kernel with bleeding edge T2 Mac support.

To build yourself:

```sh
gpg --recv-keys 38DBBDC86092693E
git clone https://github.com/Redecorating/mbp-16.1-linux-wifi
cd mbp-16.1-linux-wifi
makepkg -si
```

Or you can `sudo pacman -U` the packages Github CI builds, which can be found on the releases page.
