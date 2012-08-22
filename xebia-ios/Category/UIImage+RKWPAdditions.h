//
//  UIImage+RKWPAdditions.h
//  
//
//  Created by Alexis Kinsella on 20/08/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (RKWPAdditions)

-(UIImage*) centerImage:(UIImage *)inImage inRect:(CGRect) thumbRect;

+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

@end
