//
//  ContextSelectionButton.h
//  ControlPlaneX
//
//  Created by David Symonds on 6/07/07.
//

#import <Cocoa/Cocoa.h>
#import "ContextsDataSource.h"


@interface ContextSelectionButton : NSPopUpButton

- (void)setContextsDataSource:(ContextsDataSource *)dataSource;

@end
