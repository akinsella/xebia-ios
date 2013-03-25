//
// Created by akinsella on 19/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBHttpArrayDataSource.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "XBHttpClient.h"
#import "XBConfigurationProvider.h"

@protocol XBTableViewControllerDelegate<NSObject>

@required

- (NSString *)cellReuseIdentifier;

- (NSString *)cellNibName;

- (void)configureCell: (UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath;

-(XBHttpArrayDataSourceConfiguration *)configuration;

@optional

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath;

@end

@interface XBTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
    XBHttpArrayDataSource *_dataSource;
}

@property (nonatomic, strong) id<XBTableViewControllerDelegate> delegate;
@property(nonatomic, strong, readonly) XBHttpArrayDataSource *dataSource;
@property(nonatomic, strong, readonly) XBConfigurationProvider *configurationProvider;

@end
