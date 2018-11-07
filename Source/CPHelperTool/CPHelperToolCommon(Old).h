//
//  CPHelperToolCommon.h
//  ControlPlaneX
//
//  Created by Dustin Rue on 3/9/11.
//  Copyright 2011. All rights reserved.
//

#ifndef ControlPlaneX_CPHelperToolCommon_h
#define ControlPlaneX_CPHelperToolCommon_h

#import "BetterAuthorizationSampleLib.h"

// Helper tool version
#define kCPHelperToolVersionNumber              25

// Commands
#define kCPHelperToolGetVersionCommand              "GetVersion"
#define kCPHelperToolGetVersionResponse             "Version"

#define kCPHelperToolEnableTMCommand                "EnableTM"
#define kCPHelperToolDisableTMCommand               "DisableTM"
#define kCPHelperToolStartBackupTMCommand           "StartBackupTM"
#define kCPHelperToolStopBackupTMCommand            "StopBackupTM"

#define kCPHelperToolEnableISCommand                "EnableIS"
#define kCPHelperToolDisableISCommand               "DisableIS"

#define kCPHelperToolEnableFirewallCommand          "EnableFirewall"
#define kCPHelperToolDisableFirewallCommand         "DisableFirewall"

#define kCPHelperToolSetDisplaySleepTimeCommand     "SetDisplaySleepTime"

#define kCPHelperToolEnablePrinterSharingCommand    "EnablePrinterSharing"
#define kCPHelperToolDisablePrinterSharingCommand   "DisablePrinterSharing"

// TFTP commands
#define kCPHelperToolEnableTFTPCommand              "EnableTFTPCommand"
#define kCPHelperToolDisableTFTPCommand             "DisableTFTPCommand"

// FTP commands
#define kCPHelperToolEnableFTPCommand               "EnableFTPCommand"
#define kCPHelperToolDisableFTPCommand              "DisableFTPCommand"


// file sharing
#define kCPHelperToolEnableAFPFileSharingCommand    "EnableAFPFileSharing"
#define kCPHelperToolDisableAFPFileSharingCommand   "DisableAFPFileSharing"
#define kCPHelperToolEnableSMBFileSharingCommand    "EnableSMBFileSharing"
#define kCPHelperToolDisableSMBFileSharingCommand   "DisableSMBFileSharing"

#define kCPHelperToolSMBPrefsFilePath               "/Library/Preferences/SystemConfiguration/com.apple.smb.server"
#define kCPHelperToolSMBSyncToolFilePath            "/usr/libexec/samba/smb-sync-preferences"
#define kCPHelperToolSMBSyncToolFilePathMavericks   "/usr/libexec/smb-sync-preferences"

#define kCPHelperToolFileSharingStatusKey           "Disabled"
#define kCPHelperToolFilesharingConfigResponse      "sharingStatus"
#define kCPHelperToolAFPServiceName                 "com.apple.AppleFileServer"
#define kCPHelperToolSMBDServiceName                "com.apple.smbd"

// Web Sharing
#define kCPHelperToolEnableWebSharingCommand        "EnableWebSharing"
#define kCPHelperToolDisableWebSharingCommand       "DisableWebSharing"

// Remote Login (ssh)
#define kCPHelperToolEnableRemoteLoginCommand       "EnableRemoteLogin"
#define kCPHelperToolDisableRemoteLoginCommand      "DisableRemoteLogin"

// Rights
#define kCPHelperToolToggleTMRightName              "ua.in.pboyko.ControlPlaneX.ToggleTM"
#define kCPHelperToolRunBackupTMRightName           "ua.in.pboyko.ControlPlaneX.RunBackupTM"
#define kCPHelperToolToggleISRightName              "ua.in.pboyko.ControlPlaneX.ToggleIS"
#define kCPHelperToolToggleFWRightName              "ua.in.pboyko.ControlPlaneX.ToggleFW"
#define kCPHelperToolSetDisplaySleepTimeRightName   "ua.in.pboyko.ControlPlaneX.SetDisplaySleepTime"
#define kCPHelperToolTogglePrinterSharingRightName  "ua.in.pboyko.ControlPlaneX.TogglePrinterSharing"
#define kCPHelperToolFileSharingRightName           "ua.in.pboyko.ControlPlaneX.FileSharingRightName"
#define kCPHelperToolTFTPRightName                  "ua.in.pboyko.ControlPlaneX.TFTPRightName"
#define kCPHelperToolFTPRightName                   "ua.in.pboyko.ControlPlaneX.FTPRightName"
#define kCPHelperToolWebSharingRightName            "ua.in.pboyko.ControlPlaneX.WebSharingRightName"
#define kCPHelperToolRemoteLoginRightName           "ua.in.pboyko.ControlPlaneX.RemoteLoginRightName"


// Misc

#define kPRIVILEGED_HELPER_LABEL @"ua.in.pboyko.CPHelperTool"
#define kSigningCertCommonName "3rd Party Mac Developer Application: Dustin Rue"

#define kInstallCommandLineToolCommand      "InstallTool"
#define kInstallCommandLineToolSrcPath      "srcPath"   // Parameter, CFString
#define kInstallCommandLineToolName         "toolName"  // Parameter, CFString
#define kInstallCommandLineToolResponse		"Success"   // Response, CFNumber
#define	kInstallCommandLineToolRightName	"ua.in.pboyko.ControlPlaneX.InstallTool"


// Commands array (keep in sync!)
extern const BASCommandSpec kCPHelperToolCommandSet[];

#endif
