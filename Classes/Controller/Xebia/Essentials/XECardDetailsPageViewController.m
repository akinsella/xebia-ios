//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DTCoreText/DTAttributedTextView.h>
#import "XECardDetailsPageViewController.h"
#import "ZXMultiFormatWriter.h"
#import "UIViewController+XBAdditions.h"
#import "ZXImage.h"
#import "DTHTMLElement.h"
#import "UIColor+XBAdditions.h"
#import "NSAttributedString+HTML.h"
#import "XECategory.h"
#import "XECardDetailsQRCodeViewController.h"
#import "ZXEncodeHints.h"

@interface XECardDetailsPageViewController()
@property(nonatomic, strong)XECard *card;
@property(nonatomic, assign)BOOL fullContentShown;
@end

@implementation XECardDetailsPageViewController


- (id)initWithCard:(XECard *)card
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"cardDetailsPage"];

    if (self) {
        self.card = card;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureContentView];

    self.fullContentShown = NO;

    self.titleLabel.text = self.card.title;
    self.titleLabel.backgroundColor = [UIColor clearColor];

    self.categoryLabel.text = self.card.category.label;
    self.identifierLabel.text = self.card.identifierFormatted;


    self.titleBackgroundView.backgroundColor = [UIColor colorWithHex:self.card.category.color];
    self.descriptionBackgroundView.backgroundColor = [UIColor colorWithHex:self.card.category.backgroundColor];

    self.stripeView.backgroundColor = [self.descriptionBackgroundView.backgroundColor darkerColorWithRatio:0.1];

    [self createQRCodeImage];
}

- (void)configureContentView {
    self.contentTextView.attributedString = [self attributedStringForHTML:self.card.excerpt];

    self.contentTextView.backgroundColor = [UIColor clearColor];

    // we draw images and links via subviews provided by delegate methods
    self.contentTextView.shouldDrawImages = NO;
    self.contentTextView.shouldDrawLinks = NO;
    self.contentTextView.textDelegate = self; // delegate for custom sub views

    // set an inset. Since the bottom is below a toolbar inset by 44px
    [self.contentTextView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    // gesture for testing cursor positions
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.contentTextView addGestureRecognizer:tap];
}

- (IBAction)infoTapped:(id)sender {
    [self toggleContent];
}

- (void)toggleContent {
    self.fullContentShown = !self.fullContentShown;
    self.contentTextView.attributedString = [self attributedStringForHTML:self.fullContentShown ? self.card.fullContent : self.card.excerpt];
}

-(void)createQRCodeImage {
    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXEncodeHints *hints = [[ZXEncodeHints alloc] init];
    hints.margin = @1;
    ZXBitMatrix* result = [writer encode:[self.card.url absoluteString]
                                  format:kBarcodeFormatQRCode
                                   width:248
                                  height:248
                                   hints:hints
                                   error:&error];
    if (result) {
        CGImageRef imageRef = [[ZXImage imageWithMatrix:result] cgimage];
        UIImage *buttonImage = [[UIImage alloc] initWithCGImage:imageRef];

        [self.qrCodeImage setImage:buttonImage forState:UIControlStateNormal];
        [self.qrCodeImage setImage:buttonImage forState:UIControlStateHighlighted];
        [self.qrCodeImage setImage:buttonImage forState:UIControlStateSelected];
    }
    else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

- (NSAttributedString *)attributedStringForHTML:(NSString *)html
{
    // Load HTML data
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];

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
//        CGPoint location = [gesture locationInView:self.contentTextView];
//        NSUInteger tappedIndex = (NSUInteger)[self.contentTextView closestCursorIndexToPoint:location];
//
//        NSString *plainText = [self.contentTextView.attributedString string];
//        NSString *tappedChar = [plainText substringWithRange:NSMakeRange(tappedIndex, 1)];
//
//        __block NSRange wordRange = NSMakeRange(0, 0);
//
//        [plainText enumerateSubstringsInRange:NSMakeRange(0, [plainText length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//            if (NSLocationInRange(tappedIndex, enclosingRange))
//            {
//                *stop = YES;
//                wordRange = substringRange;
//            }
//        }];
//
//        NSString *word = [plainText substringWithRange:wordRange];
//        NSLog(@"%d: '%@' word: '%@'", tappedIndex, tappedChar, word);

        [self toggleContent];
    }
}

- (IBAction)qrCodeTapped:(id)sender {
    XECardDetailsQRCodeViewController *cardDetailsQRCodeViewController = (XECardDetailsQRCodeViewController *)[self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"cardDetailsQRCode"];

    [cardDetailsQRCodeViewController updateWithCard: self.card];

    [self.appDelegate.mainViewController presentViewController:cardDetailsQRCodeViewController animated:YES completion:^{}];
}

@end