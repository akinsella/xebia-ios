//
//  XBConferenceTrackCell.h
//  Xebia
//
//  Created by Simone Civetta on 09/02/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBTableViewCell.h"

@class XBConferenceTrack;
@class DTAttributedTextContentView;

@interface XBConferenceTrackCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet DTAttributedTextContentView *descriptionLabel;

- (void)configureWithTrack:(XBConferenceTrack *)track;

@end
