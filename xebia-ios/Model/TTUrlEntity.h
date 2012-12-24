//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TTEntity.h"


@interface TTUrlEntity : TTEntity

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *expanded_url;
@property(nonatomic, strong) NSString *display_url;
@property (nonatomic, strong) NSArray *indices;

@end