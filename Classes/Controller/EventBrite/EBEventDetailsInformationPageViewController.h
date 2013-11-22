//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "EBEvent.h"

@interface EBEventDetailsInformationPageViewController : UIViewController

@property(nonatomic, strong)EBEvent *event;

- (id)initWithEvent:(EBEvent *)event;

@end