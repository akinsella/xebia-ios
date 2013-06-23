//
//  XBViewControllerManager.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "XBViewControllerManager.h"
#import "UINavigationController+XBAdditions.h"
#import "XBWebViewController.h"

@interface XBViewControllerManager ()

@property (nonatomic, strong) NSMutableDictionary *viewControllers;

@end

@implementation XBViewControllerManager

+(id)manager {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        self.viewControllers = [NSMutableDictionary dictionary];
    }

    return self;
}

- (UIViewController *)getOrCreateControllerWithIdentifier:(NSString *)identifier {
    UIViewController *vc = [self.viewControllers objectForKey:identifier];
    if (!vc) {
        vc = [self instantiateViewControllerWithIdentifier:identifier];
    }

    return vc;
}

-(UIViewController *)instantiateViewControllerWithIdentifier: (NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];

    [self.viewControllers setValue:vc forKey:identifier];

    return vc;
}

@end