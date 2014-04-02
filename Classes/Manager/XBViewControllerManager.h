//
//  XBViewControllerManager.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import <Foundation/Foundation.h>

@class XBConference;


@interface XBViewControllerManager : NSObject

+(id)manager;

- (id)init;

-(UIViewController *)getOrCreateControllerWithIdentifier: (NSString *)identifier;

- (UIViewController *)getOrCreateConferenceControllerWithConference:(XBConference *)conference;

- (Class *)controllerClassWithIdentifier:(NSString *)identifier;
@end