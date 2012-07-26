//
//  RKWPTagCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKWPTagCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *bottomDetailLabel;

@property (nonatomic, assign) NSInteger itemCount;

@end
