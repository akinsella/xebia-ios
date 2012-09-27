//
//  DetailViewController.h
//  StoryboardTutorial
//
//  Created by Kurry Tran on 10/20/11.
//  Copyright (c) 2011 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPPost.h"

@interface XBDetailPostViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic, retain) WPPost *post;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
