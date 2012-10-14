//
//  TTTweetMessageView.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 12/10/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface TTTweetMessageView : UIView

@property (retain, nonatomic) NSString* font;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property(nonatomic, strong) NSString *content;

@end
