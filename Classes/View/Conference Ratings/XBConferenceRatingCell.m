//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingCell.h"
#import "XBConferenceRating.h"
#import "XBConferencePresentation.h"


@implementation XBConferenceRatingCell

- (void)configureWithRating:(XBConferenceRating *)rating presentation:(XBConferencePresentation *)presentation {
    self.presentationTitleLabel.text = presentation.title;
    if (rating.value) {
        self.ratingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rating-star-value-%d", rating.value.intValue]];
    } else {
        self.ratingImageView.image = nil;
    }

}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 8 + self.presentationTitleLabel.intrinsicContentSize.height + 8;
}

@end