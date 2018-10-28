//
//  MountAction.h
//  ControlPlaneX
//
//  Created by David Symonds on 9/06/07.
//

#import "Action.h"


@interface MountAction : Action <ActionWithString> {
	NSString *path;
}

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSMutableDictionary *)dictionary;

- (NSString *)description;
- (BOOL)execute:(NSString **)errorString;
+ (NSString *)helpText;
+ (NSString *)creationHelpText;

@end
