#import "UIAlertView+Addition.h"

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