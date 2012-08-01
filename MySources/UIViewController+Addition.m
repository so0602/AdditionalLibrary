#import "UIViewController+Addition.h"

#import <objc/runtime.h>

@interface UIViewController ()

-(void)setButtonExclusiveTouch:(BOOL)buttonExclusiveTouch superview:(UIView*)superview;

@end

@implementation UIViewController (Addition)

-(IBAction)click:(id)sender{
}

-(void)languageDidChanged{
}

+(id)loadNib{
	return [[[self alloc] initWithNibName:[[self class] description] bundle:nil] autorelease];
}

+(id)loadNibWithNavigationController{
	UINavigationController* vc = [[UINavigationController alloc] initWithRootViewController:[self loadNib]];
	return [vc autorelease];
}

-(BOOL)buttonExclusiveTouch{
	return FALSE;
}
-(void)setButtonExclusiveTouch:(BOOL)buttonExclusiveTouch{
	[self setButtonExclusiveTouch:buttonExclusiveTouch superview:self.view];
}

#pragma mark - Private Functions

-(void)setButtonExclusiveTouch:(BOOL)buttonExclusiveTouch superview:(UIView*)superview{
	for( UIView* subview in superview.subviews ){
		if( [subview isMemberOfClass:UIButton.class] || [subview isKindOfClass:UIButton.class] ){
			((UIButton*)subview).exclusiveTouch = buttonExclusiveTouch;
		}else if( [subview isKindOfClass:UIView.class] ){
			[self setButtonExclusiveTouch:buttonExclusiveTouch superview:subview];
		}
	}
}

@end

static const char* MySplitViewControllerKey = "&#_MySplitViewControllerKey_#&";

@implementation UIViewController (SplitView)

-(YTSplitViewController*)mySplitViewController{
	return objc_getAssociatedObject(self, MySplitViewControllerKey);
}
-(void)setMySplitViewController:(YTSplitViewController*)newMySplitViewController{
	objc_setAssociatedObject(self, MySplitViewControllerKey, newMySplitViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end