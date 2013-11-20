//
//  XBTableViewCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 23/06/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "XBTableViewCell.h"
#import "DTCustomColoredAccessory.h"
#import "UIColor+XBAdditions.h"

@interface XBTableViewCell()

@property (nonatomic, strong)CAShapeLayer *shapeLayer;
@property (nonatomic, strong)CAShapeLayer *selectedShapeLayer;
@property (nonatomic, strong)CAGradientLayer *selectedGradientLayer;
@property (nonatomic, strong)UIControl *accessoryView;

@end

@implementation XBTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    [self initAccessoryView];
    [self initBackgroundView];
    self.backgroundColor = [UIColor clearColor];
}

- (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) [[UIApplication sharedApplication] delegate];
}

-(UIColor *)accessoryViewColor {
    return [UIColor colorWithHex:@"#999999"];
}

-(UIColor *)accessoryViewBackgroundColor {
    return [UIColor clearColor];
}

-(BOOL)showSeparatorLine {
    return YES;
}

-(BOOL)customizeSelectedBackgroundView {
    return YES;
}

-(BOOL)customizeBackgroundView {
    return YES;
}

-(UIColor *)accessoryViewHighlightedColor {
    return [UIColor colorWithHex:@"#666666"];
}

- (UIColor *)gradientLayerColor {
    return [UIColor colorWithHex:@"#3e0b34"];
}

- (UIColor *)lineSeparatorColor {
    return [UIColor colorWithHex:@"#E9E9E9"];
}

-(void)initAccessoryView {
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[self accessoryViewColor]];
    accessory.highlightedColor = [self accessoryViewHighlightedColor];
//    [accessory addTarget:self action:@selector(accessoryButtonTapped:withEvent:)  forControlEvents:UIControlEventTouchUpInside];
    accessory.backgroundColor = [self accessoryViewBackgroundColor];
    self.accessoryView = accessory;
}

//- (void)accessoryButtonTapped:(UIControl *)button withEvent:(UIEvent *)event
//{
//    UITableViewCell *cell = (UITableViewCell *)button.superview;
//    UITableView *tableView = (UITableView *)cell.superview;
//    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
//    [tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
//}

- (void)initBackgroundView {

    UIViewAutoresizing autoResizingMask =
            ( UIViewAutoresizingFlexibleWidth
            | UIViewAutoresizingFlexibleBottomMargin
            | UIViewAutoresizingFlexibleTopMargin
            | UIViewAutoresizingFlexibleLeftMargin
            | UIViewAutoresizingFlexibleRightMargin );

    //Create background view
    if (self.customizeBackgroundView) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundView.contentMode = UIViewContentModeTop;
        self.backgroundView.autoresizingMask = autoResizingMask;

        if (self.showSeparatorLine) {
            self.shapeLayer = [self createBottomLineShapeLayout];
            [self.backgroundView.layer insertSublayer:self.shapeLayer atIndex:0];
        }
    }

    //Create selected background view
    if (self.customizeSelectedBackgroundView) {
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.contentMode = UIViewContentModeTop;
        self.selectedBackgroundView.autoresizingMask = autoResizingMask;

        self.selectedGradientLayer = [self createGradientLayer];
        [self.selectedBackgroundView.layer insertSublayer:self.selectedGradientLayer atIndex:0];

        if (self.showSeparatorLine) {
            self.selectedShapeLayer = [self createBottomLineShapeLayout];
            [self.selectedBackgroundView.layer insertSublayer:self.selectedShapeLayer atIndex:1];
        }
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    if (self.customizeBackgroundView) {
        [self updateLayoutForLayer:self.shapeLayer];
        [self updatePathForShapeLayer: self.shapeLayer selected: NO];
    }

    if (self.customizeSelectedBackgroundView) {
        [self updateLayoutForLayer:self.selectedShapeLayer];
        [self updatePathForShapeLayer: self.selectedShapeLayer selected: YES];

        [self updateLayoutForLayer:self.selectedGradientLayer];
    }
}

-(void)updateLayoutForLayer:(CALayer *)shapeLayer {
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
}

- (void)updatePathForShapeLayer:(CAShapeLayer *)shapeLayer selected:(BOOL)selected {
    CGMutablePathRef path = CGPathCreateMutable();

    if (!selected) {
        CGPathMoveToPoint(path, NULL, 2, 0);
        CGPathAddLineToPoint(path, NULL, self.bounds.size.width - 2, 0);
    }
    else {
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, self.bounds.size.width, 0);
    }

    [shapeLayer setPath:path];
}

- (CAGradientLayer *)createGradientLayer {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    UIColor *first = self.gradientLayerColor;
    UIColor *second = self.gradientLayerColor;
    UIColor *third = self.gradientLayerColor;
    UIColor *fourth = self.gradientLayerColor;

    gradientLayer.colors = @[(id)first.CGColor, (id)second.CGColor, (id)third.CGColor, (id)fourth.CGColor];
    gradientLayer.locations = @[@0.0f, @0.3f, @0.7f, @1.0f];

    return gradientLayer;
}

- (CAShapeLayer *)createBottomLineShapeLayout {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[self lineSeparatorColor] CGColor]];
    [shapeLayer setLineWidth:2.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];

    return shapeLayer;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    if (accessoryType == UITableViewCellAccessoryNone) {
        self.accessoryView = nil;
    } else if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        self.accessoryView = self.accessoryView;
    }
}

@end
