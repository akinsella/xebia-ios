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
#import "NSAttributedString+DTCoreText.h"
#import "XECategory.h"
#import "XECardDetailsQRCodeViewController.h"
#import "ZXEncodeHints.h"
#import "DTLinkButton.h"
#import "NSAttributedString+DTCoreText.h"
#import "DTHTMLAttributedStringBuilder.h"
#import "XBHttpQueryParamBuilder.h"

@interface XECardDetailsPageViewController()
@property(nonatomic, strong)XECard *card;
@property(nonatomic, assign)BOOL fullContentShown;
@property (nonatomic, strong) NSURL *lastActionLink;
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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self createQRCodeImage];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)configureContentView {

    [DTCoreTextLayoutFrame setShouldDrawDebugFrames: NO];

    self.contentTextView.attributedString = [self attributedStringForHTML:self.card.excerpt];

    self.contentTextView.contentInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);

    self.contentTextView.backgroundColor = [UIColor clearColor];

    // we draw images and links via subviews provided by delegate methods
    self.contentTextView.shouldDrawImages = NO;
    self.contentTextView.shouldDrawLinks = NO;
    self.contentTextView.textDelegate = self; // delegate for custom sub views

    // set an inset. Since the bottom is below a toolbar inset by 44px

    // gesture for testing cursor positions
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.contentTextView addGestureRecognizer:tap];
}

#pragma mark Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];

    NSURL *URL = attributes[DTLinkAttribute];
    NSString *identifier = attributes[DTGUIDAttribute];

    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
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

    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];

    return button;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[self.lastActionLink absoluteURL]];
    }
}


- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        DTLinkButton *button = (id)[gesture view];
        button.highlighted = NO;
        self.lastActionLink = button.URL;

        if ([UIApplication.sharedApplication canOpenURL:button.URL.absoluteURL]) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:button.URL.absoluteURL.description delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
            [action showFromRect:button.frame inView:button.superview animated:YES];
        }
    }
}

#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button
{
    NSURL *URL = button.URL;

    if ([UIApplication.sharedApplication canOpenURL:URL.absoluteURL]) {
        [UIApplication.sharedApplication openURL:URL.absoluteURL];
    }
    else {
        if (!URL.host && !URL.path) {
            // possibly a local anchor link
            NSString *fragment = URL.fragment;

            if (fragment) {
                [self.contentTextView scrollToAnchorNamed:fragment animated:NO];
            }
        }
    }
}

#pragma mark - Toggle excerpt & full content

- (IBAction)infoTapped:(id)sender {
    [self toggleContent];
}

- (void)toggleContent {
    self.fullContentShown = !self.fullContentShown;
    self.contentTextView.attributedString = [self attributedStringForHTML:self.fullContentShown ? self.card.fullContent : self.card.excerpt];
    [self dumpContentTextAsRangeText];
    [self dumpContentTextAsHtml];
}


-(void)dumpContentTextAsRangeText {
    NSMutableString *dumpOutput = [[NSMutableString alloc] init];
    NSDictionary *attributes = nil;
    NSRange effectiveRange = NSMakeRange(0, 0);

    if ([self.contentTextView.attributedString length]) {

        while ((attributes = [self.contentTextView.attributedString attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange])) {
            [dumpOutput appendFormat:@"Range: (%d, %d), %@\n\n", effectiveRange.location, effectiveRange.length, attributes];
            effectiveRange.location += effectiveRange.length;

            if (effectiveRange.location >= [self.contentTextView.attributedString length]) {
                break;
            }
        }
    }
    XBLog(@"Range Text: %@", dumpOutput);
}

-(void)dumpContentTextAsHtml {
    NSString *dumpOutput = [self.contentTextView.attributedString htmlString];
    XBLog(@"Html: %@", dumpOutput);
}


#pragma mark - QRCode related stuff

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

#pragma mark - ContentView related stuff

- (NSAttributedString *)attributedStringForHTML:(NSString *)html
{
    // Load HTML data
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];

    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);

    NSDictionary *options = @{
            DTMaxImageSize: [NSValue valueWithCGSize:maxImageSize],
            DTDefaultFontFamily: @"Helvetica",
            DTDefaultFontSize: @14.0,
            DTDefaultTextColor: [UIColor colorWithHex:@"#FFFFFF"],
            DTDefaultLinkColor: @"purple",
            DTDefaultLinkHighlightColor: @"red",
            DTWillFlushBlockCallBack: ^(DTHTMLElement *element) {
                XBLog(@"Element: %@", element.attributedString);
            },
            DTUseiOS6Attributes: @NO
    };

    DTHTMLAttributedStringBuilder*attributedStringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data
                                                                                options: options
                                                                     documentAttributes:nil];

    NSAttributedString *attributedString = [attributedStringBuilder generatedAttributedString];

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