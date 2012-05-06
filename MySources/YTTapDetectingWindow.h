#import <UIKit/UIKit.h>

@protocol YTTapDetectingWindowDelegate<NSObject>

-(void)userDidTapView:(id)tapPoint;

@end

@interface YTTapDetectingWindow : UIWindow{
	UIView* _viewToOvserve;
	id<YTTapDetectingWindowDelegate> _controllerThatObserves;
}

@property (nonatomic, retain) UIView* viewToOvserve;
@property (nonatomic, assign) id<YTTapDetectingWindowDelegate> controllerThatObserves;

@end