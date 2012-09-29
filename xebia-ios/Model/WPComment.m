//
//  WPComment.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPComment.h"

@implementation WPComment

@synthesize identifier;
@synthesize name;
@synthesize url;
@synthesize date;
@synthesize content;
@synthesize parent;

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {

    }];

    return mapping;
}

@end
