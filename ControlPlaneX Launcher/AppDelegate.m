//
//  AppDelegate.m
//  ControlPlaneX Launcher
//
//  Created by Pavlo Boyko on 11/16/18.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"ua.in.pboyko.ControlPlaneX" options:0 additionalEventParamDescriptor:nil launchIdentifier:nil];

    [NSApp terminate:nil];
}

@end
