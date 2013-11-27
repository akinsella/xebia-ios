//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "EBEventDetailsInformationPageViewController.h"
#import "EBEvent.h"

@implementation EBEventDetailsInformationPageViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/events/%@/information", self.event.identifier];
}

- (id)initWithEvent:(EBEvent *)event {
    self = [super init];
    if (self) {
        self.event = event;
    }

    return self;
}

@end