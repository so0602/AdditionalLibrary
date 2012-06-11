#import "YTAlertView.h"

@interface YTAlertView ()<UIAlertViewDelegate>

//@property (nonatomic, retain) YTAlertViewClickedButton clickedButtonBlock;
//@property (nonatomic, retain) YTAlertViewCancel cancelBlock;
//@property (nonatomic, retain) YTAlertViewWillPresent willPresentBlock;
//@property (nonatomic, retain) YTAlertViewDidPresent didPresentBlock;
//@property (nonatomic, retain) YTAlertViewWillDismiss willDismissBlock;
//@property (nonatomic, retain) YTAlertViewDidDismiss didDismissBlock;
//@property (nonatomic, retain) YTAlertViewShouldEnableFirstOtherButton shouldEnableFirstOtherButtonBlock;

@end

@implementation YTAlertView

- (YTAlertViewClickedButton)clickedButtonBlock {
	return _clickedButtonBlock;
}
- (void)setClickedButtonBlock:(YTAlertViewClickedButton)clickedButtonBlock {
	Block_release(_clickedButtonBlock);
	_clickedButtonBlock = Block_copy(clickedButtonBlock);
}

- (YTAlertViewCancel)cancelBlock {
	return _cancelBlock;
}
- (void)setCancelBlock:(YTAlertViewCancel)cancelBlock {
	Block_release(_cancelBlock);
	_cancelBlock = Block_copy(cancelBlock);
}

- (YTAlertViewWillPresent)willPresentBlock {
	return _willPresentBlock;
}
- (void)setWillPresentBlock:(YTAlertViewWillPresent)willPresentBlock {
	Block_release(_willPresentBlock);
	_willPresentBlock = Block_copy(willPresentBlock);
}

- (YTAlertViewDidPresent)didPresentBlock {
	return _didPresentBlock;
}
- (void)setDidPresentBlock:(YTAlertViewDidPresent)didPresentBlock {
	Block_release(_didPresentBlock);
	_didPresentBlock = Block_copy(didPresentBlock);
}

- (YTAlertViewWillDismiss)willDismissBlock {
	return _willDismissBlock;
}
- (void)setWillDismissBlock:(YTAlertViewWillDismiss)willDismissBlock {
	Block_release(_willDismissBlock);
	_willDismissBlock = Block_copy(willDismissBlock);
}

- (YTAlertViewDidDismiss)didDismissBlock {
	return _didDismissBlock;
}
- (void)setDidDismissBlock:(YTAlertViewDidDismiss)didDismissBlock {
	Block_release(_didDismissBlock);
	_didDismissBlock = Block_copy(didDismissBlock);
}

- (YTAlertViewShouldEnableFirstOtherButton)shouldEnableFirstOtherButtonBlock {
	return _shouldEnableFirstOtherButtonBlock;
}
- (void)setShouldEnableFirstOtherButtonBlock:(YTAlertViewShouldEnableFirstOtherButton)shouldEnableFirstOtherButtonBlock {
	Block_release(_shouldEnableFirstOtherButtonBlock);
	_shouldEnableFirstOtherButtonBlock = Block_copy(shouldEnableFirstOtherButtonBlock);
}

-(void)showUsingBlock{
	[self show];
	
	self.delegate = self;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if( self.clickedButtonBlock ){
		self.clickedButtonBlock(buttonIndex);
	}
}

-(void)alertViewCancel:(UIAlertView *)alertView{
	if( self.cancelBlock ){
		self.cancelBlock();
	}
}

-(void)willPresentAlertView:(UIAlertView *)alertView{
	if( self.willPresentBlock ){
		self.willPresentBlock();
	}
}

-(void)didPresentAlertView:(UIAlertView *)alertView{
	if( self.didPresentBlock ){
		self.didPresentBlock();
	}
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
	if( self.willDismissBlock ){
		self.willDismissBlock(buttonIndex);
	}
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if( self.didDismissBlock ){
		self.didDismissBlock(buttonIndex);
	}
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
	if( self.shouldEnableFirstOtherButtonBlock ){
		return self.shouldEnableFirstOtherButtonBlock();
	}
	return TRUE;
}

#pragma mark - Memory Management

-(void)dealloc{
	Block_release(_clickedButtonBlock);
	Block_release(_cancelBlock);
	Block_release(_willPresentBlock);
	Block_release(_didPresentBlock);
	Block_release(_willDismissBlock);
	Block_release(_didDismissBlock);
	Block_release(_shouldEnableFirstOtherButtonBlock);
	
	[super dealloc];
}

#pragma mark - @synthesize

//@synthesize clickedButtonBlock = _clickedButtonBlock;
//@synthesize cancelBlock = _cancelBlock;
//@synthesize willPresentBlock = _willPresentBlock;
//@synthesize didPresentBlock = _didPresentBlock;
//@synthesize willDismissBlock = _willDismissBlock;
//@synthesize didDismissBlock = _didDismissBlock;
//@synthesize shouldEnableFirstOtherButtonBlock = _shouldEnableFirstOtherButtonBlock;

@end