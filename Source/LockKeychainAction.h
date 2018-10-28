//
//	LockKeychainAction.h
//	ControlPlaneX
//
//	Created by David Jennes on 02/09/11.
//	Copyright 2011. All rights reserved.
//

#import "ToggleableAction.h"

@interface LockKeychainAction : ToggleableAction

- (NSString *) description;
- (BOOL) execute: (NSString **) errorString;
+ (NSString *) helpText;
+ (NSString *) creationHelpText;
+ (NSArray *) limitedOptions;

@end
