//
// Created by akinsella on 07/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBLeftMenuViewController.h"
#import "XBMainViewController.h"
#import "NSNumber+XBAdditions.h"
#import "XBLeftMenuCell.h"
#import "UIViewController+XBAdditions.h"
#import "GAITracker.h"
#import "UIColor+XBAdditions.h"
#import "XBNavigableViewController.h"
#import "IASKAppSettingsViewController.h"
#import "UIViewController+MJPopupViewController.h"

// Enum for row indices
enum {
    XBMenuHome = 0,
    XBMenuWordpress,
    XBMenuTwitter,
    /*XBMenuGithub,*/
    XBMenuEvent,
    XBMenuVimeo,
    XBMenuParameters
};

@interface XBLeftMenuViewController ()
@property (nonatomic, strong) NSMutableDictionary *viewIdentifiers;
@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;
@end

@implementation XBLeftMenuViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/leftMenu"];

    self.delegate = self;


    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 22, 22);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"19-gear"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealPreferences) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:@"#81247A" alpha:1.0];

    [self initViewIdentifiers];
    [self configureTableView];

    [super viewDidLoad];
}

-(void)revealPreferences {
    if (!self.appSettingsViewController) {
        self.appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
        self.appSettingsViewController.delegate = self;
        self.appSettingsViewController.showCreditsFooter = NO;
        self.appSettingsViewController.showDoneButton = YES;
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];

    [self.appDelegate.mainViewController presentPopupViewController:navigationController
                                                      animationType:MJPopupViewAnimationSlideBottomTop];
}

-(void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}

- (void)initViewIdentifiers {
    self.viewIdentifiers = [@{
            [NSNumber asString:XBMenuHome]: @"home",
            [NSNumber asString:XBMenuWordpress]: @"tbBlog",
            [NSNumber asString:XBMenuTwitter]: @"tweets",
           /* [NSNumber asString:XBMenuGithub]: @"tbGithub",*/
            [NSNumber asString:XBMenuEvent]: @"events",
            [NSNumber asString:XBMenuVimeo]: @"videos"
                            
    } mutableCopy];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"XBLeftMenu";

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBLeftMenuCell";
}

- (XBArrayDataSource *)buildDataSource {
    NSArray * menuItems = @[
            @{ @"title": @"Home", @"imageName" :@"home"},
            @{ @"title": @"Blog", @"imageName" :@"wordpress"},
            @{ @"title": @"Tweets", @"imageName" :@"twitter"},
            /*@{ @"title": @"GitHub", @"imageName" :@"github"},*/
            @{ @"title": @"Events", @"imageName" :@"eventbrite-menu"},
            @{ @"title": @"Vimeo", @"imageName" :@"vimeo"}
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
    [self revealViewControllerWithIdentifier:identifier withPath: nil];
}

- (void)revealAndReplaceViewController:(UIViewController *)viewController {

    UINavigationController *navigationController = (UINavigationController *)self.navigationController.revealController.frontViewController;
    [navigationController setViewControllers: @[viewController] animated:NO];

    [self.navigationController.revealController setFrontViewController:self.navigationController.revealController.frontViewController
                                                      focusAfterChange:YES completion:^(BOOL finished) { }];

}

- (void)revealViewControllerWithIdentifier:(NSString *)identifier withPath:(NSString *)path {
    if ([self currentViewIsViewControllerWithIdentifier: identifier]) {
        [self.navigationController.revealController resignPresentationModeEntirely:YES
                                                                          animated:YES
                                                                        completion:^(BOOL finished) { }];
    }
    else {
        UIViewController * viewController = [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier: identifier];

        UINavigationController *navigationController = (UINavigationController *)self.navigationController.revealController.frontViewController;
        [navigationController setViewControllers: @[viewController] animated:NO];

        if (path && [viewController conformsToProtocol:@protocol(XBNavigableViewController)]) {
            [(id<XBNavigableViewController>)viewController navigateToPath:path];
        }

        [self.navigationController.revealController setFrontViewController:self.navigationController.revealController.frontViewController
                                                          focusAfterChange:YES completion:^(BOOL finished) { }];
    }
}

-(BOOL)currentViewIsViewControllerWithIdentifier:(NSString *)identifier {
    return ((UINavigationController *)self.revealController.frontViewController).topViewController == [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:identifier];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
