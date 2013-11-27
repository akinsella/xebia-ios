//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "EBEventDetailsMapPageViewController.h"
#import "EBEvent.h"


@implementation EBEventDetailsMapPageViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/events/%@/map", self.event.identifier];
}

- (id)initWithEvent:(EBEvent *)event {
    self = [super init];
    if (self) {
        self.event = event;
    }

    return self;
}

@end