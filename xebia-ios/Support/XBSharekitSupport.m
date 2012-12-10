//
//  XBSharekitSupport.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 03/12/12.
//  Copyright (c) 2012 Xebia. All rights reserved.
//

#import "XBSharekitSupport.h"
#import "SHKConfiguration.h"
#import "XBSHKConfigurator.h"

@implementation XBSharekitSupport

+ (void) configure {
    //Here you load ShareKit submodule with app specific configuration
    DefaultSHKConfigurator *configurator = [[XBSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
}

@end
