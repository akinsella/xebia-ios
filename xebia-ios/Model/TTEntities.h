//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface TTEntities : NSObject

@property(nonatomic, strong) NSArray *hashtags;
@property(nonatomic, strong) NSArray *urls;
@property(nonatomic, strong) NSArray *user_mentions;

+ (RKObjectMapping *)mapping;

@end