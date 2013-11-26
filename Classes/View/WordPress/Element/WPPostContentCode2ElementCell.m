//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "WPPostContentCode2ElementCell.h"
#import "XBAppDelegate.h"
#import "UIColor+XBAdditions.h"
#import "NSString+XBAdditions.h"

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

    self.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.attributedString = [element.text highlightSyntaxWithFont: [UIFont fontWithName:@"Cabin" size:14]];
}


-(CGFloat)heightForCell:(UITableView *)tableView {
    return [self requiredRowHeightInTableView: tableView];
}

@end