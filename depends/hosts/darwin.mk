OSX_MIN_VERSION=11.0
OSX_SDK_VERSION=10.11
OSX_SDK=$(SDK_PATH)/MacOSX$(OSX_SDK_VERSION).sdk
LD64_VERSION=253.9
# Building natively ON a Mac (build_os == darwin, e.g. a GitHub Actions macos-* runner): use the real
# installed SDK (SDKROOT env var, set by the caller) and the real linker that ships with it — SDK_PATH
# is never set in this repo (no extracted SDK is checked in), so --sysroot $(OSX_SDK) resolves to a
# path that doesn't exist, and pinning -mlinker-version to a decade-old ld64 while actually linking
# against a current SDK's libraries is exactly the kind of mismatch that produces a runtime crash (SIGBUS
# on startup, verified live building x86_64 on a macos-14 runner) instead of a build failure.
# Cross-compiling TO darwin FROM a non-darwin build machine (the original osxcross-style intent of this
# file) still needs both, from an extracted SDK — SDK_PATH would need to be set for that to work at all.
ifeq ($(build_os),darwin)
darwin_CC=clang -target $(host) -mmacosx-version-min=$(OSX_MIN_VERSION)
darwin_CXX=clang++ -target $(host) -mmacosx-version-min=$(OSX_MIN_VERSION) -stdlib=libc++
else
darwin_CC=clang -target $(host) -mmacosx-version-min=$(OSX_MIN_VERSION) --sysroot $(OSX_SDK) -mlinker-version=$(LD64_VERSION)
darwin_CXX=clang++ -target $(host) -mmacosx-version-min=$(OSX_MIN_VERSION) --sysroot $(OSX_SDK) -mlinker-version=$(LD64_VERSION) -stdlib=libc++
endif

darwin_CFLAGS=-pipe
darwin_CXXFLAGS=$(darwin_CFLAGS)

darwin_release_CFLAGS=-O2
darwin_release_CXXFLAGS=$(darwin_release_CFLAGS)

darwin_debug_CFLAGS=-O1
darwin_debug_CXXFLAGS=$(darwin_debug_CFLAGS)

darwin_native_toolchain=native_cctools
