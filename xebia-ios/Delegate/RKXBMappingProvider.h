//
//  RKWPMappingProvider.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

/**
 The RKGithub application specific mapping provider class. Organizes
 the configuration of object mappings outside of the application delegate
 */
@interface RKXBMappingProvider : RKObjectMappingProvider

/**
 A reference to the RKManagedObjectStore for the application
 */
@property (nonatomic, strong) RKManagedObjectStore *objectStore;

///-----------------------------------------------------------------------------
/// @name Initializing a Mapping Provider
///-----------------------------------------------------------------------------

/**
 Create and initialize a mapping provider for the applicaion.
 
 @return An initialized RKGHMappingProvider object
 */
+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore;

/**
 Initialize an RKGHMappingProvider with a RestKit managed object store object.
 
 @param objectStore The RKManagedObjectStore with which to initialize the mapping provider.
 @return An initialized RKGHMappingProvider instance.
 */
- (id)initWithObjectStore:(RKManagedObjectStore *)objectStore;

///-----------------------------------------------------------------------------
/// @name Retrieving Wordpress Managed Object Mappings
///-----------------------------------------------------------------------------

/**
 Create and return a RestKit object mapping suitable for mapping a Wordpress post
 resource.
 
 @return A RKObjectMapping suitable for mapping a Wordpress post.
 */
- (RKManagedObjectMapping *)postObjectMapping;


@end
