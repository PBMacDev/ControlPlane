//
//  EvidenceSource.m
//  ControlPlaneX
//
//  Created by David Symonds on 29/03/07.
//  Modified by Dustin Rue on 8/5/2011.
//

#import "DSLogger.h"
#import "EvidenceSource.h"
#import "PrefsWindowController.h"


@implementation EvidenceSource

- (id)init {
    
    if ([[self class] isEqualTo:[EvidenceSource class]]) {
        [NSException raise:@"Abstract Class Exception"
                    format:@"Error, attempting to instantiate EvidenceSource directly."];
    }
    
    if (!(self = [super init]))
        return nil;
    
    _running = NO;
    self.panel = nil;
    
    return self;
}

+ (NSPanel *)getPanelFromNibNamed:(NSString *)name instantiatedWithOwner:(id)owner {
    // load nib
    NSNib *nib = [[NSNib alloc] initWithNibNamed:name bundle:nil];
    if (!nib) {
        NSLog(@"%@ >> failed loading nib named '%@'!", [self class], name);
        return nil;
    }

    NSArray *topLevelObjects = nil;
    if (![nib instantiateWithOwner:owner topLevelObjects:&topLevelObjects]) {
        NSLog(@"%@ >> failed instantiating nib (named '%@')!", [self class], name);
        return nil;
    }
    
    // Look for an NSPanel
    for (NSObject *obj in topLevelObjects) {
        if ([obj isKindOfClass:[NSPanel class]]) {
            return (NSPanel *) obj;
        }
    }

    NSLog(@"%@ >> failed to find an NSPanel in nib named '%@'!", [self class], name);
    return nil;
}

- (id)initWithNibNamed:(NSString *)name {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.panel = [[self class] getPanelFromNibNamed:name instantiatedWithOwner:self];
    if (!self.panel) {
        return nil;
    }

    return self;
}

- (NSString *)description {
    return NSLocalizedString(@"No description provided", @"");
}

- (BOOL)matchesRulesOfType:(NSString *)type {
    return [[self typesOfRulesMatched] containsObject:type];
}

#pragma mark -
#pragma mark Sheet hooks

- (void)setContextMenu:(NSMenu *)menu
{
    [self.ruleContext setMenu:menu];
}

- (IBAction)closeSheetWithOK:(id)sender
{
    [NSApp endSheet:self.panel returnCode:NSModalResponseOK];
}

- (IBAction)closeSheetWithCancel:(id)sender
{
    [NSApp endSheet:self.panel returnCode:NSModalResponseCancel];
}

- (NSMutableDictionary *)readFromPanel
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        [[self.ruleContext selectedItem] representedObject], @"context",
        [NSNumber numberWithDouble:[self.ruleConfidenceSlider doubleValue]], @"confidence",
        [[self typesOfRulesMatched] objectAtIndex:0], @"type",
        [NSNumber numberWithInteger:[self.negateRule state]], @"negate",
        nil];

    return dict;
}

- (void)writeToPanel:(NSDictionary *)dict usingType:(NSString *)type
{
    if ([dict objectForKey:@"context"]) {
        // Set up context selector
        NSInteger index = [self.ruleContext indexOfItemWithRepresentedObject:[dict valueForKey:@"context"]];
        [self.ruleContext selectItemAtIndex:index];
    }

    if ([dict objectForKey:@"confidence"]) {
        // Set up confidence slider
        [self.ruleConfidenceSlider setDoubleValue:[[dict valueForKey:@"confidence"] doubleValue]];
    }

    if ([dict objectForKey:@"negate"]) {
        [self.negateRule setState:[[dict valueForKey:@"negate"] integerValue]];
    }
}


#pragma mark -


- (NSArray *)myRules {
    if (!rulesThatBelongToThisEvidenceSource) {
        rulesThatBelongToThisEvidenceSource = [[NSMutableArray alloc] init];
    }
    
    // clear out existing rules if they exist
    if ([rulesThatBelongToThisEvidenceSource count] > 0)
        [rulesThatBelongToThisEvidenceSource removeAllObjects];

    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    [tmp addObjectsFromArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"Rules"]];
    
    NSDictionary *currentRule;

    for (NSUInteger i = 0; i < [tmp count]; i++) {
        currentRule = [tmp objectAtIndex:i];
        NSString *currentType = [[NSString alloc] initWithString:[currentRule valueForKey:@"type"]];
        
        if ([currentType isEqualToString:[[self typesOfRulesMatched] objectAtIndex:0]]) {
            [rulesThatBelongToThisEvidenceSource addObject:currentRule];
        }

    }

    return rulesThatBelongToThisEvidenceSource;
}

- (void)start {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)stop {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSString *)name {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSArray *)typesOfRulesMatched {
    return [NSArray arrayWithObject:[self name]];
}

- (BOOL)doesRuleMatch:(NSMutableDictionary *)rule {
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (NSString *) friendlyName {
    return @"Not implemented";
}

- (NSString *)enablementKeyName {
    NSMutableString *key = [NSMutableString stringWithString:@"Enable"];
    [key appendString:[self name]];
    [key appendString:@"EvidenceSource"];
    return [NSString stringWithString:key];
}

// if the evidence source doesn't override this we assume
// it is always true, thus the evidence source will be available
+ (BOOL) isEvidenceSourceApplicableToSystem {
    return true;
}

@end

#pragma mark -

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

@implementation EvidenceSourceSetController {
    NSCache *enabledSourcesForRuleTypes;
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }

    NSMutableArray *classes = [NSMutableArray arrayWithObjects:
#ifdef DEBUG_MODE
                        [StressTestEvidenceSource class],
#endif
                        [ActiveApplicationEvidenceSource class],
                        [ContextEvidenceSource class],
                        [AttachedPowerAdapterEvidenceSource class],
                        [NetworkLinkEvidenceSource class],
                        [IPAddrEvidenceSource class],
                        [FireWireEvidenceSource class],
                        [MonitorEvidenceSource class],
                        [USBEvidenceSource class],
                        [AudioOutputEvidenceSource class],
                        //[HostAvailabilityEvidenceSource class],
                        [BluetoothEvidenceSource class],
                        [BonjourEvidenceSource class],    
                        [CoreLocationSource class],
                        [DNSEvidenceSource class],
                        [LaptopLidEvidenceSource class],
                        [LightEvidenceSource class],
                        [MountedVolumeEvidenceSource class],
                        [WiFiEvidenceSourceCoreWLAN class],
                        [PowerEvidenceSource class],
                        [RemoteDesktopEvidenceSource class],
                        [RunningApplicationEvidenceSource class],
                        [ScreenLockEvidenceSource class],
                        [ShellScriptEvidenceSource class],
//                        [SleepEvidenceSource class],
                        [TimeOfDayEvidenceSource class],
                        nil];
    
    if (NO) {
        // Purely for the benefit of 'genstrings'
        NSLocalizedString(@"AttachedPowerAdapter", @"Evidence source");
        NSLocalizedString(@"AudioOutput", @"Evidence source");
        NSLocalizedString(@"Bluetooth", @"Evidence source");
        NSLocalizedString(@"Bonjour", @"Evidence source");
        NSLocalizedString(@"CoreLocation", @"Evidence source");
        NSLocalizedString(@"Context", @"Evidence Source");
        NSLocalizedString(@"FireWire", @"Evidence source");
        NSLocalizedString(@"DNS", @"Evidence source");
        NSLocalizedString(@"IPAddr", @"Evidence source");
        NSLocalizedString(@"Light", @"Evidence source");
        NSLocalizedString(@"Monitor", @"Evidence source");
        NSLocalizedString(@"NetworkLink", @"Evidence source");
        NSLocalizedString(@"Power", @"Evidence source");
        NSLocalizedString(@"RemoteDesktop", @"Evidence source");
        NSLocalizedString(@"RunningApplication", @"Evidence source");
        NSLocalizedString(@"ScreenLock", @"Evidence source");
        NSLocalizedString(@"Shell Script", @"Evidence source");
        NSLocalizedString(@"Sleep/Wake", @"Evidence source");
        NSLocalizedString(@"TimeOfDay", @"Evidence source");
        NSLocalizedString(@"USB", @"Evidence source");
        NSLocalizedString(@"WiFi using CoreWLAN", @"Evidence source");
    }

    // Instantiate all the evidence sources if they are supported on this device
    NSMutableArray *srcList = [[NSMutableArray alloc] initWithCapacity:[classes count]];
    for (Class class in classes) {
        if ([class isEvidenceSourceApplicableToSystem]) {
            @autoreleasepool {
                EvidenceSource *src = [[class alloc] init];
                if (!src) {
                    DSLog(@"%@ failed to init properly", class);
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

- (void)dealloc {
    [self stopAllRunningEvidenceSources];
}

- (void)startEvidenceSource:(EvidenceSource *)src {
    if (![src isRunning]) {
        DSLog(@"Starting %@ evidence source", [src name]);
        [src start];

        [enabledSourcesForRuleTypes removeAllObjects]; // reset cache
    }
}

- (void)stopEvidenceSource:(EvidenceSource *)src {
    if ([src isRunning]) {
        DSLog(@"Stopping %@ evidence source", [src name]);
        [src stop];

        [enabledSourcesForRuleTypes removeAllObjects]; // reset cache
    }
}

- (void)startEnabledEvidenceSources {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    for (EvidenceSource *src in sources) {
        if ([standardUserDefaults boolForKey:[src enablementKeyName]]) { // if enabled
            [self startEvidenceSource:src];
        }
    }
}

- (void)stopAllRunningEvidenceSources {
    for (EvidenceSource *src in sources) {
        if ([src isRunning]) { // if enabled
            [self stopEvidenceSource:src];
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
            [self startEvidenceSource:src];
        } else {
            [self stopEvidenceSource:src];
        }
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
