#import "YTSplitViewController.h"

#import "UIViewController+Addition.h"

@interface YTSplitViewController ()

@end

@implementation YTSplitViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
	[super viewDidLoad];	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if( !self.masterViewController ){
		self.masterViewController = self.preMasterViewController;
	}
	self.masterViewController.mySplitViewController = self;
	
	if( !self.detailViewController ){
		self.detailViewController = self.preDetailViewController;
	}
	self.detailViewController.mySplitViewController = self;
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}

#pragma mark - Memory Management

-(void)dealloc{
	[_preMasterViewController release];
	[_preDetailViewController release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize preMasterViewController = _preMasterViewController;
@synthesize preDetailViewController = _preDetailViewController;

@end