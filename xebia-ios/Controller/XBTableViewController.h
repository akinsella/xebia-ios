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

- (NSString *)resourcePath;

- (NSArray *)fetchDataFromDB;

- (void)configureCell: (UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath;

@optional

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath;

@end

@interface XBTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<XBTableViewControllerDelegate> delegate;

- (id)objectAtIndex:(NSUInteger)index;

@end
