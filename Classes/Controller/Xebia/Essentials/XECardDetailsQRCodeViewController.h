//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XECard.h"
#import "XECardDetailsPageViewController.h"

@interface XECardDetailsQRCodeViewController : UIViewController

@property(nonatomic, strong, readonly) XECard *card;

@property(nonatomic, strong)IBOutlet UIImageView *qrCodeImageView;
@property(nonatomic, strong)IBOutlet UILabel *identifierTitle;

-(void)updateWithCard:(XECard *)card;

@end