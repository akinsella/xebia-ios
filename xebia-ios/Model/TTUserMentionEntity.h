//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TTEntity.h"

@interface TTUserMentionEntity : TTEntity

@property(nonatomic, strong) NSString *screen_name;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSArray *indices;

@end