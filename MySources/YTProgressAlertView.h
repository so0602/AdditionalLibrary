#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"

#import "UIAlertView+Addition.h"
#import "UIColor+Addition.h"

@interface YTProgressAlertView : UIAlertView{
@private
	UIProgressView* _progressView;
	UILabel* _numberOfItemLabel;
	UIActivityIndicatorView* _indicatorView;
	NSUInteger _maxOfItems;
	NSUInteger _numberOfItems;
	BOOL _showNumber;
}

-(id)initWithTitle:(NSString*)title message:(NSString*)message maxOfItems:(NSUInteger)maxOfItems showNumber:(BOOL)showNumber;
+(id)showWithTitle:(NSString*)title message:(NSString*)message maxOfItems:(NSUInteger)maxOfItems showNumber:(BOOL)showNumber;

@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, readonly) NSUInteger maxOfItems;

@end