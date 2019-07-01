//
//  MultiRuleEvidenceSource.h
//  ControlPlaneX
//
//  Created by Vladimir Beloborodov on 03/03/2013.
//

#import "EvidenceSource.h"

@interface MultiRuleEvidenceSource : EvidenceSource

- (id)init;
- (id)initWithNibNamed:(NSString *)name;

- (id)initWithRules:(NSArray *)ruleTypeClasses;

- (BOOL)matchesRulesOfType:(NSString *)type;
- (NSArray *)typesOfRulesMatched;

- (BOOL)doesRuleMatch:(NSMutableDictionary *)rule;

- (NSMutableDictionary *)readFromPanel;
- (void)setContextMenu:(NSMenu *)menu;
- (void)writeToPanel:(NSDictionary *)rule usingType:(NSString *)type;

@end
