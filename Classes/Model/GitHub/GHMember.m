//
// Created by akinsella on 13/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "GHMember.h"
#import "GravatarHelper.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation GHMember

- (NSURL *)avatarImageUrl {
    NSLog(@"User: %@", self );
    return self.gravatar_id != nil ?
            [GravatarHelper getGravatarURLWithGravatarId: self.gravatar_id] :
            [NSURL URLWithString: self.avatar_url];
}

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return config;
}

@end