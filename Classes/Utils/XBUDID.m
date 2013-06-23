//
// Created by Alexis Kinsella on 04/05/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <SecureUDID/SecureUDID.h>
#import "XBUDID.h"


static NSString *secureUdidDomain = @"fr.xebia.ios";
static NSString *secureUdidKey = @"Xebia-iOS_mdlO1?34.Jkrj;ef!a$";

@implementation XBUDID

+(NSString *)uniqueIdentifier {
    return [SecureUDID UDIDForDomain:secureUdidDomain usingKey:secureUdidKey];
}

@end