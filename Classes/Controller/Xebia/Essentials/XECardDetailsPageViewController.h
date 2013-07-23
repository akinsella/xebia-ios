//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XECard.h"
#import "DTAttributedTextView.h"

@interface XECardDetailsPageViewController : UIViewController<DTAttributedTextContentViewDelegate>

@property(nonatomic, strong, readonly)XECard *card;
@property(nonatomic, strong) IBOutlet UIButton *qrCodeImage;
@property(nonatomic, strong) IBOutlet DTAttributedTextView *contentTextView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *titleBackgroundView;
@property (nonatomic, strong) IBOutlet UIView *descriptionBackgroundView;

@property (nonatomic, strong) IBOutlet UIView *stripeView;
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) IBOutlet UILabel *identifierLabel;

-(IBAction)infoTapped:(id)sender;

-(IBAction)qrCodeTapped:(id)sender;

- (id)initWithCard:(XECard *)card;

@end