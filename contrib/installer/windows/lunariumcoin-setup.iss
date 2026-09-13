; LunariumCoin Core Windows installer.
; Build with (from this directory, after placing the compiled binaries in
; SourceDir\win64 and SourceDir\win32 as described in README.md):
;   ISCC.exe lunariumcoin-setup.iss /DARCH=x64 /DBINDIR=..\..\..\release\win64
;   ISCC.exe lunariumcoin-setup.iss /DARCH=x86 /DBINDIR=..\..\..\release\win32

#ifndef ARCH
  #define ARCH "x64"
#endif
#ifndef BINDIR
  #define BINDIR "..\..\..\release\win64"
#endif

#define AppVersion "4.0.0"
#define BootstrapUrl "https://mundolunariumcoin.explorerxln.com/bootstrap/bootstrap-latest.tar.gz"
#define BootstrapSizeBytes 1200000000

[Setup]
AppId={{7A6E1E1E-6B4B-4A2E-9C6D-3C6E9D9F1A20}
AppName=LunariumCoin Core
AppVersion={#AppVersion}
AppPublisher=Lunariumcoin-Labs
AppPublisherURL=https://lunariumcoin.com/
AppSupportURL=https://github.com/Lunariumcoin-Labs/LunariumCoin
DefaultDirName={autopf}\LunariumCoin
DefaultGroupName=LunariumCoin
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\lunariumcoin-qt.exe
OutputDir=..\..\..\release
OutputBaseFilename=LunariumCoin-{#AppVersion}-{#ARCH}-Setup
SetupIconFile=lunariumcoin.ico
WizardStyle=modern
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
#if ARCH == "x64"
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional shortcuts:"

[Types]
Name: "full"; Description: "Full installation (wallet + blockchain bootstrap, recommended)"
Name: "compact"; Description: "Wallet only (syncs from the network from scratch)"
Name: "custom"; Description: "Custom"; Flags: iscustom

[Components]
Name: "core"; Description: "LunariumCoin Core Wallet"; Types: full compact custom; Flags: fixed
Name: "bootstrap"; Description: "Bootstrap blockchain files (downloads ~1.1 GB, so you don't have to sync from scratch)"; Types: full

[Files]
Source: "{#BINDIR}\lunariumcoind.exe"; DestDir: "{app}"; Components: core; Flags: ignoreversion
Source: "{#BINDIR}\lunariumcoin-cli.exe"; DestDir: "{app}"; Components: core; Flags: ignoreversion
Source: "{#BINDIR}\lunariumcoin-tx.exe"; DestDir: "{app}"; Components: core; Flags: ignoreversion
Source: "{#BINDIR}\lunariumcoin-qt.exe"; DestDir: "{app}"; Components: core; Flags: ignoreversion
Source: "{#BootstrapUrl}"; DestName: "bootstrap-latest.tar.gz"; DestDir: "{tmp}"; \
  Components: bootstrap; ExternalSize: {#BootstrapSizeBytes}; Flags: external download ignoreversion

[Icons]
Name: "{group}\LunariumCoin Core"; Filename: "{app}\lunariumcoin-qt.exe"
Name: "{autodesktop}\LunariumCoin Core"; Filename: "{app}\lunariumcoin-qt.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\lunariumcoin-qt.exe"; Description: "Launch LunariumCoin Core"; Flags: nowait postinstall skipifsilent

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
  DataDir: String;
  ArchivePath: String;
begin
  if CurStep = ssPostInstall then
  begin
    ArchivePath := ExpandConstant('{tmp}\bootstrap-latest.tar.gz');
    if FileExists(ArchivePath) then
    begin
      DataDir := ExpandConstant('{userappdata}\LunariumCoin');
      ForceDirectories(DataDir);
      Exec(ExpandConstant('{sys}\tar.exe'), '-xzf "' + ArchivePath + '" -C "' + DataDir + '"', '', SW_HIDE,
        ewWaitUntilTerminated, ResultCode);
      if ResultCode <> 0 then
        Log('Bootstrap extraction failed with exit code ' + IntToStr(ResultCode) + '; wallet will sync from scratch.');
    end;
  end;
end;
