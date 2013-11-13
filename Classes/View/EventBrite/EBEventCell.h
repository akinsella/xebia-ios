//
//  GHUserCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBEvent.h"
#import "TTTAttributedLabel.h"
#import "XBTableViewCell.h"

static CGFloat const MAX_CELL_HEIGHT = 240.0;

@interface EBEventCell : XBTableViewCell<TTTAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property(nonatomic, strong, readonly) EBEvent *event;

- (CGFloat)heightForCell:(UITableView *)tableView;

- (void)updateWithEvent:(EBEvent *)event;

@end
