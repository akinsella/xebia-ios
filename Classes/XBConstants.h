//
//  XBConstants.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 03/11/12.
//  Copyright (c) 2012 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

// Prefs.h
extern CGFloat const FONT_SIZE;
extern NSString * const FONT_NAME;
extern CGFloat const CELL_BORDER_WIDTH; // 320.0f - 232.0f
extern CGFloat const CELL_MIN_HEIGHT;
extern CGFloat const CELL_BASE_HEIGHT;

extern NSString * const kXBBlogFranceEmail;
extern NSString * const kXBBaseUrl;

extern NSString * const XBNetworkStatusChanged;

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)


#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options: NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options: NSNumericSearch] != NSOrderedAscending)
