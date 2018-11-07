//
//  Action+HelperTool.m
//  ControlPlaneX
//
//  Created by David Jennes on 05/09/11.
//  Copyright 2011. All rights reserved.
//
// Reworked by Dustin Rue to support SMJobBless, thanks to Steve Streeting for making this easier
// to figure out and doing most of the leg work
// -- http://www.stevestreeting.com/2012/03/05/follow-up-os-x-privilege-escalation-without-using-deprecated-methods/


#import "Action+HelperTool.h"
#import <ServiceManagement/ServiceManagement.h>
#import "CPHelperToolCommon.h"
#import "DSLogger.h"

@interface CPHelperToolConnection : NSObject {
    AuthorizationRef    _authRef;
}

@property (atomic, copy,   readwrite) NSData *                  authorization;
@property (atomic, strong, readwrite) NSXPCConnection *         helperToolConnection;

+ (CPHelperToolConnection*) sharedConnection;
- (void)connectToAuthorisationSevices;
- (void)connectToHelperTool;
- (void)connectAndExecuteCommandBlock:(void(^)(NSError *))commandBlock;
- (void)installHelperToolIfNeeded;
- (void)installHelperTool;

- (void)setDisplaySleepTime:(NSNumber*)param;

@end

static CPHelperToolConnection *sCPHelperToolConnection = nil;


@interface Action (HelperTool_Private)

//- (OSStatus) helperToolActualPerform: (NSString *) action
//                                    withParameter: (id) parameter
//                                         response: (CFDictionaryRef *) response
//                                             auth: (AuthorizationRef) auth;
//- (void) helperToolInit: (AuthorizationRef *) auth;
//- (OSStatus) helperToolFix: (BASFailCode) failCode withAuth: (AuthorizationRef) auth;
//- (void) helperToolAlert: (NSMutableDictionary *) parameters;

//BOOL installHelperToolUsingSMJobBless(void);
//BOOL blessHelperWithLabel(NSString* label, NSError** error);

@end

@implementation CPHelperToolConnection

+ (CPHelperToolConnection*) sharedConnection {
    if (sCPHelperToolConnection == nil) {
        sCPHelperToolConnection = [[CPHelperToolConnection alloc] init];
        [sCPHelperToolConnection connectToAuthorisationSevices];
    }
    
    [sCPHelperToolConnection connectToAuthorisationSevices];
    
    return sCPHelperToolConnection;
}

- (void) connectToAuthorisationSevices {
    
    OSStatus                    err;
    AuthorizationExternalForm   extForm;
    
    // Create our connection to the authorization system.
    //
    // If we can't create an authorization reference then the app is not going to be able
    // to do anything requiring authorization.  Generally this only happens when you launch
    // the app in some wacky, and typically unsupported, way.  In the debug build we flag that
    // with an assert.  In the release build we continue with self->_authRef as NULL, which will
    // cause all authorized operations to fail.
    
    err = AuthorizationCreate(NULL, NULL, 0, &self->_authRef);
    if (err == errAuthorizationSuccess) {
        err = AuthorizationMakeExternalForm(self->_authRef, &extForm);
    }
    if (err == errAuthorizationSuccess) {
        self.authorization = [[NSData alloc] initWithBytes:&extForm length:sizeof(extForm)];
    }
    assert(err == errAuthorizationSuccess);
    
    // If we successfully connected to Authorization Services, add definitions for our default
    // rights (unless they're already in the database).
    
    if (self->_authRef) {
        [CPHelperToolCommon setupAuthorizationRights:self->_authRef];
    }
}

- (void)connectToHelperTool
// Ensures that we're connected to our helper tool.
{
//    assert([NSThread isMainThread]);
    if (self.helperToolConnection == nil) {
        self.helperToolConnection = [[NSXPCConnection alloc] initWithMachServiceName:kHelperToolMachServiceName options:NSXPCConnectionPrivileged];
        self.helperToolConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(HelperToolProtocol)];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        // We can ignore the retain cycle warning because a) the retain taken by the
        // invalidation handler block is released by us setting it to nil when the block
        // actually runs, and b) the retain taken by the block passed to -addOperationWithBlock:
        // will be released when that operation completes and the operation itself is deallocated
        // (notably self does not have a reference to the NSBlockOperation).
        self.helperToolConnection.invalidationHandler = ^{
            // If the connection gets invalidated then, on the main thread, nil out our
            // reference to it.  This ensures that we attempt to rebuild it the next time around.
            self.helperToolConnection.invalidationHandler = nil;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.helperToolConnection = nil;
//                [self logText:@"connection invalidated\n"];
            }];
        };
#pragma clang diagnostic pop
        [self.helperToolConnection resume];
    }
}

- (void)connectAndExecuteCommandBlock:(void(^)(NSError *))commandBlock
// Connects to the helper tool and then executes the supplied command block on the
// main thread, passing it an error indicating if the connection was successful.
{
//    assert([NSThread isMainThread]);
    
    // Ensure that there's a helper tool connection in place.
    
    [self connectToHelperTool];
    
    // Run the command block.  Note that we never error in this case because, if there is
    // an error connecting to the helper tool, it will be delivered to the error handler
    // passed to -remoteObjectProxyWithErrorHandler:.  However, I maintain the possibility
    // of an error here to allow for future expansion.
    
    commandBlock(nil);
}

- (void)installHelperTool
{
    Boolean             success;
    CFErrorRef          error;

    success = SMJobBless(
                         kSMDomainSystemLaunchd,
                         CFSTR("ua.in.pboyko.CPHelperTool"),
                         self->_authRef,
                         &error
                         );
    
    if (success) {
        DSLog(@"success");
    } else {
        DSLog(@"error %@ / %d", [(__bridge NSError *) error domain], (int) [(__bridge NSError *) error code]);
        CFRelease(error);
    }
}

- (void)installHelperToolIfNeeded
{
    
    [self connectAndExecuteCommandBlock:^(NSError * connectError) {
        if (connectError != nil) {
            [self installHelperTool];
        } else {
            [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError * proxyError) {
                [self installHelperTool];
            }] getVersionWithReply:^(NSString *version) {
                //TODO compare to the latest version
                if (![version isEqualToString:@"9.0"]) {
                    [self installHelperTool];
                }
            }];
        }
    }];
}

- (void)setDisplaySleepTime:(NSNumber*)param
// Called when the user clicks the Write License button.  This is an example of an
// authorized command that, by default, can only be done by administrators.
{
    [self connectAndExecuteCommandBlock:^(NSError * connectError) {
        if (connectError != nil) {
            DSLog(@"error %@ / %d", [connectError domain], (int) [connectError code]);
        } else {
            [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError * proxyError) {
//                [self logError:proxyError];
                DSLog(@"error %@ / %d", [proxyError domain], (int) [proxyError code]);
            }] setDisplaySleepTime:param authorization:self.authorization withReply:^(NSError *error) {
                if (error != nil) {
                    DSLog(@"error %@ / %d", [error domain], (int) [error code]);
                } else {
                    DSLog(@"success");
                }
            }];
        }
    }];
}


@end

@implementation Action (HelperTool)


- (BOOL) helperToolPerformAction: (NSString *) action {
    return [self helperToolPerformAction:action withParameter:nil];
}

- (BOOL) helperToolPerformAction: (NSString *) action withParameter: (id) parameter {
    
    helperToolResponse = NULL;
    OSStatus error = noErr;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[CPHelperToolConnection sharedConnection] setDisplaySleepTime:parameter];
    }];

   
    return (error ? NO : YES);
}

+ (void)setupHelperTool {
    [[CPHelperToolConnection sharedConnection] installHelperToolIfNeeded];
}

@end
