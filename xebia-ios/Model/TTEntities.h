//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


@interface TTEntities : NSObject<XBMappingProvider>

@property(nonatomic, strong) NSArray *hashtags;
@property(nonatomic, strong) NSArray *urls;
@property(nonatomic, strong) NSArray *user_mentions;

@end