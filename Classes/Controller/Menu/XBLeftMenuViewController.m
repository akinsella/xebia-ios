//
// Created by akinsella on 07/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Underscore.m/Underscore.h>
#import "XBLeftMenuViewController.h"
#import "XBMainViewController.h"
#import "NSNumber+XBAdditions.h"
#import "XBLeftMenuCell.h"
#import "UIViewController+XBAdditions.h"
#import "UIColor+XBAdditions.h"
#import "XBAbstractURLHandler.h"
#import "WPURLHandler.h"
#import "UIAlertView+XBAdditions.h"
#import "TTURLHandler.h"
#import "EBURLHandler.h"
#import "VMURLHandler.h"
#import "XBConference.h"
#import "XBConferenceDataSource.h"
#import "XBMenuSectionView.h"
#import "XBConstants.h"
#import "NSString+XBAdditions.h"
#import "XBConferenceHomeViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

// Enum for row indices
enum {
    XBMenuTimeline = 0,
    XBMenuWordpress,
    XBMenuTwitter,
    XBMenuEvent,
    XBMenuVimeo
};

@interface XBLeftMenuViewController ()
@property (nonatomic, strong) NSMutableDictionary *viewIdentifiers;
@property (nonatomic, strong) IASKAppSettingsViewController *appSettingsViewController;
@property (nonatomic, strong) NSArray *urlHandlers;
@property (nonatomic, strong) XBConferenceDataSource *conferenceDataSource;
@end

@implementation XBLeftMenuViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }

    return self;
}

- (void)initialize {

    self.urlHandlers = @[
        [[WPURLHandler alloc] init],
        [[TTURLHandler alloc] init],
        [[EBURLHandler alloc] init],
        [[VMURLHandler alloc] init]
    ];

    [super initialize];
}

- (NSString *)trackPath {
    return @"/leftMenu";
}

- (void)viewDidLoad {

    self.delegate = self;

    [self setupReachabilityMonitor];

    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 22, 22);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"19-gear"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealPreferences) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:@"#81247A" alpha:1.0];

    [self initViewIdentifiers];
    [self configureTableView];

    [self reloadConferences];

    [super viewDidLoad];
}

- (void)networkStatusChanged:(id)notification
{
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [self reloadConferences];
    }
}

- (void)setupReachabilityMonitor
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusChanged:)
                                                 name:XBNetworkStatusChanged
                                               object:nil];
}

- (void)revealPreferences {
    if (!self.appSettingsViewController) {
        self.appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
        self.appSettingsViewController.delegate = self;
        self.appSettingsViewController.showCreditsFooter = NO;
        self.appSettingsViewController.showDoneButton = YES;
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    [self.appDelegate.mainViewController presentViewController:navigationController animated:YES completion:^{}];
}

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)initViewIdentifiers {
    self.viewIdentifiers = [@{
            [NSNumber asString:XBMenuTimeline]: @"timeline",
            [NSNumber asString:XBMenuWordpress]: @"tbBlog",
            [NSNumber asString:XBMenuTwitter]: @"tweets",
            [NSNumber asString:XBMenuEvent]: @"events",
            [NSNumber asString:XBMenuVimeo]: @"videos"
                            
    } mutableCopy];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *CellReuseIdentifier = @"XBLeftMenu";
    static NSString *ConferenceCellReuseIdentifier = @"XBConference";
    
    switch (indexPath.section) {
        case 0:
            return CellReuseIdentifier;
            
        case 1:
            return ConferenceCellReuseIdentifier;

        default:
            break;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return @"XBLeftMenuCell";
            
        case 1:
            return @"XBConferenceCell";
            
        default:
            break;
    }
    
    return nil;
}

- (XBArrayDataSource *)buildDataSource {
    NSArray * menuItems = @[
            @{ @"title": NSLocalizedString(@"Timeline", nil), @"imageName" :@"timeline"},
            @{ @"title": NSLocalizedString(@"Blog", nil), @"imageName" :@"wordpress"},
            @{ @"title": NSLocalizedString(@"Tweets", nil), @"imageName" :@"twitter"},
            @{ @"title": NSLocalizedString(@"Events", nil), @"imageName" :@"eventbrite-menu"},
            @{ @"title": NSLocalizedString(@"Videos", nil), @"imageName" :@"vimeo"}
    ];

    if (!self.conferenceDataSource) {
        self.conferenceDataSource = [XBConferenceDataSource dataSource];
    }    
    return [XBArrayDataSource dataSourceWithArray:@[menuItems, self.conferenceDataSource]];
}

- (void)configureTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *backgroundView = [[UIView alloc] initWithFrame: self.tableView.bounds];
    [backgroundView setBackgroundColor:[UIColor colorWithHex:@"#222222"]];
    [self.tableView setBackgroundView:backgroundView];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XBLeftMenuCell *menuCell = (XBLeftMenuCell *)cell;
    id item = self.dataSource[indexPath.section][indexPath.row];

    menuCell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0) {
        menuCell.titleLabel.text = [item objectForKey:@"title"];
        menuCell.imageView.image = [UIImage imageNamed:[item objectForKey:@"imageName"]];
    } else {
        XBConference *conference = item;
        menuCell.titleLabel.text = [conference name];
        [menuCell.imageView setImageWithURL:[conference.logoUrl url] placeholderImage:nil];
    }
}

- (void)onSelectCell: (UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    NSString *identifier;
    if (indexPath.section == 0) {
        identifier = [self.viewIdentifiers valueForKey:[NSNumber asString:indexPath.row]];
    } else {
        identifier = XBConferenceHomeViewControllerIdentifier;
    }
    [self revealViewControllerWithIdentifier:identifier];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)revealAndReplaceViewController:(UIViewController *)viewController {

    UINavigationController *navigationController = (UINavigationController *)self.navigationController.mm_drawerController.centerViewController;
    [navigationController setViewControllers: @[viewController] animated:NO];
    [self.navigationController.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (void)revealViewControllerWithIdentifier:(NSString *)identifier {
    if ([self currentViewIsViewControllerWithIdentifier:identifier] && ![identifier isEqualToString:XBConferenceHomeViewControllerIdentifier]) {
        [self.navigationController.mm_drawerController closeDrawerAnimated:YES completion:nil];

    } else {
        UIViewController *viewController;
        if ([identifier isEqualToString:XBConferenceHomeViewControllerIdentifier]) {
            NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
            XBConference *conference = self.dataSource[indexPath.section][indexPath.row];
            viewController = [self.appDelegate.viewControllerManager getOrCreateConferenceControllerWithConference:conference];
        } else {
            viewController = [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:identifier];
        }

        UINavigationController *navigationController = (UINavigationController *)self.navigationController.mm_drawerController.centerViewController;
        [navigationController setViewControllers: @[viewController] animated:NO];
        [self.navigationController.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
}

- (void)revealViewControllerWithURL:(NSURL *)url {
    NSLog(@"url received: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);

    XBAbstractURLHandler *foundURLHandler = Underscore.array(self.urlHandlers).find(^BOOL(XBAbstractURLHandler *urlHandler) {
        return [urlHandler handleURL:url];
    });

    if (foundURLHandler) {
        [foundURLHandler processURL:url];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                   message:NSLocalizedString(@"No action for URL", nil)
                                  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)
                         otherButtonTitles:nil];
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {}];
    }
}

-(BOOL)currentViewIsViewControllerWithIdentifier:(NSString *)identifier {
    return ((UINavigationController *)self.mm_drawerController.centerViewController).topViewController == [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:identifier];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - Conferences

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = section == 0 ? @"Xebia" : NSLocalizedString(@"Conférences", @"Conférences");
    return [XBMenuSectionView sectionViewWithTitle:title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.conferenceDataSource count] ? 20.0 : 0;
}

- (void)reloadConferences {
    [self.conferenceDataSource loadDataWithCallback:^{
        [self.tableView reloadData];
    }];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
