//
//  ActiveApplicationEvidenceSource.h
//  ControlPlaneX
//
//  Created by Dustin Rue on 8/13/12.
//
//

#import "GenericEvidenceSource.h"

@interface ActiveApplicationEvidenceSource : GenericEvidenceSource {
}

@property (retain) NSString *activeApplication;

- (void)start;
- (void)stop;

- (NSString *)name;
- (BOOL)doesRuleMatch:(NSDictionary *)rule;
- (NSString *)getSuggestionLeadText:(NSString *)type;
- (NSArray *)getSuggestions;

@end
