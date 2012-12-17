//
// Created by akinsella on 13/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit.h>
#import "GHOwner.h"
#import "GravatarHelper.h"

@implementation GHOwner

- (NSURL *)avatarImageUrl {
    NSLog(@"User: %@", self );
    return self.gravatar_id != nil ?
            [GravatarHelper getGravatarURLWithGravatarId: self.gravatar_id] :
            [NSURL URLWithString: self.avatar_url];
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"login", @"gravatar_id", @"avatar_url", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                nil];
    }];

    return mapping;

}

@end