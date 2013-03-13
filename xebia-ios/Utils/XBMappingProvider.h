//
// Created by akinsella on 13/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DCKeyValueObjectMapping.h";

@protocol XBMappingProvider <NSObject>

@required
+(DCKeyValueObjectMapping *)mappings;

@end