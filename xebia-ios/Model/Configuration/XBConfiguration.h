//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface XBConfiguration : NSObject

@property(nonatomic, strong, readonly) NSString *baseUrl;

+ (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)initWithBaseUrl:(NSString *)baseUrl;

+ (id)configurationWithBaseUrl:(NSString *)baseUrl;


@end