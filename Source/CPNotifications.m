//
//  CPNotifications.m
//  ControlPlaneX
//
//  Created by Dustin Rue on 7/27/12.
//
//  IMPORTANT: This code is intended to be compiled for the ARC mode
//

#import "CPNotifications.h"
#import <UserNotifications/UserNotifications.h>

@implementation CPNotifications

+ (void)postUserNotification:(NSString *)title withMessage:(NSString *)message
{
    UNUserNotificationCenter *currentCenter = [UNUserNotificationCenter currentNotificationCenter];
    [currentCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if ([settings alertSetting] == UNNotificationSettingEnabled) {
            
            UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
            content.title = title;
            content.body = message;

            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ua.in.pboyko.UNNotificationRequestID" content:content trigger:nil];

            [currentCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                ;
            }];
        }
    }];

}

@end
