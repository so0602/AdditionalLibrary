#import "UIImage+Addition.h"

typedef enum{
	ALPHA = 0,
	BLUE,
	GREEN,
	RED,
}PIXELS;

CGContextRef CreateARGBBitmapContext(CGImageRef inImage){
	CGColorSpaceRef colorSpace = NULL;
	
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	int bitmapBytePerRow = pixelsWide * 1;
	int bitmapByteCount = bitmapBytePerRow * pixelsHigh;
	
	void* bitmapData = calloc(1, bitmapByteCount);
	if( bitmapData == NULL ){
		CGColorSpaceRelease(colorSpace);
		return nil;
	}
	
	CGContextRef context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytePerRow, colorSpace, kCGImageAlphaOnly);
	if( context == NULL ){
		free(bitmapData);
		fprintf(stderr, "Context not created!");
	}
	CGColorSpaceRelease(colorSpace);
	return context;
}

@implementation UIImage (Addition)

-(float)width{
	return self.size.width;
}

-(float)height{
	return self.size.height;
}

-(float)halfWidth{
	return self.size.width / 2;
}

-(float)halfHeight{
	return self.size.height / 2;
}

-(UIImage*)stretchableImageByCenter{
	return [self stretchableImageWithLeftCapWidth:self.halfWidth topCapHeight:self.halfHeight];
}

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size{
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

-(UIImage*)withMaskImage:(UIImage*)image{
	CGImageRef maskRef = image.CGImage;
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef), CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), NULL, false);
	maskRef = CGImageCreateWithMask(self.CGImage, mask);
	image = [UIImage imageWithCGImage:maskRef];
	CGImageRelease(mask);
	CGImageRelease(maskRef);
	return image;
}

-(UIImage*)withMaskAlpha:(CGFloat)alpha{
	if( alpha > 1 ){
		NSLog(@"alpha should be between 0.0f and 1.0f");
		alpha = 1.0f;
	}
	
	int width = self.size.width;
	int height = self.size.height;
	
	uint32_t* pixels = (uint32_t*)malloc(width * height * sizeof(uint32_t));
	memset(pixels, 0, width * height * sizeof(uint32_t));
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
	
	for( int y = 0; y < height; y++ ){
		for( int x = 0; x < width; x++ ){
			uint8_t* rgbaPixel = (uint8_t*)&pixels[y * width + x];
			if( rgbaPixel[ALPHA] != 0 ){
				rgbaPixel[ALPHA] = (int)(alpha*255);
				rgbaPixel[RED] = rgbaPixel[GREEN] = rgbaPixel[BLUE] = 0;
			}
		}
	}
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	free(pixels);
	
	UIImage* resultImage = [UIImage imageWithCGImage:image];
	CGImageRelease(image);
	
	return MixImage([NSArray arrayWithObjects:self, resultImage, nil], self.size, AlignmentTypeCenter, AlignmentTypeCenter);
}

-(UIImage*)multiplyImage:(float)multiplyAlpha{
	UIGraphicsBeginImageContext(self.size);
	[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
	if( multiplyAlpha > 1 ){
		while( --multiplyAlpha > 1 ){
			[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeMultiply alpha:1];
		}
	}
	[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeMultiply alpha:multiplyAlpha];
	
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

#pragma mark BitmapRGBA8

-(unsigned char*)bitmapRGBA8{
	CGImageRef imageRef = self.CGImage;
	
	size_t width  = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);
	
	CGContextRef context = [UIImage newBitmapRGBA8ContextFromImage:imageRef];
	
	if( !context ) return NULL;
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
	
	unsigned char* bitmapData = (unsigned char*)CGBitmapContextGetData(context);
	
	size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
	size_t bufferLength = bytesPerRow * height;
	
	unsigned char* newBitmap = NULL;
	
	if( bitmapData ){
		newBitmap = (unsigned char*)malloc(sizeof(unsigned char) * bytesPerRow * height);
		if( newBitmap ){
			for( int i = 0; i < bufferLength; i++ ) newBitmap[i] = bitmapData[i];
		}
		free(bitmapData);
	}else NSLog(@"Error getting bitmap pixel data\n");
	
	CGContextRelease(context);
	
	return newBitmap;
}

+(CGContextRef)newBitmapRGBA8ContextFromImage:(CGImageRef)image{
	size_t bitsPerPixel = 32;
	size_t bitsPerComponent = 8;
	size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
	
	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);
	
	size_t bytesPerRow = width * bytesPerPixel;
	size_t bufferLength = bytesPerRow * height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if( !colorSpace ){
		NSLog(@"Error allocating color space RGB\n");
		return NULL;
	}
	
	uint32_t* bitmapData = (uint32_t*)malloc(bufferLength);
	if( !bitmapData ){
		NSLog(@"Error allocating memory for bitmap\n");
		CGColorSpaceRelease(colorSpace);
		return NULL;
	}
	
	CGContextRef context = CGBitmapContextCreate(bitmapData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
	if( !context ){
		free(bitmapData);
		NSLog(@"Bitmap context not created");
	}
	
	CGColorSpaceRelease(colorSpace);
	
	return context;
}

+(UIImage*)convertBitmapRGBA8ToUIImage:(unsigned char*)buffer imageSize:(CGSize)size{
	size_t bufferLength = size.width * size.height * 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
	size_t bitsPerComponent = 8;
	size_t bitsPerPixel = 32;
	size_t bytesPerRow = 4 * size.width;
	
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	if( colorSpaceRef == NULL ){
		NSLog(@"Error allocating color space");
		CGDataProviderRelease(provider);
		return nil;
	}
	
	CGImageRef imageRef = CGImageCreate(size.width, size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, kCGBitmapByteOrderDefault, provider, NULL, TRUE, kCGRenderingIntentDefault);
	
	uint32_t* pixels = (uint32_t*)malloc(bufferLength);
	if( pixels == NULL ){
		NSLog(@"Error: Memory not allocated for bitmap");
		CGDataProviderRelease(provider);
		CGColorSpaceRelease(colorSpaceRef);
		CGImageRelease(imageRef);
		return nil;
	}
	
	CGContextRef context = CGBitmapContextCreate(pixels, size.width, size.height, bitsPerComponent, bytesPerRow, colorSpaceRef, kCGImageAlphaPremultipliedLast);
	if( context == NULL ){
		NSLog(@"Error context not created");
		free(pixels);
	}
	
	UIImage* image = nil;
	if( context ){
		CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageRef);
		CGImageRef iref = CGBitmapContextCreateImage(context);
		if( [UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)] ) image = [UIImage imageWithCGImage:iref scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
		else image = [UIImage imageWithCGImage:iref];
		
		CGImageRelease(iref);
		CGContextRelease(context);
	}
	
	CGColorSpaceRelease(colorSpaceRef);
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	if( pixels ) free(pixels);
	
	return image;
}

#pragma mark GrayScale

-(UIImage*)grayScaleImage{
	int width = self.size.width;
	int height = self.size.height;
	
	uint32_t* pixels = (uint32_t*)malloc(width*height*sizeof(uint32_t));
	memset(pixels, 0, width * height * sizeof(uint32_t));
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
	
	for( int y = 0; y < height; y++ ){
		for( int x = 0; x < width; x++ ){
			uint8_t* rgbaPixel = (uint8_t*)&pixels[y * width + x];
			uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			rgbaPixel[RED] = rgbaPixel[GREEN] = rgbaPixel[BLUE] = gray;
		}
	}
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	free(pixels);
	
	UIImage* resultImage = [UIImage imageWithCGImage:image];
	CGImageRelease(image);
	
	return resultImage;
}

-(NSData*)ARGBData{
	CGContextRef context = CreateARGBBitmapContext(self.CGImage);
	if( context == NULL ) return nil;
	
	CGRect rect = {{0, 0}, {CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage)}};
	CGContextDrawImage(context, rect, self.CGImage);
	
	unsigned char* data = CGBitmapContextGetData(context);
	CGContextRelease(context);
	if( !data ) return nil;
	
	return [NSData dataWithBytes:data length:rect.size.width * rect.size.height];
}

-(BOOL)isPointTransparent:(CGPoint)point{
	NSData* rawData = [self ARGBData];
	if( rawData == nil ) return FALSE;
	
	NSUInteger index = point.x + (point.y * self.size.width);
	unsigned char* rawDataBytes = (unsigned char*)[rawData bytes];
	
	return rawDataBytes[index] == 0;
}

#pragma mark FixOrientation

-(UIImage*)fixOrientation{
	if( self.imageOrientation == UIImageOrientationUp ) return self;
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	switch( self.imageOrientation ){
		case UIImageOrientationDown:
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
			transform = CGAffineTransformTranslate(transform, self.size.width, 0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformTranslate(transform, 0, self.size.height);
			transform = CGAffineTransformRotate(transform, -M_PI_2);
			break;
		default:
			break;
	}
	
	switch( self.imageOrientation ){
		case UIImageOrientationUpMirrored:
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformTranslate(transform, self.size.width, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformTranslate(transform, self.size.height, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
		default:
			break;
	}
	
	CGContextRef context = CGBitmapContextCreate(
																							 NULL, self.size.width, self.size.height, 
																							 CGImageGetBitsPerComponent(self.CGImage), 0, 
																							 CGImageGetColorSpace(self.CGImage), 
																							 CGImageGetBitmapInfo(self.CGImage));
	CGContextConcatCTM(context, transform);
	switch( self.imageOrientation ){
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			CGContextDrawImage(context, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
			break;
		default:
			CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
			break;
	}
	
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	UIImage* image = [UIImage imageWithCGImage:cgImage];
	CGContextRelease(context);
	CGImageRelease(cgImage);
	return image;
}

#pragma mark - GIF

+(UIImage*)animatedGIFNamed:(NSString*)name{
	UIScreen* screen = UIScreen.mainScreen;
	NSUInteger scale = 1;
	
	SEL selector = @selector(scale);
	if( [screen respondsToSelector:selector] ){
		scale = (NSUInteger)[screen performSelector:selector];
	}
	
	NSString* path = nil;
	NSData* data = nil;
	if( scale > 1 ){
		path = [NSBundle.mainBundle pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
		data = [NSData dataWithContentsOfFile:path];
		
		if( data ){
			return [UIImage animatedGIFWithData:data];
		}
	}
	
	path = [NSBundle.mainBundle pathForResource:name ofType:@"gif"];
	data = [NSData dataWithContentsOfFile:path];
	
	if( data ){
		return [UIImage animatedGIFWithData:data];
	}
	
	return [UIImage imageNamed:name];
}

+(UIImage*)animatedGIFWithData:(NSData*)data{
	CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)data, NULL);
	
	NSDictionary* properties = (NSDictionary*)CGImageSourceCopyProperties(source, NULL);
	NSDictionary* gifProperties = [properties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
	[properties release];
	
	size_t count = CGImageSourceGetCount(source);
	NSMutableArray* images = [NSMutableArray array];
	
	for( size_t i = 0; i < count; i++ ){
		CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
		[images addObject:[UIImage imageWithCGImage:image]];
		CGImageRelease(image);
	}
	
	NSTimeInterval duration = [[gifProperties objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
	if( !duration ){
		duration = (1.0f/10.0f) * count;
	}
	
	CFRelease(source);
	return [UIImage animatedImageWithImages:images duration:duration];
}

-(UIImage*)animatedImageByScalingAndCroppingToSize:(CGSize)size{
	if( CGSizeEqualToSize(self.size, size) || CGSizeEqualToSize(size, CGSizeZero) ){
		return self;
	}
	
	CGSize scaledSize = size;
	CGPoint thumbnailPoint = CGPointZero;
	
	CGFloat widthFactor = size.width / self.size.width;
	CGFloat heightFactor = size.height / self.size.height;
	CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
	
	scaledSize.width = self.size.width * scaleFactor;
	scaledSize.height = self.size.height * scaleFactor;
	if( widthFactor > heightFactor ){
		thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
	}else if( widthFactor < heightFactor ){
		thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
	}
	
	NSMutableArray* scaledImages = [NSMutableArray array];
	
	UIGraphicsBeginImageContextWithOptions(size, FALSE, 0.0);
	
	for( UIImage* image in self.images ){
		[image drawInRect:CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledSize.width, scaledSize.height)];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		[scaledImages addObject:newImage];
	}
	
	UIGraphicsEndImageContext();
	
	return [UIImage animatedImageWithImages:scaledImages duration:self.duration];
}

@end