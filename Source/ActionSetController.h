//
//  ActionSetController.h
//  ControlPlaneX
//
//  Created by Pavlo Boyko on 11/23/18.
//

#import <Cocoa/Cocoa.h>
#import "CPController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActionSetController : NSObject <NSMenuDelegate> {

    NSMutableArray *classes;    // array of class objects
    NSDictionary *menuCategories;

    IBOutlet NSArrayController *actionsController;
    IBOutlet ContextsDataSource *contextsDataSource;

    // New action creation hooks
    IBOutlet NSWindow *newActionWindow;
    IBOutlet NSView *newActionWindowParameterView;
    NSView *newActionWindowParameterViewCurrentControl;
    IBOutlet NSArrayController *newActionLimitedOptionsController;
    IBOutlet NSPopUpButton *newActionContext;
    NSString *newActionType;
    NSString *newActionTypeString;
    NSString *newActionWindowHelpText;
    NSString *newActionWindowWhen;
    
    IBOutlet NSSegmentedControl* addNewActionButton;
}

- (NSArray *)types;

- (IBAction)addAction:(id)sender;
- (IBAction)doAddAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
