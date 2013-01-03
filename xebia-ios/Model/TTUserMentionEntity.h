//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "TTIndices.h"

@interface TTUserMentionEntity : NSManagedObject

@property(nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *identifier_str;
@property(nonatomic, strong) NSString *screen_name;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) TTIndices *indices;

@end