#import <UIKit/UIKit.h>

#import "YTDefineValues.h"
#import "YTGlobalValues.h"

@interface UIImage (Addition)

@property (nonatomic, readonly) float width, height;
@property (nonatomic, readonly) float halfWidth, halfHeight;

-(UIImage*)stretchableImageByCenter;

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size;

-(UIImage*)withMaskImage:(UIImage*)maskImage;
-(UIImage*)withMaskAlpha:(CGFloat)alpha;
-(UIImage*)multiplyImage:(float)multiplyAlpha;

#pragma mark BitmapRGBA8

-(unsigned char*)bitmapRGBA8;
+(CGContextRef)newBitmapRGBA8ContextFromImage:(CGImageRef)image;
+(UIImage*)convertBitmapRGBA8ToUIImage:(unsigned char*)buffer imageSize:(CGSize)size;

#pragma mark GrayScale

@property (nonatomic, readonly) UIImage* grayScaleImage;

#pragma mark PointTransparent

-(NSData*)ARGBData;
-(BOOL)isPointTransparent:(CGPoint)point;

#pragma mark FixOrientation

-(UIImage*)fixOrientation;

@end