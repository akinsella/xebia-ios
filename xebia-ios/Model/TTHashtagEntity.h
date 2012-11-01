//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TTEntity.h"

@interface TTHashtagEntity : TTEntity

@property(nonatomic, strong) NSString *text;

+ (RKObjectMapping *)mapping;

@end