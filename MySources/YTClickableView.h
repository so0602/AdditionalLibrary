#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"

@class YTClickableView;

@protocol YTClickableViewDelegate

@optional
-(void)clickableView:(YTClickableView*)clickableView touchBeganAtPoint:(CGPoint)point atView:(UIView*)view;
-(void)clickableView:(YTClickableView*)clickableView touchCancelledAtPoint:(CGPoint)point atView:(UIView*)view;
-(void)clickableView:(YTClickableView*)clickableView touchEndedAtPoint:(CGPoint)point atView:(UIView*)view;
-(void)clickableView:(YTClickableView*)clickableView touchMovedAtPoint:(CGPoint)atPoint toPoint:(CGPoint)toPoint atView:(UIView*)view;

@end

@interface YTClickableView : UIView{
@private
	id<YTClickableViewDelegate> _delegate;
}

-(id)initWithDelegate:(id<YTClickableViewDelegate>)delegate;
-(id)initWithFrame:(CGRect)frame delegate:(id<YTClickableViewDelegate>)delegate;

@end