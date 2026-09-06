#define MyAppName "XWalnut"
#ifndef MyAppVersion
  #define MyAppVersion "0.0.0"
#endif
#define AppGuid "{{CAA7AA4B-1353-4664-B637-A5B6C4F981A1}}"
#define LivelyAppId "{E3E43E1B-DEC8-44BF-84A6-243DBA3F2CB1}"
#define LivelySetupName "lively_setup_x86_full_v2210.exe"

[Setup]
AppId={#AppGuid}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher=CHRcr
AppPublisherURL=https://github.com/CHRcr/XWalnut
AppSupportURL=https://github.com/CHRcr/XWalnut
DefaultDirName={localappdata}\XWalnut
DisableProgramGroupPage=yes
DisableDirPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
SetupArchitecture=x64
MinVersion=10.0.18362
OutputBaseFilename=XWalnut-setup
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
DisableWelcomePage=yes
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Files]
Source: "scripts\lively-install.ps1"; DestDir: "{tmp}\scripts"; Flags: deleteafterinstall
Source: "scripts\download-lively.ps1"; DestDir: "{tmp}\scripts"; Flags: deleteafterinstall
Source: "payload\XWalnut-lively.zip"; DestDir: "{tmp}\payload"; Flags: deleteafterinstall
Source: "payload\bridge-payload.zip"; DestDir: "{tmp}\payload"; Flags: deleteafterinstall
Source: "payload\{#LivelySetupName}"; DestDir: "{tmp}\payload"; Flags: deleteafterinstall
Source: "scripts\uninstall-xwalnut.ps1"; DestDir: "{localappdata}\XWalnut\scripts"; Flags: ignoreversion; AfterInstall: RunInstallSteps

[UninstallDelete]
Type: filesandordirs; Name: "{localappdata}\XWalnut\bridge"
Type: filesandordirs; Name: "{localappdata}\XWalnut\scripts"
Type: files; Name: "{localappdata}\XWalnut\music-cookie.txt"
Type: files; Name: "{localappdata}\XWalnut\music-bridge.log"
Type: files; Name: "{localappdata}\XWalnut\music-uninstall.log"
Type: dirifempty; Name: "{localappdata}\XWalnut"

[Code]
const
  LivelyKeyBase = 'Software\Microsoft\Windows\CurrentVersion\Uninstall\{#LivelyAppId}_is1';
  LivelyKeyBase32 = 'Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{#LivelyAppId}_is1';

var
  InstallLogMemo: TNewMemo;

procedure AppendInstallLog(const LogText: String);
var
  line: String;
begin
  line := Trim(LogText);
  if line = '' then
    exit;
  StringChangeEx(line, '[XWalnut] ', '', True);
  InstallLogMemo.Lines.Add(line);
  InstallLogMemo.SelStart := Length(InstallLogMemo.Text);
  InstallLogMemo.SelLength := 0;
end;

procedure InstallOutput(const S: String; const Error, FirstLine: Boolean);
begin
  if Error then
    AppendInstallLog('错误：' + S)
  else
    AppendInstallLog(S);
  WizardForm.Repaint;
end;

procedure InitializeWizard();
begin
  InstallLogMemo := TNewMemo.Create(WizardForm);
  InstallLogMemo.Parent := WizardForm.InstallingPage;
  InstallLogMemo.Left := WizardForm.ProgressGauge.Left;
  InstallLogMemo.Top := WizardForm.ProgressGauge.Top + WizardForm.ProgressGauge.Height + ScaleY(12);
  InstallLogMemo.Width := WizardForm.ProgressGauge.Width;
  InstallLogMemo.Height := WizardForm.InstallingPage.ClientHeight - InstallLogMemo.Top - ScaleY(8);
  InstallLogMemo.ReadOnly := True;
  InstallLogMemo.ScrollBars := ssVertical;
  InstallLogMemo.WordWrap := True;
  InstallLogMemo.TabStop := False;
end;

function LivelyKeyHasEntry(RootKey: Integer; SubKey: String): Boolean;
var
  value: String;
begin
  value := '';
  RegQueryStringValue(RootKey, SubKey, 'DisplayName', value);
  Result := value <> '';
end;

function LivelyInstalled(): Boolean;
begin
  if LivelyKeyHasEntry(HKCU, LivelyKeyBase) or LivelyKeyHasEntry(HKCU, LivelyKeyBase32)
     or LivelyKeyHasEntry(HKLM, LivelyKeyBase) or LivelyKeyHasEntry(HKLM, LivelyKeyBase32) then
    Result := True
  else
    Result := FileExists(ExpandConstant('{localappdata}\Programs\Lively Wallpaper\Lively.exe'))
      or FileExists(ExpandConstant('{autopf}\Lively Wallpaper\Lively.exe'))
      or FileExists(ExpandConstant('{autopf32}\Lively Wallpaper\Lively.exe'));
end;

procedure SetInstallStatus(const StatusText: String);
begin
  WizardForm.StatusLabel.Caption := StatusText;
  WizardForm.FilenameLabel.Caption := '';
  WizardForm.ProgressGauge.Style := npbstMarquee;
  AppendInstallLog(StatusText);
end;

procedure RunInstallSteps();
var
  resultCode: Integer;
  psExe: String;
  cmd: String;
begin
  psExe := ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe');

  if not LivelyInstalled() then
  begin
    SetInstallStatus('正在安装 Lively Wallpaper 与运行库（约 2-5 分钟）：如弹出系统权限提示，请点击“是”…');
    cmd := '-NoProfile -ExecutionPolicy Bypass -File "' +
      ExpandConstant('{tmp}\scripts\download-lively.ps1') + '" -Local "' +
      ExpandConstant('{tmp}\payload\{#LivelySetupName}') + '"';
    if not ExecAndLogOutput(psExe, cmd, '', SW_HIDE, ewWaitUntilTerminated,
      resultCode, @InstallOutput) then
      RaiseException('无法启动 Lively Wallpaper 安装程序。');
    if resultCode <> 0 then
      RaiseException('Lively Wallpaper installation failed (exit code ' + IntToStr(resultCode) + ').');
  end;

  SetInstallStatus('正在安装 Music Bridge…');
  cmd := '-NoProfile -ExecutionPolicy Bypass -File "' +
    ExpandConstant('{tmp}\scripts\lively-install.ps1') +
    '" -LivelyZip "' + ExpandConstant('{tmp}\payload\XWalnut-lively.zip') +
    '" -BridgeZip "' + ExpandConstant('{tmp}\payload\bridge-payload.zip') + '"';
  if not ExecAndLogOutput(psExe, cmd, '', SW_HIDE, ewWaitUntilTerminated,
    resultCode, @InstallOutput) then
    RaiseException('无法启动 XWalnut 安装程序。');
  if resultCode <> 0 then
    RaiseException('XWalnut installation failed (exit code ' + IntToStr(resultCode) + ').');
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    if not WizardSilent then
      MsgBox('XWalnut 已安装并设为壁纸。' + #13#10 +
        '请打开壁纸底部「设置」，粘贴 MUSIC_U 完成网易云登录。',
        mbInformation, MB_OK);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  resultCode: Integer;
begin
  if CurUninstallStep = usUninstall then
    Exec(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'),
      '-NoProfile -ExecutionPolicy Bypass -File "' +
      ExpandConstant('{localappdata}\XWalnut\scripts\uninstall-xwalnut.ps1') + '"',
      ExpandConstant('{localappdata}\XWalnut\scripts'), SW_HIDE, ewWaitUntilTerminated, resultCode);
end;
