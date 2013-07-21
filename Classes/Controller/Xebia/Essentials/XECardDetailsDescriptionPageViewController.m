//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DTCoreText/DTCoreTextConstants.h>
#import <DTCoreText/NSAttributedString+HTML.h>
#import <DTCoreText/DTHTMLElement.h>
#import "XECardDetailsDescriptionPageViewController.h"
#import "UIColor+XBAdditions.h"
#import "UIViewController+XBAdditions.h"

@implementation XECardDetailsDescriptionPageViewController

// load the view nib and initialize the pageNumber ivar
- (id)init
{

    if (self = [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"cardDetailsDescriptionPage"]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.descriptionTextView.backgroundColor = [UIColor clearColor];

    // we draw images and links via subviews provided by delegate methods
    self.descriptionTextView.shouldDrawImages = NO;
    self.descriptionTextView.shouldDrawLinks = NO;
    self.descriptionTextView.textDelegate = self; // delegate for custom sub views

    // gesture for testing cursor positions
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.descriptionTextView addGestureRecognizer:tap];

    // set an inset. Since the bottom is below a toolbar inset by 44px
    [self.descriptionTextView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 44, 0)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.card) {
        self.descriptionTextView.attributedString = [self attributedStringForCard];
    }
}

- (void)updateWithCard:(XECard *)card {
    [super updateWithCard:card];
}

- (NSAttributedString *)attributedStringForCard
{
    // Load HTML data
    NSData *data = [self.card.description_ dataUsingEncoding:NSUTF8StringEncoding];


    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);

    NSDictionary *options = @{
            NSTextSizeMultiplierDocumentOption: @1.0,
            DTMaxImageSize: [NSValue valueWithCGSize:maxImageSize],
            DTDefaultFontFamily: @"Helvetica",
            DTDefaultFontSize: @14.0,
            DTDefaultTextColor: [UIColor colorWithHex:@"#FFFFFF"],
            DTDefaultLinkColor: @"purple",
            DTDefaultLinkHighlightColor: @"red",
            DTWillFlushBlockCallBack: ^(DTHTMLElement *element) {},
            DTUseiOS6Attributes: @YES
    };

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data
                                                                                options: options
                                                                     documentAttributes:NULL];

    return attributedString;
}


- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [gesture locationInView:self.descriptionTextView];
        NSUInteger tappedIndex = (NSUInteger)[self.descriptionTextView closestCursorIndexToPoint:location];

        NSString *plainText = [self.descriptionTextView.attributedString string];
        NSString *tappedChar = [plainText substringWithRange:NSMakeRange(tappedIndex, 1)];

        __block NSRange wordRange = NSMakeRange(0, 0);

        [plainText enumerateSubstringsInRange:NSMakeRange(0, [plainText length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            if (NSLocationInRange(tappedIndex, enclosingRange))
            {
                *stop = YES;
                wordRange = substringRange;
            }
        }];

        NSString *word = [plainText substringWithRange:wordRange];
        NSLog(@"%d: '%@' word: '%@'", tappedIndex, tappedChar, word);
    }
}


@end