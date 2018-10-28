//
//  NetworkLinkEvidenceSource.h
//  ControlPlaneX
//
//  Created by Mark Wallis on 25/7/07.
//

#import "GenericEvidenceSource.h"


@interface NetworkLinkEvidenceSource : GenericEvidenceSource

- (id)init;

- (void)doFullUpdate:(id)sender;

- (void)start;
- (void)stop;

- (NSString *)name;
- (BOOL)doesRuleMatch:(NSDictionary *)rule;
- (NSString *)getSuggestionLeadText:(NSString *)type;
- (NSArray *)getSuggestions;

@end
