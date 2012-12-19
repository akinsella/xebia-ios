//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface EBVenue : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *postal_code;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSString *country_code;

@end