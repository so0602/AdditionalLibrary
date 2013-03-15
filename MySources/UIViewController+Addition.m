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
	Class class = self.class;
	UIViewController* viewController = nil;
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSFileManager* fileManager = [NSFileManager defaultManager];
	do{
		NSString* className = NSStringFromClass(class);
        NSString* path = [NSString stringWithFormat:@"%@/%@.nib", mainBundle.bundlePath, className];
        if( [fileManager fileExistsAtPath:path] ){
            viewController = [[[self alloc] initWithNibName:className bundle:nil] autorelease];
        }
		
		if( !viewController ){
			class = class.superclass;
		}
	}while(!viewController);
	return viewController;
//	return [[[self alloc] initWithNibName:[[self class] description] bundle:nil] autorelease];
}

+(id)loadNibWithNavigationController{
    UIViewController* viewController = [self loadNib];
    if( !viewController ) return nil;
    return [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
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