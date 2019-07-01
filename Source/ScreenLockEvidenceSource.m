//
//  ScreenLockEvidenceSource.m
//  ControlPlaneX
//
//  Created by Roman Shevtsov on 12/12/15.
//
//

#import "DSLogger.h"
#import "ScreenLockEvidenceSource.h"

@implementation ScreenLockEvidenceSource

@synthesize screenIsLocked;

- (id) init {
    if (!(self = [super init]))
        return nil;

    screenIsLocked = NO;

    // Monitor screen lock status
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(screenDidUnlock:)
                                                            name:@"com.apple.screenIsUnlocked"
                                                          object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(screenDidLock:)
                                                            name:@"com.apple.screenIsLocked"
                                                          object:nil];

    return self;
}

- (NSString *) description {
    return NSLocalizedString(@"Create rules that are true when the system screen is locked or unlocked.", @"");
}

- (void) doRealUpdate {
//    [self setDataCollected:YES];
}

- (NSString*) name {
    return @"ScreenLock";
}

- (BOOL) doesRuleMatch: (NSDictionary*) rule {
    NSString *param = [rule objectForKey:@"parameter"];
    
    return (([param isEqualToString: @"lock"] && screenIsLocked) ||
            ([param isEqualToString: @"unlock"] && !screenIsLocked));
}

- (NSString*) getSuggestionLeadText: (NSString*) type {
    return NSLocalizedString(@"Screen lock is", @"In rule-adding dialog");
}

- (NSArray*) getSuggestions {
    return [NSArray arrayWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"ScreenLock", @"type", @"lock", @"parameter",
             NSLocalizedString(@"Locked", @""), @"description", nil],
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"ScreenLock", @"type", @"unlock", @"parameter",
             NSLocalizedString(@"Unlocked", @""), @"description", nil],
            nil];
}

- (void) start {
    if (self.running)
        return;
    
    [self doRealUpdate];
    
    self.running = YES;
}

- (void) stop {
    if (!self.running)
        return;
    
    self.running = NO;
}

- (NSString *) friendlyName {
    return NSLocalizedString(@"Screen Lock/Unlock", @"");
}

- (void) screenDidUnlock:(NSNotification *)notification {
    #ifdef DEBUG_MODE
        DSLog(@"screenDidUnlock: %@", [notification name]);
    #endif

    [self setScreenIsLocked:NO];
    [self doRealUpdate];
}

- (void) screenDidLock:(NSNotification *)notification {
    #ifdef DEBUG_MODE
        DSLog(@"screenDidLock: %@", [notification name]);
    #endif

    [self setScreenIsLocked:YES];
    [self doRealUpdate];
}

@end
