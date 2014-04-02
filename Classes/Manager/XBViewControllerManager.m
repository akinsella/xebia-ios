//
//  XBViewControllerManager.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "XBViewControllerManager.h"
#import "XBConference.h"
#import "XBConstants.h"
#import "XBConferenceHomeViewController.h"

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
    UIViewController *vc = self.viewControllers[identifier];
    if (!vc) {
        vc = [self instantiateViewControllerWithIdentifier:identifier];
        self.viewControllers[identifier] = vc;
    }

    return vc;
}

- (UIViewController *)getOrCreateConferenceControllerWithConference:(XBConference *)conference {
    XBConferenceHomeViewController *vc = self.viewControllers[XBConferenceHomeViewControllerIdentifier];
    if (vc && [vc.conference.identifier isEqualToString:conference.identifier]) {
        return vc;
    }

    vc = (XBConferenceHomeViewController *) [self instantiateViewControllerWithIdentifier:XBConferenceHomeViewControllerIdentifier];
    vc.conference = conference;
    self.viewControllers[XBConferenceHomeViewControllerIdentifier] = vc;
    return vc;
}

-(UIViewController *)instantiateViewControllerWithIdentifier: (NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];

    return vc;
}

@end