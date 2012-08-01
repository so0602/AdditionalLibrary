#import <UIKit/UIKit.h>

#import "YTSplitViewController.h"

@interface UIViewController (Addition)

-(IBAction)click:(id)sender;

-(IBAction)languageDidChanged;

+(id)loadNib;
+(id)loadNibWithNavigationController;

@property (nonatomic, assign) BOOL buttonExclusiveTouch;

@end

@interface UIViewController (SplitView)

@property (nonatomic, retain) YTSplitViewController* mySplitViewController;

@end