//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import <DTCoreText/DTHTMLElement.h>
#import <DTCoreText/DTHTMLAttributedStringBuilder.h>
#import <DTCoreText/DTCSSStylesheet.h>
#import <DTCoreText/DTLinkButton.h>
#import "WPPostContentParagraphElementCell.h"
#import "XBAppDelegate.h"
#import "UIColor+XBAdditions.h"
#import "XBWebBrowser.h"

#define kDefaultFontFamily @"Cabin"

static const CGFloat kMarginWidth = 25.0;
static const CGFloat kMarginHeight = 25.0;

@interface WPPostContentParagraphElementCell()

@property (nonatomic, strong) WPPostContentStructuredElement *element;

@end

@implementation WPPostContentParagraphElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    if (self) {
        [self configure];
    }

    return self;
}

- (void)configure {
    [self setHasFixedRowHeight:NO];
    self.attributedTextContextView.delegate = self;
}

- (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) [[UIApplication sharedApplication] delegate];
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.accessoryType = UITableViewCellAccessoryNone;
}

-(void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    self.element = element;
    if ( [self.element.type isEqualToString: @"UL"] || [self.element.type isEqualToString:@"OL"] ) {
        NSString *html = [NSString stringWithFormat: @"<%@ style=\"padding: 0px 20px 0px 50px;\">%@</%@>", element.type, element.text, element.type];
        self.attributedString = [self attributedStringForHTML: html];
    }
    else {
        NSString *html = [NSString stringWithFormat: @"<%@ style=\"padding: 0px 10px 0px 10px;text-align: justify;\">%@</%@>", @"div", element.text, @"div"];
        self.attributedString = [self attributedStringForHTML: html];
    }
}

- (NSAttributedString *)attributedStringForHTML:(NSString *)html
{
    NSString *cssFilePath = [[NSBundle bundleForClass:self.class] pathForResource: @"Styles" ofType:@"css"];
    NSString *cssContent = [NSString stringWithContentsOfFile: cssFilePath encoding: NSUTF8StringEncoding error:nil];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock: cssContent];
    
    // Load HTML data
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *options = @{
            DTDefaultStyleSheet: stylesheet,
            DTDefaultFontFamily: kDefaultFontFamily,
            DTDefaultFontSize: @13.0,
            DTDefaultTextColor: [UIColor colorWithHex:@"#333333"],
            DTDefaultLinkColor: @"#9b59b6",
            DTDefaultLinkHighlightColor: @"#e74c3c",
            DTWillFlushBlockCallBack: ^(DTHTMLElement *element) {
                XBLog(@"Element: %@", element.attributedString);
            },
            DTUseiOS6Attributes: @NO
    };

    DTHTMLAttributedStringBuilder *attributedStringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML: data
                                                                                                        options: options
                                                                                             documentAttributes: nil];

    return [attributedStringBuilder generatedAttributedString];
}


- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = url;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;

    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];

    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];

    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (void)linkPushed:(DTLinkButton *)linkButton
{
    XBWebBrowser *webBrowser = [[XBWebBrowser alloc] initWithUrl:linkButton.URL];
    webBrowser.mode = TSMiniWebBrowserModeModal;
    webBrowser.showPageTitleOnTitleBar = YES;

    [self.appDelegate.mainViewController presentViewController:webBrowser animated:YES completion:^{ }];
}

-(CGFloat)heightForCell:(UITableView *)tableView {
    return [self requiredRowHeightInTableView: tableView];
}

@end