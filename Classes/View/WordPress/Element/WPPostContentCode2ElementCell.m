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
#import "WPPostContentCode2ElementCell.h"
#import "XBAppDelegate.h"
#import "UIColor+XBAdditions.h"
#import "NSString+HTML.h"

#define kDefaultFontFamily @"Cabin"

static const CGFloat kMarginWidth = 25.0;
static const CGFloat kMarginHeight = 25.0;

@interface WPPostContentCode2ElementCell()

@property (nonatomic, strong) WPPostContentStructuredElement *element;

@end

@implementation WPPostContentCode2ElementCell

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
}

- (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) [[UIApplication sharedApplication] delegate];
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.attributedTextContextView.backgroundColor = [UIColor colorWithHex:@"#333333"];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.accessoryType = UITableViewCellAccessoryNone;
}

-(void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    self.element = element;

    NSString *html = [NSString stringWithFormat:@"<div style=\"padding: 10px;text-align: justify;\">%@</div>",
                    [[[element.text stringByAddingHTMLEntities]
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br />"]
                            stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"]
    ];
    self.attributedString = [self attributedStringForHTML: html];
}

- (NSAttributedString *)attributedStringForHTML:(NSString *)html
{
    NSString *cssFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"Styles" ofType:@"css"];
    NSString *cssContent = [NSString stringWithContentsOfFile: cssFilePath encoding: NSUTF8StringEncoding error:nil];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock: cssContent];

    // Load HTML data
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *options = @{
            DTDefaultStyleSheet: stylesheet,
            DTDefaultFontFamily: kDefaultFontFamily,
            DTDefaultFontSize: @13.0,
            DTDefaultTextColor: [UIColor colorWithHex:@"#E0E0E0"],
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

-(CGFloat)heightForCell:(UITableView *)tableView {
    return [self requiredRowHeightInTableView: tableView];
}

@end