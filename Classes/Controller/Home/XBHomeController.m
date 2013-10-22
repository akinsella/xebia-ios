//
//  WPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBHomeController.h"
#import "UIViewController+XBAdditions.h"
#import "GAITracker.h"
#import "XBNewsCell.h"
#import "XBNewsViewLayout.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "XBNewsTitleReusableView.h"

static NSString * const XBNewsCellIdentifier = @"NewsCell";

@interface XBHomeController ()

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@end

@implementation XBHomeController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/home"];

    self.title = NSLocalizedString(@"Home", nil);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home_pattern-light"]];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.collectionView registerClass:[XBNewsCell class] forCellWithReuseIdentifier:XBNewsCellIdentifier];
    [self.collectionView registerClass:[XBNewsTitleReusableView class]
            forSupplementaryViewOfKind:XBNewsLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];

    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;




    self.albums = [NSMutableArray array];

    NSURL *urlPrefix =
            [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];

    NSInteger photoIndex = 0;

    for (NSInteger a = 0; a < 12; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %d",a + 1];

        NSUInteger photoCount = 1;
        for (NSInteger p = 0; p < photoCount; p++) {
            // there are up to 25 photos available to load from the code repository
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % 25];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];

            photoIndex++;
        }

        [self.albums addObject:album];
    }







    [self addMenuButton];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    BHAlbum *album = self.albums[(NSUInteger) section];

    return album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBNewsCell *newsCell =
            [collectionView dequeueReusableCellWithReuseIdentifier:XBNewsCellIdentifier
                                                      forIndexPath:indexPath];



    BHAlbum *album = self.albums[(NSUInteger) indexPath.section];
    BHPhoto *photo = album.photos[(NSUInteger) indexPath.item];

    // load photo images in the background
    __weak XBHomeController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];

        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                XBNewsCell *cell =
                (XBNewsCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];

    [self.thumbnailQueue addOperation:operation];


    return newsCell;
}
#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    XBNewsViewLayout *viewLayout = (XBNewsViewLayout *)self.collectionView.collectionViewLayout;

    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        viewLayout.numberOfColumns = 3;

        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;

        viewLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);

    }
    else {
        viewLayout.numberOfColumns = 2;
        viewLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    XBNewsTitleReusableView *titleView =
            [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                               withReuseIdentifier:AlbumTitleIdentifier
                                                      forIndexPath:indexPath];

    BHAlbum *album = self.albums[(NSUInteger) indexPath.section];

    titleView.titleLabel.text = album.name;

    return titleView;
}

@end