#import "YTModalAlertView.h"

@interface YTModalAlertView ()

@property (nonatomic, assign) NSInteger result;

@end

@implementation YTModalAlertView

@synthesize result = _result;

#pragma mark Override Functions

+(id)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle{
	YTModalAlertView* alertView = [[YTModalAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];
	alertView.result = 0;
	return [alertView autorelease];
}

-(void)show{
	[super show];
	
	while( !self.hidden && self.superview != nil ){
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	}
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
	self.result = buttonIndex;
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

#pragma mark UIAlertViewDelegate Callback

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	self.result = buttonIndex;
}

@end