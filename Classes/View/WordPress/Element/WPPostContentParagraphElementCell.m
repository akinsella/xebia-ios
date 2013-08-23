//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import <DTCoreText/DTHTMLElement.h>
#import <DTCoreText/DTHTMLAttributedStringBuilder.h>
#import "WPPostContentParagraphElementCell.h"
#import "XBAppDelegate.h"
#import "UIColor+XBAdditions.h"

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
}

- (NSAttributedString *)attributedStringForHTML:(NSString *)html
{
    // Load HTML data
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];

    CGSize maxImageSize = CGSizeMake(self.bounds.size.width - 20.0, self.bounds.size.height - 20.0);

    NSDictionary *options = @{
            DTMaxImageSize: [NSValue valueWithCGSize:maxImageSize],
            DTDefaultFontFamily: @"Helvetica Neue",
            DTDefaultFontSize: @13.0,
            DTDefaultTextColor: [UIColor colorWithHex:@"#34495e"],
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

    NSAttributedString *attributedString = [attributedStringBuilder generatedAttributedString];

    return attributedString;
}

-(CGFloat)heightForCell:(UITableView *)tableView {
    return [self requiredRowHeightInTableView: tableView];
}

@end