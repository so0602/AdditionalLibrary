#import "YTAlertView.h"

@interface YTAlertView ()<UIAlertViewDelegate>

@end

@implementation YTAlertView

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
	[_clickedButtonBlock release];
	[_cancelBlock release];
	[_willPresentBlock release];
	[_didPresentBlock release];
	[_willDismissBlock release];
	[_didDismissBlock release];
	[_shouldEnableFirstOtherButtonBlock release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize clickedButtonBlock = _clickedButtonBlock;
@synthesize cancelBlock = _cancelBlock;
@synthesize willPresentBlock = _willPresentBlock;
@synthesize didPresentBlock = _didPresentBlock;
@synthesize willDismissBlock = _willDismissBlock;
@synthesize didDismissBlock = _didDismissBlock;
@synthesize shouldEnableFirstOtherButtonBlock = _shouldEnableFirstOtherButtonBlock;

@end