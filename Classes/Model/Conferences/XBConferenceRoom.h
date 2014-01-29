//
//  XBConferenceRoom.h
//  Xebia
//
//  Created by Simone Civetta on 29/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"

@interface XBConferenceRoom : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *capacity;
@property (nonatomic, strong) NSString *locationName;

@end
