//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "TTIndices.h"

@interface TTUrlEntity : NSObject<XBMappingProvider>

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *expanded_url;
@property(nonatomic, strong) NSString *display_url;
@property(nonatomic, strong) TTIndices *indices;

@end