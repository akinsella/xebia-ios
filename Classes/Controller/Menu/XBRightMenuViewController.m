//
// Created by akinsella on 07/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBRightMenuViewController.h"
#import "XBMainViewController.h"
#import "NSNumber+XBAdditions.h"
#import "XBLeftMenuCell.h"
#import "XBAppDelegate.h"
#import "UIViewController+XBAdditions.h"
#import "GAITracker.h"


// Enum for row indices
enum {
    XBMenuXebiaEssentials = 0
};

@interface XBRightMenuViewController()
@property (nonatomic, strong) NSMutableDictionary *viewIdentifiers;
@end

@implementation XBRightMenuViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [self.appDelegate.tracker sendView:@"/rightMenu"];
    
    self.delegate = self;
    [self initViewIdentifiers];
    [self configureTableView];
    
    [super viewDidLoad];
}

- (void)initViewIdentifiers {
    self.viewIdentifiers = [@{
       [@(XBMenuXebiaEssentials) asString]: @"cardCategories"

    } mutableCopy];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"XBRightMenu";
    
    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"XBRightMenuCell";
}

- (XBArrayDataSource *)buildDataSource {
    NSArray * menuItems = @[
        @{ @"title": @"Xebia Essentials", @"imageName" :@"xebia-essentials-card" },
    ];
    
    return [XBArrayDataSource dataSourceWithArray:menuItems];
}

- (void)configureTableView {
    //    [super configureTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.navigationItem.titleView = [UIImageView initWithImageNamed:@"Xebia-Logo"];
    UIView*backgroundView = [[UIView alloc] initWithFrame: self.tableView.bounds];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blackorchid.png"]]];
    [self.tableView setBackgroundView:backgroundView];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    
    XBLeftMenuCell *menuCell = (XBLeftMenuCell *)cell;
    
    NSDictionary *item = self.dataSource[(NSUInteger) indexPath.row];
    
    menuCell.accessoryType = UITableViewCellAccessoryNone;
    menuCell.titleLabel.text = [item objectForKey:@"title"];
    menuCell.imageView.image = [UIImage imageNamed:[item objectForKey:@"imageName"]];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *identifier = [self.viewIdentifiers valueForKey:[NSNumber asString:indexPath.row]];
    [self revealViewControllerWithIdentifier: identifier];
}

-(void)revealViewControllerWithIdentifier:(NSString *)identifier {
    if ([self currentViewIsViewControllerWithIdentifier: identifier]) {
        [self.navigationController.revealController resignPresentationModeEntirely:YES
                                                                          animated:YES
                                                                        completion:^(BOOL finished) { }];
    }
    else {
        UIViewController * viewController = [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier: identifier];
        UINavigationController *navigationController = (UINavigationController *)self.navigationController.revealController.frontViewController;
        [navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
        [self.navigationController.revealController setFrontViewController:self.navigationController.revealController.frontViewController
                                                          focusAfterChange:YES completion:^(BOOL finished) { }];
    }
}

-(BOOL)currentViewIsViewControllerWithIdentifier:(NSString *)identifier {
    return ((UINavigationController *)self.revealController.frontViewController).topViewController == [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:identifier];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


@end
