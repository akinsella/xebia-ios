//
// Created by Alexis Kinsella on 23/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "WPAbstractPostContentStructuredElementCell.h"


@interface WPPostContentCodeElementCell : WPAbstractPostContentStructuredElementCell<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end