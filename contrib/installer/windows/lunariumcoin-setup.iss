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
procedure EnsureConfHasAddnodes(DataDir: String);
var
  ConfPath: String;
  Lines: TArrayOfString;
  Contents: String;
  HasAddnode: Boolean;
  I: Integer;
begin
  ConfPath := DataDir + '\lunariumcoin.conf';
  HasAddnode := False;
  if FileExists(ConfPath) then
  begin
    if LoadStringsFromFile(ConfPath, Lines) then
      for I := 0 to GetArrayLength(Lines) - 1 do
        if Pos('addnode=', Lines[I]) = 1 then
          HasAddnode := True;
  end;
  if not HasAddnode then
  begin
    // Known-good peers (from explorerxln.com/network) as a fallback in case
    // the DNS seeds (seed1-8.lunariumcoin.{com,org}) are slow or partially
    // unreachable. Only added if the user doesn't already have their own
    // addnode= entries, so this never overrides a custom setup.
    Contents := '# Extra peers added by the LunariumCoin installer' + #13#10 +
      '# so the wallet can find the network immediately after the' + #13#10 +
      '# bootstrap import, instead of waiting on DNS seed discovery.' + #13#10 +
      'addnode=169.58.162.17' + #13#10 +
      'addnode=172.93.101.119' + #13#10 +
      'addnode=192.3.1.184' + #13#10 +
      'addnode=205.209.102.70' + #13#10 +
      'addnode=207.180.250.24' + #13#10 +
      'addnode=77.237.232.84' + #13#10 +
      'addnode=85.208.9.222' + #13#10 +
      'addnode=[2605:a142:2073:5571:f719::8]' + #13#10 +
      'addnode=[2a02:c207:2320:1978::16]' + #13#10 +
      'addnode=[2a02:c207:2320:1978::18]' + #13#10 +
      'addnode=[2a02:c207:2320:1978::20]' + #13#10 +
      'addnode=[2a02:c207:2320:1978::40]' + #13#10 +
      'addnode=[2a02:c207:2320:1978::41]' + #13#10 +
      'addnode=[2a02:c207:2320:1978::6]' + #13#10 +
      'addnode=[2a02:c207:2320:1978::8]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::100]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::102]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::103]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::104]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::105]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::106]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::10a]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::10e]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::10f]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::110]' + #13#10 +
      'addnode=[2a02:c207:2350:2044::118]' + #13#10 +
      'addnode=[2a12:bec4:1821:1ea::a]' + #13#10;
    SaveStringToFile(ConfPath, Contents, True);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
  DataDir: String;
  ArchivePath: String;
begin
  if CurStep = ssPostInstall then
  begin
    DataDir := ExpandConstant('{userappdata}\LunariumCoin');
    ForceDirectories(DataDir);
    EnsureConfHasAddnodes(DataDir);

    ArchivePath := ExpandConstant('{tmp}\bootstrap-latest.tar.gz');
    if FileExists(ArchivePath) then
    begin
      Exec(ExpandConstant('{sys}\tar.exe'), '-xzf "' + ArchivePath + '" -C "' + DataDir + '"', '', SW_HIDE,
        ewWaitUntilTerminated, ResultCode);
      if ResultCode <> 0 then
        Log('Bootstrap extraction failed with exit code ' + IntToStr(ResultCode) + '; wallet will sync from scratch.');
    end;
  end;
end;
