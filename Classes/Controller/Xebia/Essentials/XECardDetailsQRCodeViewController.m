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

-(void)viewWillAppear:(BOOL)animated {

    self.view.backgroundColor = [UIColor colorWithHex: self.card.category.backgroundColor];

    self.identifierTitle.text = self.card.identifierFormatted;
    
//    [self layoutSubViews];
    
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

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [self layoutSubViews];
//}

//-(void) layoutSubViews {
//    self.qrCodeParentView.frame = CGRectMake(
//            (self.view.frame.size.width - self.qrCodeParentView.frame.size.width) / 2,
//            (self.view.frame.size.height - self.qrCodeParentView.frame.size.height) / 2,
//            self.qrCodeParentView.frame.size.width,
//            self.qrCodeParentView.frame.size.height
//    );
//}

- (void)updateWithCard:(XECard *)card {
    self.card = card;
}

@end