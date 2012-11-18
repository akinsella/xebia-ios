//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "EBVenue.h"
#import "EBOrganizer.h"

@interface EBEvent : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *capacity;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *start_date;
@property (nonatomic, strong) NSDate *end_date;
@property (nonatomic, strong) NSString *timezone_offset;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *privacy;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSString *description_plain_text;
@property (nonatomic, strong) EBVenue *venue;
@property (nonatomic, strong) EBOrganizer *organizer;

+ (RKObjectMapping *)mapping;

@end