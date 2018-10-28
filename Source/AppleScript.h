//
//  AppleScript.h
//  ControlPlaneX
//
//  Created by David Jennes on 24/08/11.
//  Copyright 2011. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSApplication (AppleScript)

- (NSString *) currentContext;
- (void) setCurrentContext: (NSString*) newContext;

- (NSNumber *) sticky;
- (void) setSticky: (NSNumber *) sticky;

@end
