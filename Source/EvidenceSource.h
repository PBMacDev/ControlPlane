//
//  EvidenceSource.h
//  ControlPlaneX
//
//  Created by David Symonds on 29/03/07.
//

#import <Cocoa/Cocoa.h>
#import "ControlPlaneX-Swift.h"

typedef NS_ENUM(int, RuleMatchStatusType) {
    RuleMatchStatusIsUnknown = -1,
    RuleDoesNotMatch = 0,
    RuleDoesMatch = 1
};

@interface EvidenceSource : NSObject {
    NSMutableArray *rulesThatBelongToThisEvidenceSource;
}

@property (getter=isRunning) BOOL running;

// Sheet hooks
@property (weak) IBOutlet NSPopUpButton *ruleContext;
@property (weak) IBOutlet NSSlider *ruleConfidenceSlider;
@property (weak) IBOutlet NSButton *negateRule;
@property (strong, nonatomic) NSPanel *panel;

- (id)initWithNibNamed:(NSString *)name;

- (BOOL)matchesRulesOfType:(NSString *)type;

// Need to be extended by descendant classes
// (need to add handling of 'parameter', and optionally 'type' and 'description' keys)
// Some rules:
//    - parameter *must* be filled in
//    - description *must not* be filled in if [super readFromPanel] does it
//    - type *may* be filled in; it will default to the first "supported" rule type
- (NSMutableDictionary *)readFromPanel;
- (void)writeToPanel:(NSDictionary *)dict usingType:(NSString *)type;

// To be implemented by descendant classes:
- (void)start;
- (void)stop;

//- (void)startForRule:(Rule*)rule;

// To be implemented by descendant classes:
- (NSString*)name;
- (BOOL)doesRuleMatch:(NSMutableDictionary *)rule;

// Optionally implemented by descendant classes
- (NSArray*)typesOfRulesMatched;    // optional; default is [self name]

// Returns the rules that belong to the calling evidence source
- (NSArray*)myRules;

// Returns a friendly name to be used in the drop down menu
- (NSString*)friendlyName;
- (NSString *)enablementKeyName;

// Return true if the evidence source should be enabled for this model of Mac
+ (BOOL)isEvidenceSourceApplicableToSystem;

+ (NSPanel*)getPanelFromNibNamed:(NSString *)name instantiatedWithOwner:(id)owner;

- (void)setContextMenu:(NSMenu *)menu;
- (IBAction)closeSheetWithOK:(id)sender;
- (IBAction)closeSheetWithCancel:(id)sender;

@end
