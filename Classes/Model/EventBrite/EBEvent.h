//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBVenue.h"
#import "EBOrganizer.h"
#import "XBMappingProvider.h"

@interface EBEvent : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *capacity;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *timezoneOffset;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *privacy;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSString *descriptionPlainText;
@property (nonatomic, strong) EBVenue *venue;
@property (nonatomic, strong) EBOrganizer *organizer;

- (BOOL)isCompleted;

@end