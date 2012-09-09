//
//  DetailViewController.h
//  StoryboardTutorial
//
//  Created by Kurry Tran on 10/20/11.
//  Copyright (c) 2011 Xebia France. All rights reserved.
//

#import "Post.h"
#import <UIKit/UIKit.h>

@interface XBDetailPostViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic, retain) Post *post;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
