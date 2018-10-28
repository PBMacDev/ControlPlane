//
//  ActionSubmenuItem.h
//  ControlPlaneX
//
//  Created by Dustin Rue on 3/22/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ActionSubmenuItem : NSObject <NSMenuDelegate> {
    NSMutableArray *items;
    id __unsafe_unretained target;
}

@property (readwrite, strong) NSMutableArray *items;
@property (readwrite, unsafe_unretained) id target;

- (void) addObject:(id) object;

@end
