#import <UIKit/UIKit.h>

#import "UIView+Addition.h"

@protocol YTUILabelDataSource;

@interface UILabel (Addition)

/*
 Default:	
		textColor				-	[UIColor blackColor]
		backgroundColor	-	[UIColor clearColor]
		textAlignment		-	UITextAlignmentLeft
		shadowColor			-	nil
		shadowOffset			-	CGSizeMake(1, 1)
		numberOfLines		-	1
 */

-(id)initWithFrame:(CGRect)frame font:(UIFont*)font;
-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor;
-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor;
-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment;
-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor;
-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset;
-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset numberOfLines:(NSInteger)numberOfLines;
-(id)initWithDataSource:(id<YTUILabelDataSource>)dataSource;

+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font;
+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor;
+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor;
+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment;
+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor;
+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset;
+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset numberOfLines:(NSInteger)numberOfLines;
+(id)labelWithDataSource:(id<YTUILabelDataSource>)dataSource;

-(void)setDataSource:(id<YTUILabelDataSource>)dataSource;

-(void)sizeToFitWidth;

-(void)adjustsFontSizeToFitWidthForMultilines;

@property (nonatomic, readonly) NSInteger visableNumberOfLines;

@end

@protocol YTUILabelDataSource<YTUIViewDataSource>

@optional
-(UIFont*)font:(id)taget;
-(UIColor*)textColor:(id)taget;
-(UITextAlignment)textAlignment:(id)taget;
-(UIColor*)shadowColor:(id)taget;
-(CGSize)shadowOffset:(id)taget;
-(NSInteger)numberOfLines:(id)taget;

@end

@interface YTUILabelDataSource : YTUIViewDataSource<YTUILabelDataSource>{
@private
	UIFont* _font;
	UIColor* _textColor;
	UITextAlignment _textAlignment;
	UIColor* _shadowColor;
	CGSize _shadowOffset;
	NSInteger _numberOfLines;
}

@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) UIColor* textColor;
@property (nonatomic, assign) UITextAlignment textAlignment;
@property (nonatomic, retain) UIColor* shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) NSInteger numberOfLines;

@end