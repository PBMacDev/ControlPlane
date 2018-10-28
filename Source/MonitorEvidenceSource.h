//
//  MonitorEvidenceSource.h
//  ControlPlaneX
//
//  Created by David Symonds on 2/07/07.
//

#import "GenericLoopingEvidenceSource.h"


@interface MonitorEvidenceSource : GenericLoopingEvidenceSource {
	NSLock *lock;
	NSMutableArray *monitors;
}

- (id)init;

- (void)doUpdate;
- (void)clearCollectedData;

- (NSString *)name;
- (BOOL)doesRuleMatch:(NSDictionary *)rule;
- (NSString *)getSuggestionLeadText:(NSString *)type;
- (NSArray *)getSuggestions;

@end
