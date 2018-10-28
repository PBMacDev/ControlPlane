//
//  RunningApplicationEvidenceSource.h
//  ControlPlaneX
//
//  Created by David Symonds on 23/5/07.
//

#import "GenericEvidenceSource.h"


@interface RunningApplicationEvidenceSource : GenericEvidenceSource {
	NSMutableArray *applications;
}

- (id)init;

- (void)start;
- (void)stop;

- (NSString *)name;
- (BOOL)doesRuleMatch:(NSDictionary *)rule;
- (NSString *)getSuggestionLeadText:(NSString *)type;
- (NSArray *)getSuggestions;

@end
