//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECardDetailsViewController.h"
#import "XECard.h"
#import "XECardFront.h"
#import "XECardBack.h"


@implementation XECardDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    if (self.card) {
    }
}

-(void)setCard:(XECard *)card {
    _card = card;
    self.title = card.front.para;

}

- (void)updateView {
    self.titleLabel.text = self.card.front.para;
    self.descriptionLabel.text = self.card.back.para;

}

@end