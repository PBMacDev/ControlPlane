//
//  Action.m
//  ControlPlaneX
//
//  Created by David Symonds on 3/04/07.
//

#import "Action.h"
#import "DSLogger.h"

@implementation Action

+ (NSString *)typeForClass:(Class)klass
{
    // Hack "Action" off class name (6 chars)
    // TODO: make this a bit more robust?
    NSString *className = NSStringFromClass(klass);
    return [className substringToIndex:([className length] - 6)];
}

+ (Class)classForType:(NSString *)type
{
    NSString *classString = [NSString stringWithFormat:@"%@Action", type];
    Class klass = NSClassFromString(classString);
    if (!klass) {
        NSLog(@"ERROR: No implementation class '%@'!", classString);
        return nil;
    }
    return klass;
}

+ (Action *)actionFromDictionary:(NSDictionary *)dict
{
    NSString *type = [dict valueForKey:@"type"];
    if (!type) {
        NSLog(@"ERROR: Action doesn't have a type!");
        return nil;
    }
    Action *obj = [[[Action classForType:type] alloc] initWithDictionary:dict];
    return obj;
}

- (id)init
{
    if ([[self class] isEqualTo:[Action class]]) {
        [NSException raise:@"Abstract Class Exception"
                format:@"Error, attempting to instantiate Action directly."];
    }

    if (!(self = [super init]))
        return nil;
    
    // Some sensible defaults
    type = [Action typeForClass:[self class]];
    context = @"";
    when = @"Arrival";
    delay = [[NSNumber alloc] initWithDouble:0];
    enabled = [[NSNumber alloc] initWithBool:YES];
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    if ([[self class] isEqualTo:[Action class]]) {
        [NSException raise:@"Abstract Class Exception"
                format:@"Error, attempting to instantiate Action directly."];
    }

    if (!(self = [super init]))
        return nil;

    type = [Action typeForClass:[self class]];
    context = [[dict valueForKey:@"context"] copy];
    when = [[dict valueForKey:@"when"] copy];
    delay = [[dict valueForKey:@"delay"] copy];
    enabled = [[dict valueForKey:@"enabled"] copy];

    return self;
}


- (NSMutableDictionary *)dictionary
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
        [type copy], @"type",
        [context copy], @"context",
        [when copy], @"when",
        [delay copy], @"delay",
        [enabled copy], @"enabled",
        nil];
}

+ (NSString *)helpTextForActionOfType:(NSString *)type
{
    return [[Action classForType:type] helpText];
}

- (NSComparisonResult)compareDelay:(Action *)other
{
    return [[self valueForKey:@"delay"] compare:[other valueForKey:@"delay"]];
}

- (void)notImplemented:(NSString *)methodName
{
    [NSException raise:@"Abstract Class Exception"
            format:@"Error, -[%@ %@] not implemented.",
                [self class], methodName];
}

- (NSString *)description
{
    [self notImplemented:@"description"];
    return @"Not implemented!";
}

- (BOOL)execute:(NSString **)errorString
{
    [self notImplemented:@"execute"];
    *errorString = @"Not implemented!";
    return NO;
}

+ (NSString *)helpText
{
    return @"Sorry, no help text written yet!";
}

+ (NSString *)creationHelpText
{
    return @"<Sorry, help text coming soon!>";
}

+ (NSString *)friendlyName {
    return @"Not implemented";
}

+ (BOOL) shouldWaitForScreensaverExit {
    return NO;
}

+ (BOOL) shouldWaitForScreenUnlock {
    return NO;
}

+ (BOOL) isActionApplicableToSystem {
    return YES;
}

+ (NSString *)menuCategory {
    return @"";
}

- (void)executeAppleScriptForReal:(NSString *)script
{
    appleScriptResult_ = nil;
    
    NSAppleScript *as = [[NSAppleScript alloc] initWithSource:script];
    if (!as) {
        NSLog(@"AppleScript failed to construct! Script was:\n%@", script);
        return;
    }
    NSDictionary *errorDict;
    if (![as compileAndReturnError:&errorDict]) {
        NSLog(@"AppleScript failed to compile! Script was:\n%@\nError dictionary: %@", script, errorDict);
        return;
    }
    appleScriptResult_ = [as executeAndReturnError:&errorDict];
    if (!appleScriptResult_)
        NSLog(@"AppleScript failed to execute! Script was:\n%@\nError dictionary: %@", script, errorDict);
}

- (BOOL)executeAppleScript:(NSString *)script
{
    // NSAppleScript is not thread-safe, so this needs to happen on the main thread. Ick.
    [self performSelectorOnMainThread:@selector(executeAppleScriptForReal:)
                           withObject:script
                        waitUntilDone:YES];
    return (appleScriptResult_ ? YES : NO);
}

- (NSArray *)executeAppleScriptReturningListOfStrings:(NSString *)script
{
    if (![self executeAppleScript:script])
        return nil;
    if ([appleScriptResult_ descriptorType] != typeAEList)
        return nil;
    
    long count = [appleScriptResult_ numberOfItems], i;
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:count];
    for (i = 1; i <= count; ++i) {        // Careful -- AppleScript lists are 1-based
        NSAppleEventDescriptor *elt = [appleScriptResult_ descriptorAtIndex:i];
        if (!elt) {
            NSLog(@"Oops -- couldn't get descriptor at index %ld", i);
            continue;
        }
        NSString *val = [elt stringValue];
        if (!val) {
            NSLog(@"Oops -- couldn't turn descriptor at index %ld into string", i);
            continue;
        }
        [list addObject:val];
    }
    
    return list;
}

- (void) handleURL:(NSString *)url {
    NSLog(@"Not implemented");
}

@end
