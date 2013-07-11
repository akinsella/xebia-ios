//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XECard.h"
#import "DTAttributedLabel.h"

@interface XECardDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet DTAttributedLabel *descriptionLabel;

@property(nonatomic, strong)XECard *card;

@end