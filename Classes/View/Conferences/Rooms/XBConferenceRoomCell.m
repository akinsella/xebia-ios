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
    self.nameLabel.text = room.name;
    self.capacityLabel.text = [NSString stringWithFormat:@"%d persons", [room.capacity integerValue]];
}

@end