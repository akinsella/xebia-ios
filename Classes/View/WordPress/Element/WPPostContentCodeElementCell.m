//
// Created by Alexis Kinsella on 23/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WPPostContentCodeElementCell.h"


@implementation WPPostContentCodeElementCell

- (void)configure {
    self.webView.delegate = self;
}

- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement: element];

    NSString* path = [[NSBundle mainBundle] pathForResource: @"index" ofType: @"html" inDirectory: @"www"];

    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];

    content = [NSString stringWithFormat:content, @"java", element.text];
    [self.webView loadHTMLString:content baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits: CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;

    NSLog(@"webview frame size %f",webView.frame.size.height);
    [webView setOpaque:NO];
    [webView setBackgroundColor:[UIColor whiteColor]];
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return self.webView != nil ? self.webView.frame.size.height : 64;
}

@end