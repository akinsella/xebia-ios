//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBHttpClient.h"

@interface XBConfigurationProvider : NSObject

@property(nonatomic, strong, readonly)NSString *baseUrl;
@property(nonatomic, strong, readonly) XBHttpClient *httpClient;

+(id)configurationWithDictionnary:(NSDictionary *)dictionary;
-(id)initWithDictionnary:(NSDictionary *)dictionary;

+ (id)configurationProviderWithBaseUrl:(NSString *)string;

@end