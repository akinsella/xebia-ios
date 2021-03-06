//
//  XBWebViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 04/10/12.
//
//

#import <UIKit/UIKit.h>
#import "XBShareInfo.h"
#import "XBViewController.h"

@interface XBWebViewController : XBViewController<UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *json;
@property (nonatomic, retain) XBShareInfo *shareInfo;

- (void)loadRequest:(NSURL *)request;
@end
