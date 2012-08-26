#import "UIColor+Addition.h"

UIColor* BlackColor(){
	return [UIColor blackColor];
}

UIColor* DarkGrayColor(){
	return [UIColor darkGrayColor];
}

UIColor* LightGrayColor(){
	return [UIColor lightGrayColor];
}

UIColor* WhiteColor(){
	return [UIColor whiteColor];
}

UIColor* GrayColor(){
	return [UIColor grayColor];
}

UIColor* RedColor(){
	return [UIColor redColor];
}

UIColor* GreenColor(){
	return [UIColor greenColor];
}

UIColor* BlueColor(){
	return [UIColor blueColor];
}

UIColor* CyanColor(){
	return [UIColor cyanColor];
}

UIColor* YellowColor(){
	return [UIColor yellowColor];
}

UIColor* MagentaColor(){
	return [UIColor magentaColor];
}

UIColor* OrangeColor(){
	return [UIColor orangeColor];
}

UIColor* PurpleColor(){
	return [UIColor purpleColor];
}

UIColor* BrownColor(){
	return [UIColor brownColor];
}

UIColor* ClearColor(){
	return [UIColor clearColor];
}

UIColor* ColorWithString(NSString* string){
	return [UIColor colorWithString:string];
}

UIColor* ColorWithHexString(NSString* string){
	return [UIColor colorWithHexString:string];
}

@implementation UIColor (Addition)

-(CGColorSpaceModel)colorSpaceModel{
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

-(NSString*)colorSpaceString{
	switch( [self colorSpaceModel] ){
		case kCGColorSpaceModelUnknown: return @"kCGColorSpaceModelUnknown";
		case kCGColorSpaceModelMonochrome: return @"kCGColorSpaceModelMonochrome";
		case kCGColorSpaceModelRGB: return @"kCGColorSpaceModelRGB";
		case kCGColorSpaceModelCMYK: return @"kCGColorSpaceModelCMYK";
		case kCGColorSpaceModelLab: return @"kCGColorSpaceModelLab";
		case kCGColorSpaceModelDeviceN: return @"kCGColorSpaceModelDeviceN";
		case kCGColorSpaceModelIndexed: return @"kCGColorSpaceModelIndexed";
		case kCGColorSpaceModelPattern: return @"kCGColorSpaceModelPattern";
		default: return @"Not a valid color space";
	}
}

-(BOOL)canProvideRGBComponents{
	return (([self colorSpaceModel] == kCGColorSpaceModelRGB) || ([self colorSpaceModel] == kCGColorSpaceModelMonochrome));
}

-(CGFloat)red{
	NSAssert( [self canProvideRGBComponents], @"Must be a RGB color to use -red, -green, -blue");
	return CGColorGetComponents(self.CGColor)[0];
}

-(CGFloat)green{
	NSAssert( [self canProvideRGBComponents], @"Must be a RGB color to use -red, -green, -blue");
	return CGColorGetComponents(self.CGColor)[1];
	return CGColorGetComponents(self.CGColor)[[self colorSpaceModel] == kCGColorSpaceModelMonochrome ? 0 : 1];
}

-(CGFloat)blue{
	NSAssert( [self canProvideRGBComponents], @"Must be a RGB color to use -red, -green, -blue");
	return CGColorGetComponents(self.CGColor)[2];
	return CGColorGetComponents(self.CGColor)[[self colorSpaceModel] == kCGColorSpaceModelMonochrome ? 0 : 1];
}

-(CGFloat)alpha{
	return CGColorGetComponents(self.CGColor)[CGColorGetNumberOfComponents(self.CGColor)-1];
}

-(NSString*)stringFromColor{
	NSAssert( [self canProvideRGBComponents], @"Must be a RGB color to use stringFromColor");
	return [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
}

-(NSString*)hexStringFromColor{
	NSAssert( [self canProvideRGBComponents], @"Must be a RGB color to use hexStringFromColor");
	return [NSString stringWithFormat:@"%02X%02X%02X", (int)(MIN(MAX(0.0, self.red), 1.0) * 255), (int)(MIN(MAX(0.0, self.green), 1.0) * 255), (int)(MIN(MAX(0.0, self.blue), 1.0) * 255)];
}

+(UIColor*)colorWithString:(NSString*)stringToConvert{
	NSString* cString = [stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if( ![cString hasPrefix:@"{"] || ![cString hasSuffix:@"}"] ) return nil;
	
	cString = [cString substringFromIndex:1];
	cString = [cString substringToIndex:cString.length - 1];
	CFShow(cString);
	
	NSArray* components = [[cString stringByReplacingOccurrencesOfString:@", " withString:@","] componentsSeparatedByString:@","];
	if( components.count == 3 ) return [UIColor colorWithRed:[[components objectAtIndex:0] floatValue] green:[[components objectAtIndex:1] floatValue] blue:[[components objectAtIndex:2] floatValue] alpha:1.0f];
	if( components.count == 4 ) return [UIColor colorWithRed:[[components objectAtIndex:0] floatValue] green:[[components objectAtIndex:1] floatValue] blue:[[components objectAtIndex:2] floatValue] alpha:[[components objectAtIndex:3] floatValue]];
	return nil;
}

+(UIColor*)colorWithHexString:(NSString*)stringToConvert{
	NSString* cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	if( cString.length < 6 ) return nil;
	
	if( [cString hasPrefix:@"0X"] ) cString = [cString substringFromIndex:2];
	if( !(cString.length == 6 || cString.length == 8) ) return nil;
	
	unsigned int red, green, blue, alpha = 255.0f;
	[[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
	[[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
	[[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
	if( cString.length == 8 ) [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&alpha];
	
	return [UIColor colorWithRed:(float)red / 255.0f green:(float)green / 255.0f blue:(float)blue / 255.0f alpha:(float)alpha / 255.0f];
}

@end