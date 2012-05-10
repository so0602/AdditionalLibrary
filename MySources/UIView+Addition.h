#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"

@protocol YTUIViewDataSource;

@interface UIView (Addition)

-(id)initWithDataSource:(id<YTUIViewDataSource>)dataSource;

+(id)viewWithFrame:(CGRect)frame;
+(id)viewWithDataSource:(id<YTUIViewDataSource>)dataSource;

-(void)setDataSource:(id<YTUIViewDataSource>)dataSource;

#pragma mark -

-(void)stretchableImageByCenter;

-(void)sizeToFitAndSharp;
-(void)sharp;

-(void)moveViewWithLeftTop:(CGPoint)point;
-(void)moveViewWithLeftBottom:(CGPoint)point;
-(void)moveViewWithRightTop:(CGPoint)point;
-(void)moveViewWithRightBottom:(CGPoint)point;

-(void)scaleViewWithSize:(CGSize)size;
-(void)scaleViewWithScaleFactor:(float)scaleFactor;

-(void)contentsScaleToFit;

-(void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius;
-(void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius;
-(void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor;
-(void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor radius:(CGFloat)radius;

-(void)addSubviews:(UIView*)firstView, ...;

-(void)disableUserInteraction;
-(void)enableUserInteraction;

@property (nonatomic, assign) BOOL buttonExclusiveTouch;

#pragma mark -

@property (nonatomic, readonly) float minX, minY, maxX, maxY, halfWidth, halfHeight;
@property (nonatomic, assign) float x, y, width, height; //x = minX, y = minY

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

#pragma mark -

-(IBAction)click:(id)sender;

-(IBAction)languageDidChanged;

-(IBAction)didReceiveMemoryWarning;

+(id)loadNib;

@property (nonatomic, assign) BOOL disable;

#pragma mark -

@property (nonatomic, readonly) NSString* dollarText;
@property (nonatomic, readonly) NSNumber* textNumber;

@end

@protocol YTUIViewDataSource

@optional
-(CGRect)frame:(id)target;
-(UIColor*)backgroundColor:(id)target;

@end

@interface YTUIViewDataSource : NSObject<YTUIViewDataSource>{
@private
	UIColor* _backgroundColor;
	CGRect _frame;
}

@property (nonatomic, retain) UIColor* backgroundColor;
@property (nonatomic, assign) CGRect frame;

@end