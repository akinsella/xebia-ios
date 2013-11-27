//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <ZXingObjC/ZXEncodeHints.h>
#import "XECardDetailsQRCodeViewController.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "XECategory.h"
#import "UIColor+XBAdditions.h"
#import "UIViewController+XBAdditions.h"

@interface XECardDetailsQRCodeViewController ()
@property(nonatomic, strong)XECard *card;
@end

@implementation XECardDetailsQRCodeViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/cards/categories/%@/%@/qr-code", self.card.category.identifier, self.card.identifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.qrCodeImageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.qrCodeImageView addGestureRecognizer:singleTap];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self.appDelegate.mainViewController dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {

    self.view.backgroundColor = [UIColor colorWithHex: self.card.category.backgroundColor];

    self.identifierTitle.text = self.card.identifierFormatted;

    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXEncodeHints *hints = [[ZXEncodeHints alloc] init];
    hints.margin = @2;
    ZXBitMatrix* result = [writer encode:[self.card.url absoluteString]
                                  format:kBarcodeFormatQRCode
                                   width:248
                                  height:248
                                   hints:hints
                                   error:&error];
    if (result) {
        CGImageRef imageRef = [[ZXImage imageWithMatrix:result] cgimage];
        UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];

        self.qrCodeImageView.image = image;
    }
    else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }

    self.navigationController.navigationBarHidden = NO;
}

- (void)updateWithCard:(XECard *)card {
    self.card = card;
}

@end