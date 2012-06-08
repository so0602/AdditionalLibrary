#import <UIKit/UIKit.h>

typedef void (^YTAlertViewClickedButton)(NSInteger buttonIndex);
typedef void (^YTAlertViewCancel)();
typedef void (^YTAlertViewWillPresent)();
typedef void (^YTAlertViewDidPresent)();
typedef void (^YTAlertViewWillDismiss)(NSInteger buttonIndex);
typedef void (^YTAlertViewDidDismiss)(NSInteger buttonIndex);
typedef BOOL (^YTAlertViewShouldEnableFirstOtherButton)();

@interface YTAlertView : UIAlertView{
	YTAlertViewClickedButton _clickedButtonBlock;
	YTAlertViewCancel _cancelBlock;
	YTAlertViewWillPresent _willPresentBlock;
	YTAlertViewDidPresent _didPresentBlock;
	YTAlertViewWillDismiss _willDismissBlock;
	YTAlertViewDidDismiss _didDismissBlock;
	YTAlertViewShouldEnableFirstOtherButton _shouldEnableFirstOtherButtonBlock;
}

@property (nonatomic, retain) YTAlertViewClickedButton clickedButtonBlock;
@property (nonatomic, retain) YTAlertViewCancel cancelBlock;
@property (nonatomic, retain) YTAlertViewWillPresent willPresentBlock;
@property (nonatomic, retain) YTAlertViewDidPresent didPresentBlock;
@property (nonatomic, retain) YTAlertViewWillDismiss willDismissBlock;
@property (nonatomic, retain) YTAlertViewDidDismiss didDismissBlock;
@property (nonatomic, retain) YTAlertViewShouldEnableFirstOtherButton shouldEnableFirstOtherButtonBlock;

-(void)showUsingBlock;

@end