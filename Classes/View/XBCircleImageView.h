//
//  XBCircleImageView.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 11/09/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBCircleImageView : UIView

@property(nonatomic, strong)UIImage *backgroundImage;
@property(nonatomic, assign)CGFloat offset;
@property(nonatomic, strong)UIImage *defaultImage;
@property(nonatomic, strong)UIImage *image;

@end
