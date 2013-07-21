//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECardDetailsQRCodePageViewController.h"
#import "UIViewController+XBAdditions.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"

@interface XECardDetailsQRCodePageViewController()
@property(nonatomic, strong)XECard *card;
@end

@implementation XECardDetailsQRCodePageViewController

// load the view nib and initialize the pageNumber ivar
- (id)init
{
    if (self = [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"cardDetailsQRCodePage"]) {

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.card) {
        NSError* error = nil;
        ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:@"A string to encode"
                                      format:kBarcodeFormatQRCode
                                       width:248
                                      height:248
                                       error:&error];
        if (result) {
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            self.qrCodeImage.imageView.image = [[UIImage alloc] initWithCGImage:image];
        } else {
            NSString* errorMessage = [error localizedDescription];
        }
    }
}

- (void)updateWithCard:(XECard *)card {
    [super updateWithCard:card];
}

@end