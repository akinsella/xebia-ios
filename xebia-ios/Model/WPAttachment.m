//
//  WPAttachment.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPAttachment.h"

@implementation WPAttachment

@synthesize identifier;
@synthesize url;
@synthesize slug;
@synthesize title;
@synthesize description_;
@synthesize caption;
@synthesize mime_type;
@synthesize parent;

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {

    }];

    return mapping;
}


@end
