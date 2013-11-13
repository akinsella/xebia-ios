//
//  UIImage+WPAdditions.h
//  
//
//  Created by Alexis Kinsella on 20/08/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (WPAdditions)

-(UIImage*) centerImage:(UIImage *)inImage inRect:(CGRect) thumbRect;

- (UIImage*)imageScaledToSize:(CGSize)size;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;

- (UIImage *)resizeImageToSize:(CGSize)targetSize;

- (UIImage *)imageCroppedInRect:(CGRect)cropSize;
- (UIImage *)imageScaledUsingBiggerSize:(CGSize)targetSize;

- (UIImage *)imageWithColor:(UIColor *)color;

@end
