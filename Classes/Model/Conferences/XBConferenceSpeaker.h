//
// Created by Simone Civetta on 26/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


@interface XBConferenceSpeaker : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSArray *talks;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *tweetHandle;
@property (nonatomic, strong) NSString *name;

@end