//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface TTEntity : NSObject

@property(nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *indices;

+ (RKObjectMapping *)mapping;

@end