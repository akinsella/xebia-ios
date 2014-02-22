//
//  XBConferencePresentationCell.h
//  Xebia
//
//  Created by Simone Civetta on 16/02/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBTableViewCell.h"

@class XBConferencePresentation;

@interface XBConferencePresentationCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *speakerLabel;

- (void)configureWithPresentation:(XBConferencePresentation *)presentation;

@end
