#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

UIColor* BlackColor();
UIColor* DarkGrayColor();
UIColor* LightGrayColor();
UIColor* WhiteColor();
UIColor* GrayColor();
UIColor* RedColor();
UIColor* GreenColor();
UIColor* BlueColor();
UIColor* CyanColor();
UIColor* YellowColor();
UIColor* MagentaColor();
UIColor* OrangeColor();
UIColor* PurpleColor();
UIColor* BrownColor();
UIColor* ClearColor();

UIColor* ColorWithString(NSString* string);
UIColor* ColorWithHexString(NSString* string);

@interface UIColor (Addition)

-(CGColorSpaceModel)colorSpaceModel;
-(NSString*)colorSpaceString;

-(BOOL)canProvideRGBComponents;

-(CGFloat)red;
-(CGFloat)green;
-(CGFloat)blue;
-(CGFloat)alpha;

-(NSString*)stringFromColor;
-(NSString*)hexStringFromColor;
+(UIColor*)colorWithString:(NSString*)string; //Format: {R,G,B} or {R,G,B,A}, 0...255
+(UIColor*)colorWithHexString:(NSString*)string; //Format: 0xRRGGBB or 0xRRGGBBAA, 00...FF

@end