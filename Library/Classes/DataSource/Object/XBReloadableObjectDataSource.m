//
// Created by Simone Civetta on 5/30/13.
//


#import "XBObjectDataSource+Protected.h"
#import "XBReloadableObjectDataSource.h"
#import "XBDataLoader.h"


@interface XBReloadableObjectDataSource()

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id <XBDataLoader> dataLoader;

@end


@implementation XBReloadableObjectDataSource

- (instancetype)initWithDataLoader:(id <XBDataLoader>)dataLoader
{
    self = [super init];
    if (self) {
        self.dataLoader = dataLoader;
    }

    return self;
}

+ (instancetype)dataSourceWithDataLoader:(id <XBDataLoader>)dataLoader
{
    return [[self alloc] initWithDataLoader:dataLoader];
}

- (void)loadData
{
    [self loadData:nil];
}

- (void)loadData:(XBReloadableObjectDataSourceCompletionBlock)callback {
    [self.dataLoader loadDataWithSuccess:^(id data) {
        self.error = nil;
        [self processSuccessForResponseObject:data callback:^{
            if (callback) {
                callback();
            }
        }];
    } failure:^(NSError *error) {
        self.error = error;
        if (callback) {
            callback();
        }
    }];
}

- (void)processSuccessForResponseObject:(id)responseObject callback:(void (^)())callback
{
    self.object = responseObject;
    if (callback) {
        callback();
    }
}

@end