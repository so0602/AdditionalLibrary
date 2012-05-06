#import <UIKit/UIKit.h>

#import "YTAnimation.h"

@interface YTFlashingView : UIView{
@private
	BOOL _flashing;
	NSTimeInterval _duration;
	NSInteger _flashingRepeatCount;
	NSInteger _currentRepeatCount;
}

@property (nonatomic, getter=isFlashing, readonly) BOOL flashing;
@property (nonatomic, assign) NSTimeInterval duration; //Default: 1.0f
@property (nonatomic) NSInteger flashingRepeatCount; //0 means infinite (default is 0)

-(void)startFlashing;
-(void)stopFlashing;

@end
