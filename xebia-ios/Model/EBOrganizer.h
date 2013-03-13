//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XBMappingProvider.h"

@interface EBOrganizer : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSString *name;

@end