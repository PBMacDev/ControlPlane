//
//  PreventSystemSleepAction.m
//  ControlPlaneX
//
//  Created by Dustin Rue on 6/19/14.
//
//

#import "PreventSystemSleepAction.h"
#import <IOKit/pwr_mgt/IOPMLib.h>

static IOPMAssertionID preventSystemSleepActionAssertionID = 0;

@implementation PreventSystemSleepAction

- (NSString *) description {
	if (turnOn)
		return NSLocalizedString(@"Preventing system sleep.", @"");
	else
		return NSLocalizedString(@"Allowing system sleep.", @"");
}

- (BOOL) execute: (NSString **) errorString {
    IOReturn ioReturn = kIOReturnSuccess;
    // kIOPMAssertionTypeNoDisplaySleep prevents display sleep,
    // kIOPMAssertionTypeNoIdleSleep prevents idle sleep
    
    if (turnOn && (preventSystemSleepActionAssertionID == 0)) {
        
        //  NOTE: IOPMAssertionCreateWithName limits the string to 128 characters.
        ioReturn = IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleSystemSleep,
                                              kIOPMAssertionLevelOn, CFSTR("ControlPlaneX is preventing system sleep"), &preventSystemSleepActionAssertionID);
    }
    else if (!turnOn && (preventSystemSleepActionAssertionID != 0)) {
        ioReturn = IOPMAssertionRelease(preventSystemSleepActionAssertionID);
        if (ioReturn == kIOReturnSuccess) {
            preventSystemSleepActionAssertionID = 0;
        }
    }
	
	
	// result
	if (ioReturn != kIOReturnSuccess) {
		*errorString = @"Unable to enable/disable system sleep.";
		return NO;
	} else
		return YES;
}

+ (NSString *) helpText {
	return NSLocalizedString(@"The parameter for Prevent System Sleep action is either \"1\" to prevent "
                             "system sleep or \"0\" to allow system sleep.", @"");
}

+ (NSString *) creationHelpText {
	return NSLocalizedString(@"Toggle prevention of system sleep", @"");
}

+ (NSArray *) limitedOptions {
	return [NSArray arrayWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"option",
             NSLocalizedString(@"Allow System Sleep", @""), @"description", nil],
            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"option",
             NSLocalizedString(@"Disallow System Sleep", @""), @"description", nil],
            nil];
}



+ (NSString *) friendlyName {
    return NSLocalizedString(@"Prevent System Sleep", @"");
}

+ (NSString *)menuCategory {
    return NSLocalizedString(@"System Preferences", @"");
}

@end
