//
// Created by akinsella on 24/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RKTableItem+XKAdditions.h"


@implementation RKTableItem (XKAdditions)

+(RKTableItem *)tableItemWithText:(NSString *)text imageNamed:(NSString *)imageName {
    return [RKTableItem tableItemWithText:text
                               detailText:@""
                                    image:[UIImage imageNamed:imageName]];
}

@end