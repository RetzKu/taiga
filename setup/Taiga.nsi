; Modern UI
!include "MUI2.nsh"

; ------------------------------------------------------------------------------
; General

; Definitions
!define PRODUCT_EXE "Taiga.exe"
!define PRODUCT_NAME "Taiga"
!define PRODUCT_PUBLISHER "erengy"
!define PRODUCT_VERSION "1.0 beta"
!define PRODUCT_WEBSITE "http://erengy.com/projects/taiga/"

; Uninstaller
!define UNINST_EXE "Uninstall.exe"
!define UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

; Main settings
BrandingText "${PRODUCT_NAME} v${PRODUCT_VERSION}"
Name "${PRODUCT_NAME}"
OutFile "..\..\..\${PRODUCT_NAME}Setup.exe"
SetCompressor lzma

; Default installation folder
InstallDir "$APPDATA\${PRODUCT_NAME}"
; Get installation folder from registry, if available
InstallDirRegKey HKCU "Software\${PRODUCT_NAME}" ""

; Request application privileges for Windows Vista and above
RequestExecutionLevel user

; ------------------------------------------------------------------------------
; Interface settings

; Icons
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

; Page header
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "bitmap\header.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "bitmap\header.bmp"

; Welcome/Finish page
!define MUI_WELCOMEFINISHPAGE_BITMAP "bitmap\wizard.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "bitmap\wizard.bmp"

; Abort warning
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

; ------------------------------------------------------------------------------
; Pages

; Installation pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_EXE}"
!define MUI_FINISHPAGE_LINK "Visit club page at MyAnimeList.net"
!define MUI_FINISHPAGE_LINK_LOCATION "http://myanimelist.net/clubs.php?cid=21400"
!insertmacro MUI_PAGE_FINISH

; Uninstallation pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; ------------------------------------------------------------------------------
; Language

; Default language
!insertmacro MUI_LANGUAGE "English"

; ------------------------------------------------------------------------------
; Install section

Section "!${PRODUCT_NAME}" SEC01
  ; Set properties
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  
  ; Add files
  File "..\..\..\Taiga.exe"
  SetOutPath "$INSTDIR\data\"
  File /r "..\data\"
  
  ; Skip in silent installation mode
  IfSilent +6
  ; Store installation folder
  WriteRegStr HKCU "Software\${PRODUCT_NAME}" "" $INSTDIR
  ; Start menu shortcuts
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_EXE}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\${UNINST_EXE}"
  ; Desktop shortcut
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_EXE}"
  
  ; Uninstaller
  WriteUninstaller "$INSTDIR\${UNINST_EXE}"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKCU "${UNINST_KEY}" "UninstallString" "$INSTDIR\${UNINST_EXE}"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PRODUCT_EXE}"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKCU "${UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEBSITE}"
  WriteRegStr HKCU "${UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

; ------------------------------------------------------------------------------
; Uninstall section

Section Uninstall
  ; Delete registry entries
  DeleteRegKey HKCU "${UNINST_KEY}"
  DeleteRegKey /ifempty HKCU "Software\${PRODUCT_NAME}"
  
  ; Delete start menu shortcuts
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
  
  ; Delete desktop shortcut
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  
  ; Delete files
  Delete "$INSTDIR\${PRODUCT_EXE}"
  Delete "$INSTDIR\${UNINST_EXE}"
  RMDir /r "$INSTDIR\data\"
SectionEnd