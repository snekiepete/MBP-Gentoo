#!/bin/bash
# (c) 2022 Redecorating
# Pretend I put the GPLv2 here.

set -euo pipefail

ARCH_VER=$(curl -s https://archlinux.org/packages/core/x86_64/linux/ | \
	grep "Arch Linux - linux" | \
	tr " " $'\n' | grep arch | cut -d- -f1)

VER=$(echo $ARCH_VER | rev | cut -d. -f2- | rev)

if echo $ARCH_VER | grep '\..*\.'>/dev/null; then
	UPSTREAM="stable"
else
    UPSTREAM="torvalds"
fi
UPSTREAM_HASH=$(curl -s "https://git.kernel.org/pub/scm/linux/kernel/git/$UPSTREAM/linux.git/tag/?h=v$VER" | \
	grep "tagged object" | cut -d= -f5 | cut -c-40)

curl -s https://github.com/archlinux/linux/compare/$UPSTREAM_HASH...archlinux:v$VER-arch1.patch > 0001-arch-additions.patch

curl -s https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/trunk/PKGBUILD > PKGBUILD.orig
curl -s https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/trunk/config > config


sed -i s/pkgrel=./pkgrel=1/ PKGBUILD
sed -i s/pkgver=.*/pkgver=$VER/ PKGBUILD

updpkgsums

vimdiff PKGBUILD PKGBUILD.orig

makepkg -Cso


git diff
