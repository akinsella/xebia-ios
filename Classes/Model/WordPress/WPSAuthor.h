//
//  WPAuthor.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBMappingProvider.h"

@interface WPSAuthor : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *nickname;

@end
