//
//  XBShareInfo.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 05/12/12.
//  Copyright (c) 2012 Xebia. All rights reserved.
//

#import "XBShareInfo.h"

@implementation XBShareInfo

-(id)initWithUrl:(NSString *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        self.url = url;
        self.title = title;
    }
    return self;
}

+(XBShareInfo *)shareInfoWithUrl:(NSString *)url title:(NSString *)title {
    return [[XBShareInfo alloc] initWithUrl:url title:title];
}

@end
