//
//  ActiveApplicationEvidenceSource.m
//  ControlPlaneX
//
//  Created by Dustin Rue on 8/13/12.
//
//

#import "ActiveApplicationEvidenceSource.h"
#import "DSLogger.h"

static void *ActiveApplicationEvidenceSourceContext = &ActiveApplicationEvidenceSourceContext;

@implementation ActiveApplicationEvidenceSource

@synthesize activeApplication;

- (id)init
{
	if (!(self = [super init]))
		return nil;
    
    activeApplication = [[[NSWorkspace sharedWorkspace] frontmostApplication] bundleIdentifier];
//    [self setDataCollected:YES];

	return self;
}

- (void)dealloc
{
    [self stop];
}

- (NSString *) description {
    return NSLocalizedString(@"Allows you to define rules based on the active or foreground application.", @"");
}

- (void)start {
    
	if (self.running) {
		return;
    }
    
    NSWorkspace* sharedWS = [NSWorkspace sharedWorkspace];
    [sharedWS addObserver:self forKeyPath:@"frontmostApplication" options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionInitial) context:ActiveApplicationEvidenceSourceContext];
    
	self.running = YES;
}

- (void)stop {
    
	if (!self.running) {
		return;
    }

    NSWorkspace* sharedWS = [NSWorkspace sharedWorkspace];
    [sharedWS removeObserver:self forKeyPath:@"frontmostApplication" context:ActiveApplicationEvidenceSourceContext];
    
	self.running = NO;
}

- (NSString *)name
{
	return @"ActiveApplication";
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (context == ActiveApplicationEvidenceSourceContext) {
        self.activeApplication = [[[NSWorkspace sharedWorkspace] frontmostApplication] bundleIdentifier];
    } else {
        // Any unrecognized context must belong to super
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (BOOL)doesRuleMatch:(NSDictionary *)rule
{
    BOOL match = NO;
    @synchronized(self) {
        NSString *param = [rule valueForKey:@"parameter"];
        match = NO;
       
        if ([[self activeApplication] isEqualToString:param]) {
            match = YES;
        }
    }
	return match;
}

- (NSString *)getSuggestionLeadText:(NSString *)type
{
	return NSLocalizedString(@"The following application is active", @"In rule-adding dialog");
}

- (NSArray *)getSuggestions
{
    NSArray *runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
    
	NSMutableArray *suggestions = [[NSMutableArray alloc] initWithCapacity:[runningApps count]];
    [runningApps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *identifier = [obj bundleIdentifier];
        NSString *name = [obj localizedName];
        if ((identifier != nil) && ([identifier length] > 0) && (name != nil)) {
            [suggestions addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ActiveApplication", @"type", identifier, @"parameter", [NSString stringWithFormat:@"%@ (%@)", name, identifier], @"description", nil]];
        }
    }];
    
    return suggestions;
}

- (NSString *) friendlyName {
    return NSLocalizedString(@"Active Application", @"");
}

@end
