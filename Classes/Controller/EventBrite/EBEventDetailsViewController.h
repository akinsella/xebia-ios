//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//

#import "EBEvent.h"
#import "XBViewController.h"

@interface EBEventDetailsViewController : XBViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;

@property(nonatomic, strong)EBEvent *event;

- (void)updateWithEvent:(EBEvent *)event;

@end