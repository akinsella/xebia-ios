//
//  XBConferenceRoomCell.m
//  Xebia
//
//  Created by Simone Civetta on 26/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRoomCell.h"
#import "XBConferenceRoom.h"
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSString+XBAdditions.h"

@implementation XBConferenceRoomCell

- (void)configureWithRoom:(XBConferenceRoom *)room {
    self.locationLabel.text = room.locationName;
    self.locationLabel.highlightedTextColor = [UIColor whiteColor];
    self.nameLabel.text = room.name;
    self.nameLabel.highlightedTextColor = [UIColor whiteColor];
    self.capacityLabel.text = [room.capacity intValue] > 0 ? [NSString stringWithFormat:@"%d %@", [room.capacity integerValue], NSLocalizedString(@"persons", @"persons")] : @"";
    self.capacityLabel.highlightedTextColor = [UIColor whiteColor];
}

@end
