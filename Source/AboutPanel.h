//
//  AboutPanel.h
//  ControlPlaneX
//
//  Created by David Symonds on 2/08/07.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebView.h>


@interface AboutPanel : NSObject

- (id)init;

- (void)runPanel;

- (NSString *)versionString;
- (NSString *)gitCommit;

@end
