//
//  EvidenceSource.m
//  ControlPlaneX
//
//  Created by David Symonds on 29/03/07.
//  Modified by Dustin Rue on 8/5/2011.
//

#import "DSLogger.h"
#import "EvidenceSource.h"


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
