//
// Created by Alexis Kinsella on 07/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <DTCoreText/DTLinkButton.h>
#import <DTCoreText/DTHTMLElement.h>
#import <DTCoreText/DTHTMLAttributedStringBuilder.h>
#import <DTCoreText/DTAttributedTextContentView.h>
#import "WPPost.h"

@class DTAttributedTextView;
@protocol DTAttributedTextContentViewDelegate;

@interface WPPostDetailsViewControllerBack : UIViewController<UIActionSheetDelegate, DTAttributedTextContentViewDelegate>

@property(nonatomic, strong, readonly)WPPost *post;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet DTAttributedTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;

- (id)initWithPost:(WPPost *)post;

@end