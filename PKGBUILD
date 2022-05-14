# Maintainer: Redecorating
# Contributors: There are many, see `grep -h "From:" *.patch|sort|uniq -c`.
#               Additionally, MrARM and Ronald Tschalär wrote apple-bce and
#               apple-ibridge drivers, respectively.

pkgbase=linux-t2
pkgver=5.17.7
_srcname=linux-${pkgver}
pkgrel=1
pkgdesc='Linux kernel for T2 Macs'
_srctag=v${pkgver%.*}-${pkgver##*.}
url="https://github.com/archlinux/linux/commits/$_srctag"
arch=(x86_64)
license=(GPL2)
makedepends=(
  bc libelf pahole cpio perl tar xz
  xmlto python-sphinx python-sphinx_rtd_theme graphviz imagemagick texlive-latexextra
  git
)
options=('!strip')

source=(
  https://www.kernel.org/pub/linux/kernel/v${pkgver//.*}.x/linux-${pkgver}.tar.xz
  https://www.kernel.org/pub/linux/kernel/v${pkgver//.*}.x/linux-${pkgver}.tar.sign
  config         # the main kernel config file

  # Arch Linux patches
  0001-arch-additions.patch

  # apple-bce, apple-ibridge
  apple-bce::git+https://github.com/t2linux/apple-bce-drv#commit=f93c6566f98b3c95677de8010f7445fa19f75091
  apple-ibridge::git+https://github.com/Redecorating/apple-ib-drv#commit=467df9b11cb55456f0365f40dd11c9e666623bf3

  1001-Put-apple-bce-and-apple-ibridge-in-drivers-staging.patch
  1002-add-modalias-to-apple-bce.patch

  # Fix some acpi errors
  2001-fix-acpica-for-zero-arguments-acpi-calls.patch

  # Apple SMC ACPI support
  3001-applesmc-convert-static-structures-to-drvdata.patch
  3002-applesmc-make-io-port-base-addr-dynamic.patch
  3003-applesmc-switch-to-acpi_device-from-platform.patch
  3004-applesmc-key-interface-wrappers.patch
  3005-applesmc-basic-mmio-interface-implementation.patch
  3006-applesmc-fan-support-on-T2-Macs.patch
  3007-applesmc-Add-iMacPro-to-applesmc_whitelist.patch

  # T2 USB Keyboard/Touchpad support
  4001-HID-apple-Add-support-for-keyboard-backlight-on-cert.patch
  4002-HID-apple-Add-necessary-IDs-and-configuration-for-T2.patch
  4003-HID-apple-Add-fn-mapping-for-MacBook-Pros-with-Touch.patch
  4004-Input-bcm5974-Add-support-for-the-T2-Macs.patch

  # make hid not touch tb to avoid `vhci: [00] URB failed: 3`
  5001-Fix-for-touchbar.patch

  # UVC Camera support
  6001-media-uvcvideo-Add-support-for-Apple-T2-attached-iSi.patch

  # Hack for i915 overscan issues
  7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch

  # Broadcom WIFI device support
  8001-brcmfmac-firmware-Handle-per-board-clm_blob-files.patch
  8002-brcmfmac-pcie-sdio-usb-Get-CLM-blob-via-standard-fir.patch
  8003-brcmfmac-firmware-Support-passing-in-multiple-board_.patch
  8004-brcmfmac-pcie-Read-Apple-OTP-information.patch
  8005-brcmfmac-of-Fetch-Apple-properties.patch
  8006-brcmfmac-pcie-Perform-firmware-selection-for-Apple-p.patch
  8007-brcmfmac-firmware-Allow-platform-to-override-macaddr.patch
  8008-brcmfmac-msgbuf-Increase-RX-ring-sizes-to-1024.patch
  8009-brcmfmac-pcie-Support-PCIe-core-revisions-64.patch
  8010-brcmfmac-pcie-Add-IDs-properties-for-BCM4378.patch
  8011-ACPI-property-Support-strings-in-Apple-_DSM-props.patch
  8012-brcmfmac-acpi-Add-support-for-fetching-Apple-ACPI-pr.patch
  8013-brcmfmac-pcie-Provide-a-buffer-of-random-bytes-to-th.patch
  8014-brcmfmac-pcie-Add-IDs-properties-for-BCM4355.patch
  8015-brcmfmac-pcie-Add-IDs-properties-for-BCM4377.patch
  8016-brcmfmac-pcie-Perform-correct-BCM4364-firmware-selec.patch
  8017-brcmfmac-chip-Only-disable-D11-cores-handle-an-arbit.patch
  8018-brcmfmac-chip-Handle-1024-unit-sizes-for-TCM-blocks.patch
  8019-brcmfmac-cfg80211-Add-support-for-scan-params-v2.patch
  8020-brcmfmac-feature-Add-support-for-setting-feats-based.patch
  8021-brcmfmac-cfg80211-Add-support-for-PMKID_V3-operation.patch
  8022-brcmfmac-cfg80211-Pass-the-PMK-in-binary-instead-of-.patch
  8023-brcmflac-cfg80211-Use-WSEC-to-set-SAE-password.patch
  8024-brcmfmac-pcie-Add-IDs-properties-for-BCM4387.patch
  8025-brcmfmac-common-Add-support-for-downloading-TxCap-bl.patch
  8026-brcmfmac-pcie-Load-and-provide-TxCap-blobs.patch
  8027-brcmfmac-common-Add-support-for-external-calibration.patch

  # do not make the t2 angry with some kernel configs
  9001-efi-Do-not-import-certificates-from-UEFI-Secure-Boot.patch

)

validpgpkeys=(
  'ABAF11C65A2970B130ABE3C479BE3E4300411886'  # Linus Torvalds
  '647F28654894E3BD457199BE38DBBDC86092693E'  # Greg Kroah-Hartman
)

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"

prepare() {
  cd $_srcname

  echo "Setting version..."
  scripts/setlocalversion --save-scmversion
  echo "-$pkgrel" > localversion.10-pkgrel
  echo "${pkgbase#linux}" > localversion.20-pkgname

  for i in apple-bce apple-ibridge; do
    echo "Copying $i in to drivers/staging..."
	# no need to copy .git/
	mkdir drivers/staging/$i
    cp -r $srcdir/$i/* drivers/staging/$i/
  done

  local src
  for src in "${source[@]}"; do
    src="${src%%::*}"
    src="${src##*/}"
    [[ $src = *.patch ]] || continue
    echo "Applying patch $src..."
    patch -Np1 < "../$src"
  done

  echo "Setting config..."
  cp ../config .config
  make olddefconfig
  diff -u ../config .config || :

  make -s kernelrelease > version
  echo "Prepared $pkgbase version $(<version)"
}

build() {
  cd $_srcname
  make all
  make htmldocs
}

_package() {
  pkgdesc="The $pkgdesc kernel and modules"
  depends=(coreutils kmod initramfs)
  optdepends=('wireless-regdb: to set the correct wireless channels of your country'
              'linux-firmware: firmware images needed for some devices')
  provides=(VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE linux)
  replaces=(virtualbox-guest-modules-arch wireguard-arch)

  cd $_srcname
  local kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$kernver"

  echo "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  echo "Installing modules..."
  make INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 \
    DEPMOD=/doesnt/exist modules_install  # Suppress depmod

  # remove build and source links
  rm "$modulesdir"/{source,build}
}

_package-headers() {
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel"
  depends=(pahole)
  provides=(linux-headers)

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # required when STACK_VALIDATION is enabled
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # required when DEBUG_INFO_BTF_MODULES is enabled
  install -Dt "$builddir/tools/bpf/resolve_btfids" tools/bpf/resolve_btfids/resolve_btfids

  echo "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # https://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # https://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

  # https://bugs.archlinux.org/task/71392
  install -Dt "$builddir/drivers/iio/common/hid-sensors" -m644 drivers/iio/common/hid-sensors/*.h

  echo "Installing KConfig files..."
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  echo "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */x86/ ]] && continue
    echo "Removing $(basename "$arch")"
    rm -r "$arch"
  done

  echo "Removing documentation..."
  rm -r "$builddir/Documentation"

  echo "Removing broken symlinks..."
  find -L "$builddir" -type l -printf 'Removing %P\n' -delete

  echo "Removing loose objects..."
  find "$builddir" -type f -name '*.o' -printf 'Removing %P\n' -delete

  echo "Stripping build tools..."
  local file
  while read -rd '' file; do
    case "$(file -bi "$file")" in
      application/x-sharedlib\;*)      # Libraries (.so)
        strip -v $STRIP_SHARED "$file" ;;
      application/x-archive\;*)        # Libraries (.a)
        strip -v $STRIP_STATIC "$file" ;;
      application/x-executable\;*)     # Binaries
        strip -v $STRIP_BINARIES "$file" ;;
      application/x-pie-executable\;*) # Relocatable binaries
        strip -v $STRIP_SHARED "$file" ;;
    esac
  done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux -print0)

  echo "Stripping vmlinux..."
  strip -v $STRIP_STATIC "$builddir/vmlinux"

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"
}

_package-docs() {
  pkgdesc="Documentation for the $pkgdesc kernel"
  provides=(linux-docs)

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing documentation..."
  local src dst
  while read -rd '' src; do
    dst="${src#Documentation/}"
    dst="$builddir/Documentation/${dst#output/}"
    install -Dm644 "$src" "$dst"
  done < <(find Documentation -name '.*' -prune -o ! -type d -print0)

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/share/doc"
  ln -sr "$builddir/Documentation" "$pkgdir/usr/share/doc/$pkgbase"
}

pkgname=("$pkgbase" "$pkgbase-headers" "$pkgbase-docs")
for _p in "${pkgname[@]}"; do
  eval "package_$_p() {
    $(declare -f "_package${_p#$pkgbase}")
    _package${_p#$pkgbase}
  }"
done

sha256sums=('22f67ef6b12ef6c0c0353be4b90b4bf4b9b18b858c16c346fa495b67ec718c99'
            'SKIP'
            'fb37785c43d90085ab4e7d7cee522cb8232713b6c601d74cfc7234eeaeb1e6b5'
            'cd49e0569ce381b6776fff5107286d7d07d89980978a9951d339a0e09adbbf1b'
            'SKIP'
            'SKIP'
            'b7c987889d92a48d638d5258842b10f6c856e57f29ad23475aa507c7b4ad5710'
            'a3a43feaffccbcd119f4a1b4e1299ef07ae36ef9bffc17767bf10e447fa02a2a'
            '45b911e592dd6c717e77ec4d8cbf844860bb7c29ace7a7170e7bf59c12e91bb4'
            'cfd23a06797ac86575044428a393dd7f10f06eff7648d0b78aedad82cbe41279'
            '8d8401a99a9dfbc41aa2dc5b6a409a19860b1b918465e19de4a4ff18de075ea3'
            '08d165106fe35b68a7b48f216566951a5db0baac19098c015bcc81c5fcba678d'
            '62f6d63815d4843ca893ca76b84a9d32590a50358ca0962017ccd75a40884ba8'
            '2827dab6eeb2d2a08034938024f902846b5813e967a0ea253dc1ea88315da383'
            '398dec7d54c6122ae2263cd5a6d52353800a1a60fd85e52427c372ea9974a625'
            'd4ca5a01da5468a1d2957b8eb4a819e1b867a3bcd1cd47389d7c9ac9154b5430'
            '6b1033f3081e3c69a909694a8114407268a22f744edc651cf0e018c3dc671f17'
            '9f5a32bd63432ac30cfcd4bd38b037f32fd53e7c5b181b422b8d3dc9f3c4f813'
            'a2095aef8d6470d220a4990f356eabbbaf3e11cc0d711185bae17acb67936cc1'
            'b1f19084e9a9843dd8c457c55a8ea8319428428657d5363d35df64fb865a4eae'
            '92e6f4173074ac902c3fc397ea39a5ff6d5eb8645539645c0cd61b3d05ac83ca'
            '31e65ffa0ec2a998de6a806f931a9ca684a9be5933918a94b0e79ef6456e0821'
            '9ede98eceb69e9c93e25fdb2c567466963bdd2f81c0ecb9fb9e5107f6142ff26'
            'dfe5f4e112d339c7b0950916d636509a1eb3290652b1cd9c6e72a06f07f5980b'
            'c404b53cf6967e8e220c2990096a688b4d5a824b96bb3788cd8dab77222925b1'
            '4898424e625142cf98b5140e2cf7fe725a79ad52b3910916aa85fd722b54e8e6'
            '666ab8ebeda7a52216830668fdc1ae6b339ee01960e20710ed12d54d4f207f46'
            '95a2e6e512760a503ba0c5feedd7c917f9c01cd9a5b9d8f3b23b3eb47786495f'
            'e182f913dbdb27e6b8055a817d864823c6263b421e2c2f94e138056f7ead10a7'
            '5bc6d41c5f442d1e69151ca4108f8fe931628f897430aff1c18331237af341ec'
            '8207c195e75494aa5375f5c992d6876b1b7417b69dac937766fafbdb75e6b68a'
            '199c7b73f111b41824f1706f3d80bf5b209732d8982307a1a35d3a67fe5d5476'
            '7d0eec498d9b82aac89f84fb39747b82338e18615ee101834626966726ee37f9'
            '786289896c39590274594be6e34630c02854ae504334c945ccf380a0557ad50c'
            'd0ab6225f51a722fbc38aadfd6a5682b34087d235a25a0cbc8445571989a26c6'
            '96e47a1922b3ec423e01a67e7ecdbdcefa81600b1e5426ee204e9b6fdd9e386c'
            'ec1b389e3c2e3ae3b228eb819577e26ce79a41b156a39cae78242ae16a72d97d'
            '8e0f43d13c1bc0fba64499322f73e5d01cb0e0b1c7c498bfd7aae422e6216d04'
            'f7f072d1644746b1bd2a84c23a96c7228b9a6853941fdd4933bc4a433c750796'
            'e9062da9b3892c64258049333cbce57dfd8f334676063d95bba879c7154b56d0'
            '417eb1c3f51dc639b249b8d9110c47c8da5cce9e4889f4bc47b03bcc2a4f192a'
            'ba4fa954cc6e24a643c97120e3c6f5031a27382f89ad3affe231f5d1170c1ed7'
            '60251fa2006dc1e399c870f74a3a07212312a1da7aec0bdc699dfbb48b950703'
            '25e37df5b2ff9343be06d4c2005c7daacc14c830d05a6e20b23e471921d35942'
            'd6148567779e528347a6874d1c3c9795bd2fbe78e035ac83540b2567f86d8502'
            'aa7f19598f4cccb402545016dbeaf73aa6f72ac5b360c8a12e14750a593ceb13'
            'f141edb39a58e4d465fea99a0b002e3ab83b86e5d2ec4d0b86f118c158d271f7'
            '2a79e9781b1f3603a177837b3156ff0b083769cd951e4b37f559d84570a6e132'
            '5e2cd52811daeacda9136556d2c7754746ce026dcf44f16334b013603a877b94'
            '1dfdd62233a9b4b4e5da65374d1e74d0727aeb6d76d191bd2163ec033e7e1fb1'
            '9c66c30e5312922918d92411d4698291071a9f7b6be6a54f19fc74a31e3cfca4')
# vim:set ts=8 sts=2 sw=2 et:
