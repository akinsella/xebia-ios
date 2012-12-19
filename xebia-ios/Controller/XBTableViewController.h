//
// Created by akinsella on 19/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol XBTableViewControllerDelegate<NSObject>
@required

- (int)maxDataAgeInSecondsBeforeServerFetch;

- (Class)dataClass;

- (NSString *)cellReuseIdentifier;

- (NSString *)cellNibName;

- (NSString *)urlPath;

- (NSArray *)fetchDataFromDB;

- (void)configureCell: (UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath;

- (id)objectAtIndex:(NSUInteger)index1;

@end

@interface XBTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<XBTableViewControllerDelegate> delegate;


@end
