//
// Created by Alexis Kinsella on 23/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WPPostContentCodeElementCell.h"
#import "NSString+XBAdditions.h"
#import "NSString+HTML.h"


@implementation WPPostContentCodeElementCell

-(void)layoutSubviews {
    self.webView.delegate = self;
    [super layoutSubviews];
}

- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement: element];

    NSString* path = [[NSBundle bundleForClass:self.class] pathForResource: @"index" ofType: @"html" inDirectory: @"www"];

    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];

    NSString *eltText = [element.text stringByAddingHTMLEntities];
    content = [NSString stringWithFormat:content, element[@"language"], eltText];
    [self.webView loadHTMLString:content baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGSize fittingSize = [webView sizeThatFits:CGSizeMake(self.frame.size.width - 30 - 20, 300)];
    webView.frame = CGRectMake(30, 10, self.frame.size.width - 30 - 20, fittingSize.height);
    NSLog(@"webview frame size %f", webView.frame.size.height);

    [webView setOpaque: NO];
    [webView setBackgroundColor:[UIColor whiteColor]];

    NSString *eltText = [self.element.text stringByAddingHTMLEntities];
    NSString *textMd5 = [eltText md5];

    if (!self.heightWebViewCache[textMd5]) {
        NSNumber *height = @(webView.frame.size.height);
        self.heightWebViewCache[textMd5] = height;
        [self.delegate reloadCellForElement:self.element];
    }

}

- (CGFloat)heightForCell:(UITableView *)tableView {

    NSString *eltText = [self.element.text stringByAddingHTMLEntities];
    NSString *textMd5 = [eltText md5];
    NSNumber *height = self.heightWebViewCache[textMd5];

    if (height) {
        return [height integerValue] + 2 * 10;
    }
    else if (self.webView) {
        return self.webView.frame.size.height + 2 * 10;
    }
    else {
        return 64 + 2 * 10;
    }
}

@end