//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "TTIndices.h"
#import "XBMappingProvider.h"

@interface TTHashtagEntity : NSObject<XBMappingProvider>

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) TTIndices *indices;

@end