//
//  main.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 19/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBAppDelegate.h"

int main(int argc, char *argv[])
{

    @autoreleasepool {
        int retVal = -1;
        
        @try {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([XBAppDelegate class]));
        }
        @catch (NSException* exception) {
            NSLog(@"Uncaught exception: %@", exception.description);
            NSLog(@"Stack trace: %@", [exception callStackSymbols]);
        }
        
        return retVal;
    }

}
