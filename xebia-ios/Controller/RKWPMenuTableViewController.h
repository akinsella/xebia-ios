//
//  RKWPMenuTableViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import <UIKit/UIKit.h>
#import <RestKit/UI.h>

@interface RKWPMenuTableViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end
