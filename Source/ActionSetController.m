//
//  ActionSetController.m
//  ControlPlaneX
//
//  Created by Pavlo Boyko on 11/23/18.
//

#import "ActionSetController.h"
#import "DSLogger.h"

#import "ActionSubmenuItem.h"

#import "ConnectBluetoothDeviceAction.h"
#import "DefaultBrowserAction.h"
#import "DefaultPrinterAction.h"
#import "DesktopBackgroundAction.h"
#import "DisplayBrightnessAction.h"
#import "DisplaySleepTimeAction.h"
#import "FirewallRuleAction.h"
//#import "ITunesPlaylistAction.h"
#import "LockKeychainAction.h"
#import "MailIMAPServerAction.h"
#import "MailSMTPServerAction.h"
#import "MailIntervalAction.h"
//#import "MessagesAction.h"
#import "MountAction.h"
#import "MuteAction.h"
#import "NetworkLocationAction.h"
#import "OpenAction.h"
#import "OpenAndHideAction.h"
#import "OpenURLAction.h"
#import "PreventDisplaySleepAction.h"
#import "PreventSystemSleepAction.h"
#import "QuitApplicationAction.h"
#import "ScreenSaverPasswordAction.h"
#import "ScreenSaverStartAction.h"
#import "ScreenSaverTimeAction.h"
#import "ScrollBarsAction.h"
#import "ShellScriptAction.h"
#import "SpeakAction.h"
#import "StartTimeMachineAction.h"
#import "TimeMachineDestinationAction.h"
#import "ToggleBluetoothAction.h"
#import "ToggleContextStickinessAction.h"
#import "ToggleFileSharingAction.h"
#import "ToggleFirewallAction.h"
#import "ToggleFTPAction.h"
#import "ToggleInternetSharingAction.h"
#import "ToggleNaturalScrollingAction.h"
#import "ToggleNotificationCenterAlertsAction.h"
#import "TogglePrinterSharingAction.h"
#import "ToggleRemoteLoginAction.h"
#import "ToggleTFTPAction.h"
#import "ToggleTimeMachineAction.h"
#import "ToggleWebSharingAction.h"
#import "ToggleWiFiAction.h"
#import "UnmountAction.h"

@interface ActionSetController (Private)

- (NSArray *)getActionPlugins;

@end

@implementation ActionSetController

- (id)init
{
    if (!(self = [super init]))
        return nil;
    
    classes = [[NSMutableArray alloc] initWithObjects:
               [ConnectBluetoothDeviceAction class],
               [DefaultBrowserAction class],
               [DefaultPrinterAction class],
               [DesktopBackgroundAction class],
               [DisplayBrightnessAction class],
               [DisplaySleepTimeAction class],
//               [ITunesPlaylistAction class],
               [LockKeychainAction class],
               [MailIMAPServerAction class],
               [MailSMTPServerAction class],
               [MailIntervalAction class],
//               [MessagesAction class],
               [MountAction class],
               [MuteAction class],
               [NetworkLocationAction class],
               [OpenAction class],
               [OpenAndHideAction class],
               [OpenURLAction class],
               [QuitApplicationAction class],
               [PreventDisplaySleepAction class],
               [PreventSystemSleepAction class],
               [ScreenSaverPasswordAction class],
               [ScreenSaverStartAction class],
               [ScreenSaverTimeAction class],
               [ScrollBarsAction class],
               [ShellScriptAction class],
               [SpeakAction class],
               [StartTimeMachineAction class],
               [TimeMachineDestinationAction class],
               [ToggleBluetoothAction class],
               [ToggleContextStickinessAction class],
               [ToggleFileSharingAction class],
               [ToggleFirewallAction class],
               [ToggleFTPAction class],
               [ToggleInternetSharingAction class],
               [ToggleNaturalScrollingAction class],
               [ToggleNotificationCenterAlertsAction class],
               [TogglePrinterSharingAction class],
               [ToggleRemoteLoginAction class],
               [ToggleTFTPAction class],
               [ToggleTimeMachineAction class],
               [ToggleWebSharingAction class],
               [ToggleWiFiAction class],
               [UnmountAction class],
               nil];
    
    
    // Load any available plugins
#ifdef DEBUG_MODE
    NSArray *availablePlugins = [self getActionPlugins];
    for (NSString *pluginPath in availablePlugins) {
        NSLog(@"would load plugin at %@", pluginPath);
        NSBundle *thePlugin = [NSBundle bundleWithPath:pluginPath];
        Class principalClass = [thePlugin principalClass];
        @try {
            [classes addObject:principalClass];
        }
        @catch (NSException *e) {
            NSLog(@"%@ is not a vaild plugin", pluginPath);
        }
    }
#endif
    
    if (NO) {
        // Purely for the benefit of 'genstrings'
        NSLocalizedString(@"DefaultBrowser", @"Action type");
        NSLocalizedString(@"DefaultPrinter", @"Action type");
        NSLocalizedString(@"DesktopBackground", @"Action type");
        NSLocalizedString(@"DisplayBrightness", @"Action type");
//        NSLocalizedString(@"iTunesPlaylist", @"Action type");
        NSLocalizedString(@"LockKeychain", @"Action type");
        NSLocalizedString(@"MailIMAPServer", @"Action type");
        NSLocalizedString(@"MailSMTPServer", @"Action type");
        NSLocalizedString(@"MailInterval", @"Action type");
        NSLocalizedString(@"Messages", @"Action type");
        NSLocalizedString(@"Mount", @"Action type");
        NSLocalizedString(@"Mute", @"Action type");
        NSLocalizedString(@"NetworkLocation", @"Action type");
        NSLocalizedString(@"Open", @"Action type");
        NSLocalizedString(@"OpenAndHide", @"Action type");
        NSLocalizedString(@"OpenURL", @"Action type");
        NSLocalizedString(@"Prevent Display Sleep", @"Action type");
        NSLocalizedString(@"QuitApplication", @"Action type");
        NSLocalizedString(@"ScreenSaverPassword", @"Action type");
        NSLocalizedString(@"ScreenSaverStart", @"Action type");
        NSLocalizedString(@"ScreenSaverTime", @"Action type");
        NSLocalizedString(@"ScrollBars", @"Action type");
        NSLocalizedString(@"ShellScript", @"Action type");
        NSLocalizedString(@"Speak", @"Action type");
        NSLocalizedString(@"StartTimeMachine", @"Action type");
        NSLocalizedString(@"TimeMachineDestination", @"Action type");
        NSLocalizedString(@"ToggleBluetooth", @"Action type");
        NSLocalizedString(@"ToggleContextStickiness", @"Action type");
        NSLocalizedString(@"ToggleFileSharing", @"Action type");
        NSLocalizedString(@"ToggleFirewall", @"Action type");
        NSLocalizedString(@"ToggleInternetSharing", @"Action type");
        NSLocalizedString(@"ToggleNaturalScrolling", @"Action type");
        NSLocalizedString(@"ToggleNotificationCenterAlertsAction", @"Action type");
        NSLocalizedString(@"TimeMachineAction",@"Action type");
        NSLocalizedString(@"ToggleWiFi", @"Action type");
        NSLocalizedString(@"Unmount", @"Action type");
        NSLocalizedString(@"VPN", @"Action type");
    }
    
    // build a list of menu categories
    NSMutableDictionary *menuCategoryBuilder = [NSMutableDictionary dictionary];
    NSMutableDictionary *tmpDict = nil;
    ActionSubmenuItem *tmp = nil;
    
    
    for (id currentClass in classes) {
        // check to see if this action is applicable to this system
        
        if (![currentClass isActionApplicableToSystem])
            continue;
        
        // if the object exists then we've seen this category before
        // and we simply want to add the class to the object we just found
        if ([menuCategoryBuilder objectForKey:[currentClass menuCategory]]) {
            tmp = [menuCategoryBuilder objectForKey:[currentClass menuCategory]];
            tmpDict = [NSMutableDictionary dictionaryWithCapacity:3];
            [tmpDict setObject:currentClass forKey:@"class"];
            [tmpDict setObject:[currentClass class] forKey:@"representedObject"];
            [tmp setTarget:self];
            [tmp addObject:tmpDict];
            
        }
        else {
            tmp = [[ActionSubmenuItem alloc] init];
            tmpDict = [NSMutableDictionary dictionaryWithCapacity:3];
            [tmpDict setObject:currentClass forKey:@"class"];
            [tmpDict setObject:[currentClass class] forKey:@"representedObject"];
            [tmp setTarget:self];
            [tmp addObject:tmpDict];
            
            [menuCategoryBuilder setObject:tmp forKey:[currentClass menuCategory]];
            
        }
    }

    menuCategories = [menuCategoryBuilder copy];
    
    newActionWindowParameterViewCurrentControl = nil;

    return self;
}

- (void)awakeFromNib
{
    [addNewActionButton setMenu:[addNewActionButton menu] forSegment:0];
    [addNewActionButton setShowsMenuIndicator:YES forSegment:0];
}

- (NSArray *)types
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[classes count]];
    NSEnumerator *en = [classes objectEnumerator];
    Class klass;
    while ((klass = [en nextObject])) {
        [array addObject:[Action typeForClass:klass]];
    }
    return array;
}

/**
 *  Returns an array containing paths to all of the available Action Plugins
 */
- (NSArray *)getActionPlugins {
    NSMutableArray *searchPaths = [NSMutableArray array];
    NSMutableArray *bundles = [NSMutableArray array];
    NSString *pluginPath = @"/Application Support/ControlPlaneX/PlugIns/Actions";
    
    
    for (NSString *path in NSSearchPathForDirectoriesInDomains(
                                                               NSLibraryDirectory,
                                                               NSAllDomainsMask - NSSystemDomainMask,
                                                               YES)) {
        [searchPaths addObject:[path stringByAppendingPathComponent:pluginPath]];
    }
    
    [searchPaths addObject:[NSString stringWithFormat:@"%@/Actions",[[NSBundle mainBundle] builtInPlugInsPath]]];
    
    
    for (NSString *currentPath in searchPaths) {
        NSDirectoryEnumerator *dirEnumerator;
        NSString *currentFile;
        
        dirEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:currentPath];
        
        if (dirEnumerator) {
            while (currentFile = [dirEnumerator nextObject]) {
                if([[currentFile pathExtension] isEqualToString:@"bundle"]) {
                    [bundles addObject:[currentPath stringByAppendingPathComponent:currentFile]];
                }
            }
        }
    }
    
    // hand back an immutable version
    return (NSArray *)bundles;
}

#pragma mark NSMenu delegates

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel
{
    NSArray *menuCategoryList = [menuCategories allKeys];
    menuCategoryList = [menuCategoryList sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *friendlyName = [[classes objectAtIndex:index] friendlyName];
    NSString *categoryName = [menuCategoryList objectAtIndex:index];
    //NSString *localisedType = NSLocalizedString(type, @"Action type");
    
    NSMenu *newSubMenu = [[NSMenu alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ Actions", @""), friendlyName]];
    
    [newSubMenu setDelegate:[menuCategories objectForKey:categoryName]];
    
    [item setSubmenu:newSubMenu];
    [item setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ Actions", @""), categoryName]];
    [item setRepresentedObject:[classes objectAtIndex:index]];

    return YES;
}

- (BOOL)menuHasKeyEquivalent:(NSMenu *)menu forEvent:(NSEvent *)event target:(id *)target action:(SEL *)action
{
    // TODO: support keyboard menu jumping?
    return NO;
}

- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu
{
    return [menuCategories count];
}

- (IBAction)addRemoveAction:(id)sender
{
    
}

#pragma mark Action creation

- (void)addAction:(id)sender
{
    Class klass = [sender representedObject];
    [self setValue:[Action typeForClass:klass] forKey:@"newActionType"];
    [self setValue:NSLocalizedString([Action typeForClass:klass], @"Action type")
            forKey:@"newActionTypeString"];
    
    [self setValue:[klass creationHelpText] forKey:@"newActionWindowHelpText"];
    [self setValue:@"Arrival" forKey:@"newActionWindowWhen"];
    
    [newActionWindow setTitle:[NSString stringWithFormat:
                               NSLocalizedString(@"New %@ Action", @"Window title"), newActionTypeString]];
    
    [newActionContext setMenu:[contextsDataSource hierarchicalMenu]];
    
    if ([klass conformsToProtocol:@protocol(ActionWithLimitedOptions)]) {
        NSArrayController *loC = newActionLimitedOptionsController;
        [loC removeObjects:[loC arrangedObjects]];
        NSArray *returnedOptions = [klass limitedOptions];
        if (!returnedOptions) {
            return;
        }
        [loC addObjects:[klass limitedOptions]];
        [loC selectNext:self];
        
        NSRect frame = [newActionWindowParameterView bounds];
        frame.size.height = 26;        // HACK!
        NSPopUpButton *pub = [[NSPopUpButton alloc] initWithFrame:frame pullsDown:NO];
        // Bindings:
        [pub bind:@"content" toObject:loC withKeyPath:@"arrangedObjects" options:nil];
        [pub bind:@"contentValues" toObject:loC withKeyPath:@"arrangedObjects.description" options:nil];
        [pub bind:@"selectedIndex" toObject:loC withKeyPath:@"selectionIndex" options:nil];
        
        if (newActionWindowParameterViewCurrentControl)
            [newActionWindowParameterViewCurrentControl removeFromSuperview];
        [newActionWindowParameterView addSubview:pub];
        newActionWindowParameterViewCurrentControl = pub;
        
        [NSApp activateIgnoringOtherApps:YES];
        [newActionWindow makeKeyAndOrderFront:self];
        return;
    } else if ([klass conformsToProtocol:@protocol(ActionWithFileParameter)]) {
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setAllowsMultipleSelection:NO];
        [panel setCanChooseDirectories:NO];
        if ([panel runModal] != NSModalResponseOK)
            return;
        NSString *filename = [[panel URL] path];
        Action *action = [[klass alloc] initWithFile:filename];
        
        NSMutableDictionary *actionDictionary = [action dictionary];
        [actionsController addObject:actionDictionary];
        [actionsController setSelectedObjects:[NSArray arrayWithObject:actionDictionary]];
        return;
    } else if ([klass conformsToProtocol:@protocol(ActionWithString)]) {
        NSRect frame = [newActionWindowParameterView bounds];
        frame.size.height = 22;        // HACK!
        NSTextField *tf = [[NSTextField alloc] initWithFrame:frame];
        [tf setStringValue:@""];    // TODO: sensible initialisation?
        
        if (newActionWindowParameterViewCurrentControl)
            [newActionWindowParameterViewCurrentControl removeFromSuperview];
        [newActionWindowParameterView addSubview:tf];
        newActionWindowParameterViewCurrentControl = tf;
        
        [NSApp activateIgnoringOtherApps:YES];
        [newActionWindow makeKeyAndOrderFront:self];
        return;
    }
    
    // Worst-case fallback: just make a new action, and select it:
    Action *action = [[[sender representedObject] alloc] init];
    NSMutableDictionary *actionDictionary = [action dictionary];
    
    [actionsController addObject:actionDictionary];
    [actionsController setSelectedObjects:[NSArray arrayWithObject:actionDictionary]];
}

- (IBAction)doAddAction:(id)sender
{
    Class klass = [Action classForType:newActionType];
    Action *tmp_action = [[klass alloc] init];
    NSMutableDictionary *dict = [tmp_action dictionary];
    
    // Pull parameter out of the right type of UI control
    NSString *param, *desc = nil;
    if ([klass conformsToProtocol:@protocol(ActionWithLimitedOptions)]) {
        NSDictionary *sel = [[newActionLimitedOptionsController selectedObjects] lastObject];
        DSLog(@"doAddAction sees %@",sel);
        param = [sel valueForKey:@"option"];
        desc = [sel valueForKey:@"description"];
    } else if ([klass conformsToProtocol:@protocol(ActionWithString)]) {
        NSTextField *tf = (NSTextField *) newActionWindowParameterViewCurrentControl;
        param = [tf stringValue];
        desc = [tf stringValue];
    } else {
        NSLog(@"PANIC! Don't know how to get parameter!!!");
        return;
    }
    
    // Finish creating dictionary
    [dict setValue:param forKey:@"parameter"];
    [dict setValue:[[newActionContext selectedItem] representedObject] forKey:@"context"];
    [dict setValue:newActionWindowWhen forKey:@"when"];
    if (desc)
        [dict setValue:desc forKey:@"description"];
    
    // Stick it in action collection, and select it
    [actionsController addObject:dict];
    [actionsController setSelectedObjects:[NSArray arrayWithObject:dict]];
    
    [newActionWindow performClose:self];
}


@end
