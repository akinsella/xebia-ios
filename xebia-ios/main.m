//
//  main.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 19/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = -1;

    @try {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    @catch (NSException* exception) {
        NSLog(@"Uncaught exception: %@", exception.description);
        NSLog(@"Stack trace: %@", [exception callStackSymbols]);
    }

    [pool release];
    return retVal;

}
