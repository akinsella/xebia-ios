//
//  TTTweetMessageView.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 12/10/12.
//
//

#import "TTTweetMessageView.h"
#import "UIColor+XBAdditions.h"

@implementation TTTweetMessageView

-(id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.font = @"Arial";
        self.color = [UIColor colorWithHex:@"#AFAFAF" alpha:1.0];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, rect );
  
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font, 13.0f, NULL);
    
    //apply the current text style //2
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)self.color.CGColor, kCTForegroundColorAttributeName,
                           (id)fontRef, kCTFontAttributeName,
                           (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                           (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           nil];
  
    CFRelease(fontRef);

    NSAttributedString* attString = [[[NSAttributedString alloc] initWithString:self.content attributes:attrs] autorelease];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context); //4
    
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
}

@end
