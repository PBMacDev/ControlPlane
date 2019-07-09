/* PrefsWindowController */

#import <Cocoa/Cocoa.h>
#import "CPController.h"
#import "EvidenceSource.h"
#import "EvidenceSourceSetController.h"


@interface PrefsWindowController : NSWindowController<NSToolbarDelegate>
{
	IBOutlet NSWindow *prefsWindow;
	IBOutlet NSView *generalPrefsView, *contextsPrefsView, *evidenceSourcesPrefsView,
			*rulesPrefsView, *actionsPrefsView, *advancedPrefsView;
	NSString *currentPrefsGroup;
	NSView *currentPrefsView;
	NSArray *prefsGroups;
	NSToolbar *prefsToolbar;

	IBOutlet EvidenceSourceSetController *evidenceSources;
	IBOutlet ContextsDataSource *contextsDataSource;
    IBOutlet NSArrayController *rulesController;
	IBOutlet NSArrayController *whenActionController;
    IBOutlet NSArrayController *menuBarDisplayOptionsController;

    IBOutlet NSButton *startAtLoginStatus;
	IBOutlet NSTextView *logBufferView;
	NSNumber *logBufferPaused;
	NSTimer *logBufferTimer;
    NSMenuItem *donateToControlPlaneX;
    
    IBOutlet NSPopUpButton *defaultContextPopUpButton;
    IBOutlet NSPopUpButton *editActionContextButton;
    
    IBOutlet NSSegmentedControl* addNewRuleButton;
}

- (IBAction)runPreferences:(id)sender;
- (IBAction)menuBarDisplayOptionChanged:(id)sender;

- (void)switchToViewFromToolbar:(NSToolbarItem *)item;
- (void)switchToView:(NSString *)identifier;

// NSToolbar delegates
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)groupId willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar;

- (void)addRule:(id)sender;
- (IBAction)editRule:(id)sender;

// Login item stuff
- (IBAction)toggleStartAtLoginAction:(id)sender;



@end
