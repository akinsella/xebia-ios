//
//  XBShareInfo.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 05/12/12.
//  Copyright (c) 2012 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBShareInfo : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;

+(XBShareInfo *)shareInfoWithUrl:(NSString *)url title:(NSString *)title;

@end
