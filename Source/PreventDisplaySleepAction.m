//
//  PreventDisplaySleepAction.m
//  ControlPlaneX
//
//  Created by Dustin Rue on 2/7/13.
//
//

#import "PreventDisplaySleepAction.h"
#import <IOKit/pwr_mgt/IOPMLib.h>

static IOPMAssertionID preventDisplaySleepActionAssertionID = 0;

@implementation PreventDisplaySleepAction


- (NSString *) description {
	if (turnOn)
		return NSLocalizedString(@"Preventing display sleep.", @"");
	else
		return NSLocalizedString(@"Allowing display sleep.", @"");
}

- (BOOL) execute: (NSString **) errorString {
    IOReturn ioReturn = kIOReturnSuccess;
    // kIOPMAssertionTypeNoDisplaySleep prevents display sleep,
    // kIOPMAssertionTypeNoIdleSleep prevents idle sleep

    if (turnOn && (preventDisplaySleepActionAssertionID == 0)) {
        //  NOTE: IOPMAssertionCreateWithName limits the string to 128 characters.
        ioReturn = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep,
                                                       kIOPMAssertionLevelOn, CFSTR("ControlPlaneX is preventing display sleep"), &preventDisplaySleepActionAssertionID);
        
    }
    else if (!turnOn && (preventDisplaySleepActionAssertionID != 0)) {
        ioReturn = IOPMAssertionRelease(preventDisplaySleepActionAssertionID);
        if (ioReturn == kIOReturnSuccess) {
            preventDisplaySleepActionAssertionID = 0;
        }
    }
	
	
	// result
	if (ioReturn != kIOReturnSuccess) {
		*errorString = @"Unable to enable/disable display sleep.";
		return NO;
	} else
		return YES;
}

+ (NSString *) helpText {
	return NSLocalizedString(@"The parameter for Prevent Display Sleep action is either \"1\" to prevent "
                             "display sleep or \"0\" to allow display sleep.", @"");
}

+ (NSString *) creationHelpText {
	return NSLocalizedString(@"Toggle prevention of display sleep", @"");
}

+ (NSArray *) limitedOptions {
	return [NSArray arrayWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"option",
             NSLocalizedString(@"Allow Display Sleep", @""), @"description", nil],
            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"option",
             NSLocalizedString(@"Disallow Display Sleep", @""), @"description", nil],
            nil];
}



+ (NSString *) friendlyName {
    return NSLocalizedString(@"Prevent Display Sleep", @"");
}

+ (NSString *)menuCategory {
    return NSLocalizedString(@"System Preferences", @"");
}

@end
