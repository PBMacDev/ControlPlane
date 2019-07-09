//
//  EvidenceSourceSetController.h
//  ControlPlaneX
//
//  Created by Pavlo Boyko on 7/3/19.
//

#ifndef EvidenceSourceSetController_h
#define EvidenceSourceSetController_h

@interface EvidenceSourceSetController : NSObject {
    IBOutlet NSWindowController *prefsWindowController;
    NSArray *sources;    // dictionary of EvidenceSource descendants (key is its name)
}

- (void)startEnabledEvidenceSources;
- (void)stopAllRunningEvidenceSources;
- (RuleMatchStatusType)ruleMatches:(NSMutableDictionary *)rule;
- (NSEnumerator *)sourceEnumerator;

@end

#endif /* EvidenceSourceSetController_h */
