//
//  ScreenLockEvidenceSource.h
//  ControlPlaneX
//
//  Created by Roman Shevtsov on 12/12/15.
//
//

#import "GenericEvidenceSource.h"

@interface ScreenLockEvidenceSource : GenericEvidenceSource

@property (readwrite) BOOL screenIsLocked;

- (id) init;

- (void) doRealUpdate;

- (void) start;
- (void) stop;

- (NSString*) name;
- (BOOL) doesRuleMatch: (NSDictionary*) rule;
- (NSString*) getSuggestionLeadText: (NSString*) type;
- (NSArray*) getSuggestions;

- (void) screenDidUnlock:(NSNotification *)notification;
- (void) screenDidLock:(NSNotification *)notification;


@end
