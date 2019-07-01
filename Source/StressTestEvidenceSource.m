//
//  StressTestEvidenceSource.m
//  ControlPlaneX
//
//  Created by Dustin Rue on 9/21/12.
//
//

#import "StressTestEvidenceSource.h"

@implementation StressTestEvidenceSource


- (id)init
{
	if (!(self = [super init]))
		return nil;
    
	return self;
}

- (NSString *) description {
    return NSLocalizedString(@"Enable this evidence source to cause ControlPlaneX to assume a large number of evidence source changes are occuring.", @"");
}


- (void)start
{
	if (self.running)
		return;
    
    [self setLoopTimer:[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)0.001
                                                        target:self
                                                      selector:@selector(wtf:)
                                                      userInfo:nil
                                                       repeats:YES]];
	self.running = YES;
}

- (void) wtf:(NSTimer *) timer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"evidenceSourceDataDidChange"
                                                                object:nil];
                                                      
}

- (void)stop
{
	if (!self.running)
		return;
    
    [[self loopTimer] invalidate];
    [self setLoopTimer:nil];
	self.running = NO;
}

- (NSString *)name
{
	return @"StressTest";
}

- (BOOL)doesRuleMatch:(NSDictionary *)rule {
    return NO;
}

- (NSString *)getSuggestionLeadText:(NSString *)type
{
	return NSLocalizedString(@"Just a stress test, you can't create rules", @"In rule-adding dialog");
}

- (NSArray *)getSuggestions {    
    return [NSArray array];
}

- (NSString *) friendlyName {
    return NSLocalizedString(@"Do Update Stress Test", @"");
}

@end
