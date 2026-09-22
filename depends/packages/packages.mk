packages:=boost openssl libevent gmp

qt_native_packages = native_protobuf
qt_packages = qrencode protobuf zlib

qt_linux_packages:=qt expat dbus libxcb xcb_proto libXau xproto freetype fontconfig libX11 xextproto libXext xtrans

qt_darwin_packages=qt
qt_mingw32_packages=qt

wallet_packages=bdb

zmq_packages=zeromq

upnp_packages=miniupnpc

# biplist/ds_store/mac_alias are only used by contrib/macdeploy/macdeployqtplus to style the Qt .dmg
# (background image, icon layout, Finder metadata) — no use for a NO_QT=1 (daemon/cli-only) build, and
# their setup.py-based builds (import ez_setup) are broken under recent Python 3 anyway.
ifeq ($(NO_QT),)
darwin_native_packages = native_biplist native_ds_store native_mac_alias
endif

ifneq ($(build_os),darwin)
darwin_native_packages += native_cctools native_cdrkit native_libdmg-hfsplus
endif
