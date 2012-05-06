#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"

#import "UIAlertView+Addition.h"

@protocol YTModalAlertViewDataSource;

@interface YTModalAlertView : UIAlertView<UIAlertViewDelegate>{
@private
	NSInteger _result;
}

@property (nonatomic, readonly) NSInteger result;

@end

@protocol YTModalAlertViewDataSource<YTUIAlertViewDataSource>

@end