//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface EBOrganizer : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSString *name;

@end