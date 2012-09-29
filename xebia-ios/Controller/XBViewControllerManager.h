//
//  XBViewControllerManager.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import <Foundation/Foundation.h>


@interface XBViewControllerManager : NSObject

+ (id)sharedInstance;
-(UIViewController *)getOrCreateControllerWithIdentifier: (NSString *)identifier;

@end