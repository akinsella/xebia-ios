//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBNewsViewLayout.h"
#import "XBNewsEmblemView.h"

static NSString * const XBNewsViewLayoutCellKind = @"XBNewsCell";
NSString * const XBNewsLayoutAlbumTitleKind = @"AlbumTitle";
static NSString * const XBNewsEmblemKind  = @"Emblem";

@interface XBNewsViewLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic) CGFloat titleHeight;

@end

@implementation XBNewsViewLayout

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup {
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 12.0f;
    self.numberOfColumns = 2;
    self.titleHeight = 26.0f;
    [self registerClass:[XBNewsEmblemView class] forDecorationViewOfKind:XBNewsEmblemKind];

}

#pragma mark - Layout

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfo = [NSMutableDictionary dictionary];

    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];


    UICollectionViewLayoutAttributes *emblemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:XBNewsEmblemKind
                                                                        withIndexPath:indexPath];
    emblemAttributes.frame = [self frameForEmblem];

    newLayoutInfo[XBNewsEmblemKind] = @{indexPath: emblemAttributes};


    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];

        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];

            UICollectionViewLayoutAttributes *itemAttributes =
                    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];

            cellLayoutInfo[indexPath] = itemAttributes;

            if (indexPath.item == 0) {
                UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes
                        layoutAttributesForSupplementaryViewOfKind:XBNewsLayoutAlbumTitleKind
                                                     withIndexPath:indexPath];
                titleAttributes.frame = [self frameForAlbumTitleAtIndexPath:indexPath];

                titleLayoutInfo[indexPath] = titleAttributes;
            }
        }
    }

    newLayoutInfo[XBNewsViewLayoutCellKind] = cellLayoutInfo;
    newLayoutInfo[XBNewsLayoutAlbumTitleKind] = titleLayoutInfo;

    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameForAlbumTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;

    return frame;
}
#pragma mark - Private

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;

    CGFloat spacingX = self.collectionView.bounds.size.width -
            self.itemInsets.left -
            self.itemInsets.right -
            (self.numberOfColumns * self.itemSize.width);

    if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns - 1);

    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);

    CGFloat originY = (CGFloat) floor(self.itemInsets.top +
                (self.itemSize.height + self.titleHeight + self.interItemSpacingY) * row);

    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];

    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
            NSDictionary *elementsInfo,
            BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                UICollectionViewLayoutAttributes *attributes,
                BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];

    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[XBNewsViewLayoutCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    // make sure we count another row if one is only partially filled
    if ([self.collectionView numberOfSections] % self.numberOfColumns) rowCount++;

    CGFloat height = self.itemInsets.top +
            rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY +
            rowCount * self.titleHeight +
            self.itemInsets.bottom;

    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

#pragma mark - Properties

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;

    _itemInsets = itemInsets;

    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;

    _itemSize = itemSize;

    [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY) return;

    _interItemSpacingY = interItemSpacingY;

    [self invalidateLayout];
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns == numberOfColumns) return;

    _numberOfColumns = numberOfColumns;

    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight
{
    if (_titleHeight == titleHeight) return;

    _titleHeight = titleHeight;

    [self invalidateLayout];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[XBNewsLayoutAlbumTitleKind][indexPath];
}

- (CGRect)frameForEmblem
{
    CGSize size = [XBNewsEmblemView defaultSize];

    CGFloat originX = floorf((self.collectionView.bounds.size.width - size.width) * 0.5f);
    CGFloat originY = -size.height - 30.0f;

    return CGRectMake(originX, originY, size.width, size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:
        (NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[XBNewsEmblemKind][indexPath];
}

@end