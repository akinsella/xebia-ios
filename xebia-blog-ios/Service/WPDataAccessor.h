//
//  WPDataAccessor.h
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 18/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPDataAccessor : NSObject

@property(nonatomic, retain) NSString *baseApiUrl;

+ (id) initWithBaseApiUrl:(NSString *)url;

- (id)initWithBaseApiUrl:(NSString *)baseApiUrl;

//-(NSData *)fetchJsonData:(NSString *)jsonUrl;

//- (NSString *)getApiCallPath:(NSString *)relativeApiCallPath;

-(NSMutableArray *) fetchTags;

@end
