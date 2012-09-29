//
//  XBDetailPostViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPPost.h"

@interface XBDetailPostViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic, retain) WPPost *post;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
