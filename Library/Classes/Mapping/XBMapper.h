//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol XBMappingProvider;


@interface XBMapper : NSObject

+(NSString *) objectToSerializedJson:(id)obj;
+ (NSString *)objectToSerializedJson:(id)obj withDateFormat:(NSString *)dateFormat;

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;
+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj withDateFormat:(NSString *) dateFormat;

+ (NSArray *)parseArray:(NSArray*)objectArray intoObjectsOfType:(Class<XBMappingProvider>)objectClass;
+ (id)parseObject:(NSDictionary*)objectDictionary intoObjectsOfType:(Class<XBMappingProvider>)objectClass;


@end