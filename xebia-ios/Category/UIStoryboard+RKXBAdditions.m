//
//  UIStoryboard+RKXBAdditions.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 06/09/12.
//
//

#import "UIStoryboard+RKXBAdditions.h"

@implementation UIStoryboard (RKXBAdditions)

+ (id)instantiateViewControllerWithIdentifier: (NSString *)viewControllerIdentifier
                           storyboardWithName:(NSString *)storyboardName
                                       bundle:(NSBundle *)bundle
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: bundle];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier: viewControllerIdentifier];

    return viewController;
}


@end
