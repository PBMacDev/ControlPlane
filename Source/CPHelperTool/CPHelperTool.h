/*
     File: HelperTool.h
 Abstract: The main object in the helper tool.
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>

//TODO
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

//#define kCPHelperToolSMBPrefsFilePath               "/Library/Preferences/SystemConfiguration/com.apple.smb.server"
//#define kCPHelperToolSMBSyncToolFilePath            "/usr/libexec/samba/smb-sync-preferences"
//#define kCPHelperToolSMBSyncToolFilePathMavericks   "/usr/libexec/smb-sync-preferences"
//
//#define kCPHelperToolFileSharingStatusKey           "Disabled"
//#define kCPHelperToolFilesharingConfigResponse      "sharingStatus"
#define kCPHelperToolAFPServiceName                 "com.apple.AppleFileServer"
#define kCPHelperToolSMBDServiceName                "com.apple.smbd"

// Web Sharing
#define kCPHelperToolEnableWebSharingCommand        "EnableWebSharing"
#define kCPHelperToolDisableWebSharingCommand       "DisableWebSharing"

// Remote Login (ssh)
#define kCPHelperToolEnableRemoteLoginCommand       "EnableRemoteLogin"
#define kCPHelperToolDisableRemoteLoginCommand      "DisableRemoteLogin"

// Rights
//#define kCPHelperToolToggleTMRightName              "ua.in.pboyko.ControlPlaneX.ToggleTM"
//#define kCPHelperToolRunBackupTMRightName           "ua.in.pboyko.ControlPlaneX.RunBackupTM"
//#define kCPHelperToolToggleISRightName              "ua.in.pboyko.ControlPlaneX.ToggleIS"
//#define kCPHelperToolToggleFWRightName              "ua.in.pboyko.ControlPlaneX.ToggleFW"
//#define kCPHelperToolSetDisplaySleepTimeRightName   "ua.in.pboyko.ControlPlaneX.SetDisplaySleepTime"
//#define kCPHelperToolTogglePrinterSharingRightName  "ua.in.pboyko.ControlPlaneX.TogglePrinterSharing"
//#define kCPHelperToolFileSharingRightName           "ua.in.pboyko.ControlPlaneX.FileSharingRightName"
//#define kCPHelperToolTFTPRightName                  "ua.in.pboyko.ControlPlaneX.TFTPRightName"
//#define kCPHelperToolFTPRightName                   "ua.in.pboyko.ControlPlaneX.FTPRightName"
//#define kCPHelperToolWebSharingRightName            "ua.in.pboyko.ControlPlaneX.WebSharingRightName"
//#define kCPHelperToolRemoteLoginRightName           "ua.in.pboyko.ControlPlaneX.RemoteLoginRightName"


// Misc

//#define kPRIVILEGED_HELPER_LABEL @"ua.in.pboyko.CPHelperTool"
//#define kSigningCertCommonName "3rd Party Mac Developer Application: Dustin Rue"
//
//#define kInstallCommandLineToolCommand      "InstallTool"
//#define kInstallCommandLineToolSrcPath      "srcPath"   // Parameter, CFString
//#define kInstallCommandLineToolName         "toolName"  // Parameter, CFString
//#define kInstallCommandLineToolResponse        "Success"   // Response, CFNumber
//#define    kInstallCommandLineToolRightName    "ua.in.pboyko.ControlPlaneX.InstallTool"








// kHelperToolMachServiceName is the Mach service name of the helper tool.  Note that the value 
// here has to match the value in the MachServices dictionary in "HelperTool-Launchd.plist".

#define kHelperToolMachServiceName @"ua.in.pboyko.CPHelperTool"

// HelperToolProtocol is the NSXPCConnection-based protocol implemented by the helper tool 
// and called by the app.

@protocol HelperToolProtocol

@required

- (void)getVersionWithReply:(void(^)(NSString * version))reply;
    // This command simply returns the version number of the tool.  It's a good idea to include a 
    // command line this so you can handle app upgrades cleanly.

// The next two commands imagine an app that needs to store a license key in some global location 
// that's not writable by all users; thus, setting the license key requires elevated privileges. 
// To manage this there's a 'read' command--which by default can be used by everyone--to return 
// the key and a 'write' command--which requires admin authentication--to set the key.

//- (void)readLicenseKeyAuthorization:(NSData *)authData withReply:(void(^)(NSError * error, NSString * licenseKey))reply;
//    // Reads the current license key.  authData must be an AuthorizationExternalForm embedded
//    // in an NSData.
//
//- (void)writeLicenseKey:(NSString *)licenseKey authorization:(NSData *)authData withReply:(void(^)(NSError * error))reply;
//    // Writes a new license key.  licenseKey is the new license key string.  authData must be
//    // an AuthorizationExternalForm embedded in an NSData.
//
//- (void)bindToLowNumberPortAuthorization:(NSData *)authData withReply:(void(^)(NSError * error, NSFileHandle * ipv4Handle, NSFileHandle * ipv6Handle))reply;
    // This command imagines an app that contains an embedded web server.  A web server has to
    // bind to port 80, which is a privileged operation.  This command lets the app request that 
    // the privileged helper tool create sockets bound to port 80 and then pass them back to the 
    // app, thereby minimising the amount of code that has to run with elevated privileges.
    // authData must be an AuthorizationExternalForm embedded in an NSData and the sockets are 
    // returned wrapped up in NSFileHandles.

- (void)setDisplaySleepTime:(NSNumber *)param authorization:(NSData *)authData withReply:(void(^)(NSError * error))reply;

@end

// The following is the interface to the class that implements the helper tool.
// It's called by the helper tool's main() function, but not by the app directly.

@interface CPHelperTool : NSObject

- (id)init;

- (void)run;

@end
