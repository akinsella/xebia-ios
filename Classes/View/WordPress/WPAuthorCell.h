//
//  WPAuthorCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPAuthor.h"
#import "XBTableViewCell.h"

@interface WPAuthorCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong, readonly) WPAuthor *author;

- (void)updateWithAuthor:(WPAuthor *)author;

@end
