//
//  EvidenceSourceSetController.m
//  ControlPlaneX
//
//  Created by Pavlo Boyko on 7/3/19.
//

#import "EvidenceSource.h"
#import "PrefsWindowController.h"
#import "EvidenceSourceSetController.h"

#import "ActiveApplicationEvidenceSource.h"
#import "AttachedPowerAdapterEvidenceSource.h"
#import "AudioOutputEvidenceSource.h"
#import "BluetoothEvidenceSource.h"
#import "BonjourEvidenceSource.h"
#import "ContextEvidenceSource.h"
#import "DNSEvidenceSource.h"
#import "FireWireEvidenceSource.h"
//#import "HostAvailabilityEvidenceSource.h"
#import "IPAddrEvidenceSource.h"
#import "LaptopLidEvidenceSource.h"
#import "LightEvidenceSource.h"
#import "LaptopLidEvidenceSource.h"
#import "MonitorEvidenceSource.h"
#import "MountedVolumeEvidenceSource.h"
#import "NetworkLinkEvidenceSource.h"
#import "PowerEvidenceSource.h"
#import "RunningApplicationEvidenceSource.h"
#import "TimeOfDayEvidenceSource.h"
#import "USBEvidenceSource.h"
#import "CoreWLANEvidenceSource.h"
#import "ScreenLockEvidenceSource.h"
#import "ShellScriptEvidenceSource.h"
//#import "SleepEvidenceSource.h"
#import "CoreLocationSource.h"
#import "HostAvailabilityEvidenceSource.h"
#import "RemoteDesktopEvidenceSource.h"

#ifdef DEBUG_MODE
#import "StressTestEvidenceSource.h"
#endif

@interface EvidenceSourceSetController (Private)

// NSMenu delegates (for adding rules)
- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel;
- (BOOL)menuHasKeyEquivalent:(NSMenu *)menu forEvent:(NSEvent *)event target:(id *)target action:(SEL *)action;
- (NSUInteger)numberOfItemsInMenu:(NSMenu *)menu;

// NSTableViewDataSource protocol methods
- (NSUInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;

@end

@implementation EvidenceSourceSetController {
    NSCache *enabledSourcesForRuleTypes;
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    NSMutableArray *classes = [NSMutableArray arrayWithObjects:
                               //#ifdef DEBUG_MODE
                               //                        [StressTestEvidenceSource class],
                               //#endif
                               [ActiveApplicationEvidenceSource class],
                               //                        [ContextEvidenceSource class],
                               //                        [AttachedPowerAdapterEvidenceSource class],
                               //                        [NetworkLinkEvidenceSource class],
                               //                        [IPAddrEvidenceSource class],
                               //                        [FireWireEvidenceSource class],
                               //                        [MonitorEvidenceSource class],
                               //                        [USBEvidenceSource class],
                               //                        [AudioOutputEvidenceSource class],
                               //[HostAvailabilityEvidenceSource class],
                               //                        [BluetoothEvidenceSource class],
                               //                        [BonjourEvidenceSource class],
                               [CoreLocationSource class],
                               //                        [DNSEvidenceSource class],
                               //                        [LaptopLidEvidenceSource class],
                               //                        [LightEvidenceSource class],
                               //                        [MountedVolumeEvidenceSource class],
                               [WiFiEvidenceSourceCoreWLAN class],
                               //                        [PowerEvidenceSource class],
                               //                        [RemoteDesktopEvidenceSource class],
                               //                        [RunningApplicationEvidenceSource class],
                               //                        [ScreenLockEvidenceSource class],
                               //                        [ShellScriptEvidenceSource class],
                               //                        [TimeOfDayEvidenceSource class],
                               nil];
    
    // Instantiate all the evidence sources if they are supported on this device
    NSMutableArray *srcList = [[NSMutableArray alloc] initWithCapacity:[classes count]];
    for (Class class in classes) {
        if ([class isEvidenceSourceApplicableToSystem]) {
            @autoreleasepool {
                EvidenceSource *src = [[class alloc] init];
                if (!src) {
                    continue;
                }
                [srcList addObject:src];
            }
        }
    }
    
    sources = srcList;
    enabledSourcesForRuleTypes = [[NSCache alloc] init];
    
    return self;
}

- (void)startEnabledEvidenceSources {
    [enabledSourcesForRuleTypes removeAllObjects]; // reset cache
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    for (EvidenceSource *src in sources) {
        if ([standardUserDefaults boolForKey:[src enablementKeyName]]) { // if enabled
            [src start];
        }
    }
}

- (void)stopAllRunningEvidenceSources {
    for (EvidenceSource *src in sources) {
        if ([src isRunning]) { // if enabled
            [src stop];
        }
    }
}

- (NSIndexSet *)indexesOfEnabledSourcesForRuleType:(NSString *)ruleType {
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [sources enumerateObjectsUsingBlock:^(EvidenceSource *src, NSUInteger idx, BOOL *stop) {
        if ([src matchesRulesOfType:ruleType]) {
            if ([standardUserDefaults boolForKey:[src enablementKeyName]]) { // if enabled
                [indexes addIndex:idx];
            }
        }
    }];
    
    return indexes;
}

- (RuleMatchStatusType)ruleMatches:(NSMutableDictionary *)rule {
    NSString *ruleType = rule[@"type"];
    
    NSIndexSet *sourceIndexes = [enabledSourcesForRuleTypes objectForKey:ruleType];
    if (!sourceIndexes) {
        sourceIndexes = [self indexesOfEnabledSourcesForRuleType:ruleType];
        [enabledSourcesForRuleTypes setObject:sourceIndexes forKey:ruleType];
    }
    
    __block RuleMatchStatusType result = RuleMatchStatusIsUnknown;
    [sources enumerateObjectsAtIndexes:sourceIndexes options:0
                            usingBlock:^(EvidenceSource *src, NSUInteger idx, BOOL *stop) {
                                if ([src isRunning]) {
                                    if ([src doesRuleMatch:rule]) {
                                        result = RuleDoesMatch;
                                        *stop = YES;
                                        return;
                                    }
                                    
                                    result = RuleDoesNotMatch;
                                }
                            }];
    
    return result;
}

- (NSEnumerator *)sourceEnumerator {
    return [sources objectEnumerator];
}

#pragma mark NSMenu delegates

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel {
    EvidenceSource *src = sources[index];
    NSString *friendlyName = [src friendlyName];
    [item setTitle:[NSString stringWithFormat:NSLocalizedString(@"Add '%@' Rule...", @"Menu item"),
                    friendlyName]];
    
    NSArray *typesOfRulesMatched = [src typesOfRulesMatched];
    if ([typesOfRulesMatched count] > 1) {
        NSMenu *submenu = [[NSMenu alloc] init];
        for (NSString *type in typesOfRulesMatched) {
            NSMenuItem *it = [[NSMenuItem alloc] init];
            [it setTitle:NSLocalizedString(type, @"Rule type")];
            [it setTarget:prefsWindowController];
            [it setAction:@selector(addRule:)];
            [it setRepresentedObject:@[src, type]];
            [submenu addItem:it];
        }
        [item setSubmenu:submenu];
    } else {
        [item setTarget:prefsWindowController];
        [item setAction:@selector(addRule:)];
        [item setRepresentedObject:src];
    }
    
    [item setHidden:![src isRunning]];
    
    return YES;
}

- (BOOL)menuHasKeyEquivalent:(NSMenu *)menu forEvent:(NSEvent *)event target:(id *)target action:(SEL *)action {
    // TODO: support keyboard menu jumping?
    return NO;
}

// we're being asked how many items should be in the add new rule menu
// we build a list of the running evidence sources which will be used in
// the '- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel'
// call which is next
- (NSUInteger)numberOfItemsInMenu:(NSMenu *)menu {
    return [sources count];
}

#pragma mark NSTableViewDataSource protocol methods

- (NSUInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [sources count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
    EvidenceSource *src = sources[rowIndex];
    NSString *friendlyName = [src friendlyName];
    NSString *col_id = [aTableColumn identifier];
    
    if ([@"enabled" isEqualToString:col_id]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:[src enablementKeyName]];
    } else if ([@"name" isEqualToString:col_id]) {
        return NSLocalizedString(friendlyName, @"Evidence source");
    }
    
    // Shouldn't get here!
    return nil;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
    
    NSString *col_id = [aTableColumn identifier];
    
    if ([@"enabled" isEqualToString:col_id]) {
        EvidenceSource *src = sources[rowIndex];
        if ([anObject boolValue]) {
            if (![src isRunning]) {
                [src start];
            }
        } else {
            if ([src isRunning]) {
                [src stop];
            }
        }
        [enabledSourcesForRuleTypes removeAllObjects]; // reset cache
        
        [[NSUserDefaults standardUserDefaults] setValue:anObject forKey:[src enablementKeyName]];
        return;
    }
    
    // Shouldn't get here!
}

- (NSString *)tableView:(NSTableView *)aTableView toolTipForCell:(NSCell *)aCell rect:(NSRectPointer)rect
            tableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation {
    
    NSString *col_id = [aTableColumn identifier];
    
    if ([@"name" isEqualToString:col_id]) {
        return [sources[row] description];
    }
    
    return nil; // no tool tip available
}

@end
