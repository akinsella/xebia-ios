//
// Created by Alexis Kinsella on 22/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import "WPPostContentImageElementCell.h"

@interface WPPostContentImageElementCell()

@property (nonatomic, strong)UIImage *placeholderImage;

@end

@implementation WPPostContentImageElementCell

- (void)configure {

    [super configure];

    self.placeholderImage = [UIImage imageNamed:@"image-placeholder"];

//    self.imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    tgr.numberOfTapsRequired = 1;
//    tgr.delegate = self;
//    [self.imageView addGestureRecognizer:tgr];

}

//- (void)handleTap:(UITapGestureRecognizer *)tagGestureRecognizer {
//    [UIView animateWithDuration:0.5f animations:^{
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        CGFloat screenWidth = screenRect.size.width;
//        CGFloat screenHeight = screenRect.size.height;
//        self.imageView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
//        self.imageView.contentMode = UIViewContentModeCenter;
//        self.imageView.backgroundColor = [UIColor blackColor];
//
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    }];
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement:element];

    __weak typeof(self) weakSelf = self;

    NSString *imageSrc = [self.element[@"src"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


    XBLog(@"Loading image with URL: '%@'", imageSrc);
    [self.imageView setImageWithURL:[NSURL URLWithString:imageSrc]
               placeholderImage: self.placeholderImage
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           if (error || !image) {
                               XBLog(@"Error: %@", error);
                           }
                           else {
                               if (!weakSelf.heightImageCache[imageSrc]) {
                                   weakSelf.heightImageCache[imageSrc] = @(image.size.height);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [weakSelf.delegate reloadCellForElement:weakSelf.element];
                                   });
                               }
                           }
                          [weakSelf layoutSubviews];
                       }];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat maxImageWidth =  MIN(self.frame.size.width, self.imageView.image.size.width);

    CGRect imageFrame = CGRectMake(
            (self.frame.size.width - maxImageWidth) / 2,
            0,
            maxImageWidth,
            maxImageWidth * self.imageView.image.size.height / self.imageView.image.size.width
    );

    self.imageView.frame = imageFrame;

    // Update cell frame
    self.frame = CGRectMake(
            self.frame.origin.x,
            self.frame.origin.y,
            self.frame.size.width,
            self.imageView.image.size.height
    );
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    NSString *imageSrc = self.element[@"src"];
    NSNumber *height = self.heightImageCache[imageSrc];

    return (height ? [height integerValue] : self.placeholderImage.size.height);
}

@end