//
//	WLANBSSIDRule.h
//	ControlPlane
//
//	Created by David Jennes on 24/09/11.
//	Copyright 2011. All rights reserved.
//

#import "Rule.h"

@interface WLANBSSIDRule : Rule<RuleProtocol> {
	NSString *m_bssid;
}

@end
