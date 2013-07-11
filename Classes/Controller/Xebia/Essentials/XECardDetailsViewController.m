//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECardDetailsViewController.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"
#import "DTCoreText.h"

@implementation XECardDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.card) {
        [self.appDelegate.tracker sendView:[NSString stringWithFormat: @"/essentials/category/%@", self.card.identifier]];
    }
}

-(void)setCard:(XECard *)card {
    _card = card;
    self.title = card.title;

}

- (void)updateView {
    NSData *data = [self.card.description dataUsingEncoding:NSUTF8StringEncoding];

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data
                                                               documentAttributes:NULL];

    self.titleLabel.text = self.card.title;
    [self.descriptionLabel setAttributedString:attributedString];

}

@end