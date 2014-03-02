//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBHttpClient.h"
#import "Reachability.h"

@interface XBConfigurationProvider : NSObject

@property(nonatomic, strong, readonly)NSString *baseUrl;
@property(nonatomic, strong, readonly) XBHttpClient *httpClient;

+(id)configurationWithDictionary:(NSDictionary *)dictionary;
-(id)initWithDictionary:(NSDictionary *)dictionary;

+ (id)configurationProviderWithBaseUrl:(NSString *)string;

@end