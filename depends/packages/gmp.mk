package=gmp
$(package)_version=6.1.2
# $(package)_download_path=https://gmplib.org/download/gmp
$(package)_download_path=https://github.com/MasterStakeCore/depends/raw/main/
$(package)_file_name=$(package)-$($(package)_version).tar.bz2
$(package)_sha256_hash=5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2

define $(package)_set_vars
$(package)_config_opts=--disable-shared
$(package)_config_opts_mingw32=--enable-mingw CC_FOR_BUILD=$(build_CC)
$(package)_config_opts_linux=--with-pic
# GMP 6.1.2's (2016) hand-written arm64 assembly (invert_limb.lo etc.) uses a PC-relative addressing
# idiom (adrp/add ...:lo12:) that Apple's clang integrated assembler rejects outright ("unknown AArch64
# fixup kind!") — falls back to GMP's portable C implementation instead, which is correct, just not
# hand-tuned-asm fast.
$(package)_config_opts_aarch64_darwin=--disable-assembly
$(package)_cflags+=-std=gnu17
endef

define $(package)_config_cmds
  $($(package)_autoconf)
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef

