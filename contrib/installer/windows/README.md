# Windows installer

Builds a single-file `LunariumCoin-<version>-<arch>-Setup.exe` with
[Inno Setup](https://jrsoftware.org/isinfo.php) (6.4+, needed for the native
`Flags: external download` support used to fetch the blockchain bootstrap).

The installer offers an optional "Bootstrap blockchain files" component,
downloaded and extracted straight into `%APPDATA%\LunariumCoin` during
install (using Windows' built-in `tar.exe`), so the wallet starts already
close to synced instead of syncing from scratch over the network.

## Build

1. Place the compiled binaries (`lunariumcoind.exe`, `lunariumcoin-cli.exe`,
   `lunariumcoin-tx.exe`, `lunariumcoin-qt.exe`) for each architecture in
   `release/win64/` and `release/win32/` respectively (relative to the repo
   root).
2. From this directory, run:

   ```
   ISCC.exe lunariumcoin-setup.iss /DARCH=x64 /DBINDIR=..\..\..\release\win64
   ISCC.exe lunariumcoin-setup.iss /DARCH=x86 /DBINDIR=..\..\..\release\win32
   ```

Output goes to `release/LunariumCoin-<version>-<arch>-Setup.exe`.
