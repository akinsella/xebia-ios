//
// Created by Simone Civetta on 02/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XBMenuSectionView : UIView

+ (instancetype)sectionViewWithTitle:(NSString *)title;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end