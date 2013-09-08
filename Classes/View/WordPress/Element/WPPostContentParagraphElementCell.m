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
#import "WPPostContentParagraphElementCell.h"
#import "XBAppDelegate.h"
#import "UIColor+XBAdditions.h"

#define kDefaultFontFamily @"Cabin"

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
        NSString *html = [NSString stringWithFormat: @"<%@>%@</%@>", element.type, element.text, element.type];
        self.attributedString = [self attributedStringForHTML: html];
    }
    else {
        self.attributedString = [self attributedStringForHTML: self.element.text];
    }

    CTFontRef font = CTFontCreateWithName(CFSTR("Cabin"), 20, NULL);
    NSLog(@"%@", font);
}

- (NSAttributedString *)attributedStringForHTML:(NSString *)html
{
    NSString *cssFilePath = [[NSBundle bundleForClass:self.class] pathForResource: @"Styles" ofType:@"css"];
    NSString *cssContent = [NSString stringWithContentsOfFile: cssFilePath encoding: NSUTF8StringEncoding error:nil];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock: cssContent];
    
    // Load HTML data
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];

    CGSize maxImageSize = CGSizeMake(self.bounds.size.width - 20.0, self.bounds.size.height - 20.0);

    NSDictionary *options = @{
            DTMaxImageSize: [NSValue valueWithCGSize:maxImageSize],
            DTDefaultStyleSheet: stylesheet,
            DTDefaultFontFamily: kDefaultFontFamily,
            DTDefaultFontSize: @12.0,
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

-(CGFloat)heightForCell:(UITableView *)tableView {
    return [self requiredRowHeightInTableView: tableView];
}

@end