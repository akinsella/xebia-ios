//
//  XBConferenceRoomCell.h
//  Xebia
//
//  Created by Simone Civetta on 26/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBTableViewCell.h"

@class XBConferenceRoom;

@interface XBConferenceRoomCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *capacityLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

- (void)configureWithRoom:(XBConferenceRoom *)room;

@end
