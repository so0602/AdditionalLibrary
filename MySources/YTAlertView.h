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



- (YTAlertViewClickedButton)clickedButtonBlock;
- (void)setClickedButtonBlock:(YTAlertViewClickedButton)clickedButtonBlock;
- (YTAlertViewCancel)cancelBlock;
- (void)setCancelBlock:(YTAlertViewCancel)cancelBlock;
- (YTAlertViewWillPresent)willPresentBlock;
- (void)setWillPresentBlock:(YTAlertViewWillPresent)willPresentBlock;
- (YTAlertViewDidPresent)didPresentBlock;
- (void)setDidPresentBlock:(YTAlertViewDidPresent)didPresentBlock;
- (YTAlertViewWillDismiss)willDismissBlock;
- (void)setWillDismissBlock:(YTAlertViewWillDismiss)willDismissBlock;
- (YTAlertViewDidDismiss)didDismissBlock;
- (void)setDidDismissBlock:(YTAlertViewDidDismiss)didDismissBlock;
- (YTAlertViewShouldEnableFirstOtherButton)shouldEnableFirstOtherButtonBlock;
- (void)setShouldEnableFirstOtherButtonBlock:(YTAlertViewShouldEnableFirstOtherButton)shouldEnableFirstOtherButtonBlock;

-(void)showUsingBlock;

@end