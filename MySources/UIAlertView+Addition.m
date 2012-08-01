#import "UIAlertView+Addition.h"

#import <objc/runtime.h>

#pragma mark UIAlertView Addition

@implementation UIAlertView (Addition)

+(id)alertViewWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle{
	return [self alertViewWithTitle:title message:nil cancelButtonTitle:cancelButtonTitle okButtonTitle:nil];
}

+(id)alertViewWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle{
	return [self alertViewWithTitle:title message:nil cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle];
}

+(id)alertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle{
	return [self alertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:nil];
}

+(id)alertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle{
	return [[[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil] autorelease];
}

+(id)alertViewWithMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle{
	return [self alertViewWithTitle:nil message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:nil];
}

+(id)alertViewWithMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle{
	return [self alertViewWithTitle:nil message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle];
}

+(id)alertViewWithDataSource:(id<YTUIAlertViewDataSource>)dataSource{
	NSString* title = RespondsToSelector(dataSource, @selector(title:)) ? [dataSource title:self] : nil;
	NSString* message = RespondsToSelector(dataSource, @selector(message:)) ? [dataSource message:self] : nil;
	NSString* okButtonTitle = RespondsToSelector(dataSource, @selector(okButtonTitle:)) ? [dataSource okButtonTitle:self] : nil;
	return [UIAlertView alertViewWithTitle:title message:message cancelButtonTitle:[dataSource cancelButtonTitle:self] okButtonTitle:okButtonTitle];
}

+(id)showAlertViewWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle{
	return [self showAlertViewWithTitle:title message:nil cancelButtonTitle:cancelButtonTitle okButtonTitle:nil];
}

+(id)showAlertViewWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle{
	return [self showAlertViewWithTitle:title message:nil cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle];
}

+(id)showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle{
	return [self showAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:nil];
}

+(id)showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle{
	UIAlertView* alertView = [self alertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle];
	[alertView show];
	return alertView;
}

+(id)showAlertViewWithMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle{
	return [self showAlertViewWithTitle:nil message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:nil];
}

+(id)showAlertViewWithMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle{
	return [self showAlertViewWithTitle:nil message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle];
}

+(id)showAlertViewWithDataSource:(id<YTUIAlertViewDataSource>)dataSource{
	UIAlertView* alertView = [self alertViewWithDataSource:dataSource];
	[alertView show];
	return alertView;
}

@end

static const char* UIAlertViewDidClickBlockKey = "&#_UIAlertViewDidClickBlockKey_#&";
static const char* UIAlertViewDidCancelBlockKey = "&#_UIAlertViewDidCancelBlockKey_#&";
static const char* UIAlertViewWillPresentBlockKey = "&#_UIAlertViewWillPresentBlockKey_#&";
static const char* UIAlertViewDidPresentBlockKey = "&#_UIAlertViewDidPresentBlockKey_#&";
static const char* UIAlertViewWillDismissBlockKey = "&#_UIAlertViewWillDismissBlockKey_#&";
static const char* UIAlertViewDidDismissBlockKey = "&#_UIAlertViewDidDismissBlockKey_#&";
static const char* UIAlertViewShouldEnableFirstOtherButtonBlockKey = "&#_UIAlertViewShouldEnableFirstOtherButtonBlockKey_#&";

@implementation UIAlertView (Block)

-(UIAlertViewDidClickBlock)didClickBlock{
	return objc_getAssociatedObject(self, UIAlertViewDidClickBlockKey);
}
-(void)setDidClickBlock:(UIAlertViewDidClickBlock)didClickBlock{
	self.delegate = self;
	objc_setAssociatedObject(self, UIAlertViewDidClickBlockKey, didClickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIAlertViewDidCancelBlock)didCancelBlock{
	return objc_getAssociatedObject(self, UIAlertViewDidCancelBlockKey);
}
-(void)setDidCancelBlock:(UIAlertViewDidCancelBlock)didCancelBlock{
	self.delegate = self;
	objc_setAssociatedObject(self, UIAlertViewDidCancelBlockKey, didCancelBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIAlertViewWillPresentBlock)willPresentBlock{
	return objc_getAssociatedObject(self, UIAlertViewWillPresentBlockKey);
}
-(void)setWillPresentBlock:(UIAlertViewWillPresentBlock)willPresentBlock{
	self.delegate = self;
	objc_setAssociatedObject(self, UIAlertViewWillPresentBlockKey, willPresentBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIAlertViewDidPresentBlock)didPresentBlock{
	return objc_getAssociatedObject(self, UIAlertViewDidPresentBlockKey);
}
-(void)setDidPresentBlock:(UIAlertViewDidPresentBlock)didPresentBlock{
	self.delegate = self;
	objc_setAssociatedObject(self, UIAlertViewDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIAlertViewWillDismissBlock)willDismissBlock{
	return objc_getAssociatedObject(self, UIAlertViewWillDismissBlockKey);
}
-(void)setWillDismissBlock:(UIAlertViewWillDismissBlock)willDismissBlock{
	self.delegate = self;
	objc_setAssociatedObject(self, UIAlertViewWillDismissBlockKey, willDismissBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIAlertViewDidDismissBlock)didDismissBlock{
	return objc_getAssociatedObject(self, UIAlertViewDidDismissBlockKey);
}
-(void)setDidDismissBlock:(UIAlertViewDidDismissBlock)didDismissBlock{
	self.delegate = self;
	objc_setAssociatedObject(self, UIAlertViewDidDismissBlockKey, didDismissBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIAlertViewShouldEnableFirstOtherButtonBlock)shouldEnableFirstOtherButtonBlock{
	return objc_getAssociatedObject(self, UIAlertViewShouldEnableFirstOtherButtonBlockKey);
}
-(void)setShouldEnableFirstOtherButtonBlock:(UIAlertViewShouldEnableFirstOtherButtonBlock)shouldEnableFirstOtherButtonBlock{
	self.delegate = self;
	objc_setAssociatedObject(self, UIAlertViewShouldEnableFirstOtherButtonBlockKey, shouldEnableFirstOtherButtonBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if( self.didClickBlock ){
		self.didClickBlock(buttonIndex);
	}
}

-(void)alertViewCancel:(UIAlertView *)alertView{
	if( self.didCancelBlock ){
		self.didCancelBlock();
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
	
	self.delegate = nil;
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
	if( self.shouldEnableFirstOtherButtonBlock ){
		return self.shouldEnableFirstOtherButtonBlock();
	}
	return TRUE;
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTUIAlertViewDataSource

@implementation YTUIAlertViewDataSource

@synthesize title = _title;
@synthesize message = _message;
@synthesize cancelButtonTitle = _cancelButtonTitle;
@synthesize okButtonTitle = _okButtonTitle;

-(NSString*)cancelButtonTitle:(id)target{
	return self.cancelButtonTitle;
}

-(NSString*)title:(id)target{
	return self.title;
}

-(NSString*)message:(id)target{
	return self.message;
}

-(NSString*)okButtonTitle:(id)target{
	return self.okButtonTitle;
}

#pragma mark Memory Management

-(void)dealloc{
	self.title = nil;
	self.message = nil;
	self.cancelButtonTitle = nil;
	self.okButtonTitle = nil;
	
	[super dealloc];
}

@end