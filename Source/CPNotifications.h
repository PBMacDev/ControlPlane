//
//  CPNotifications.h
//  ControlPlaneX
//
//  Created by Dustin Rue on 7/27/12.
//
//

#import <Cocoa/Cocoa.h>

@interface CPNotifications : NSObject

+ (void)postUserNotification:(NSString *)title withMessage:(NSString *)message;

@end
