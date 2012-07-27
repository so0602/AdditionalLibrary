#import "MGSplitViewController.h"

@interface YTSplitViewController : MGSplitViewController{
	UIViewController* _preMasterViewController;
	UIViewController* _preDetailViewController;
}

@property (nonatomic, retain) UIViewController* preMasterViewController;
@property (nonatomic, retain) UIViewController* preDetailViewController;

@end