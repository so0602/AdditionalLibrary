#import <UIKit/UIKit.h>

@interface YTLabel : UILabel{
	CGFloat _shadowBlurValue;
	CGSize _innerShadowOffset;
	UIColor* _innerShadowColor;
	UIColor* _gradientStartColor;
	UIColor* _gradientEndColor;
	CGPoint _gradientStartPoint;
	CGPoint _gradientEndPoint;
}

@property (nonatomic, assign) CGFloat shadowBlurValue;
@property (nonatomic, assign) CGSize innerShadowOffset;
@property (nonatomic, retain) UIColor* innerShadowColor;
@property (nonatomic, retain) UIColor* gradientStartColor;
@property (nonatomic, retain) UIColor* gradientEndColor;
@property (nonatomic, assign) CGPoint gradientStartPoint;
@property (nonatomic, assign) CGPoint gradientEndPoint;

@end