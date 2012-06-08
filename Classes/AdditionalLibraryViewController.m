#import "AdditionalLibraryViewController.h"

#import "ASIHTTPRequest.h"
#import "UINavigationController+Addition.h"
#import "YTAlertView.h"

@implementation AdditionalLibraryViewController

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	printFunc;
	int x = 0;
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Click" forState:UIControlStateNormal];
	[button sizeToFit];
	[button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
	button.x = x;
	[self.view addSubview:button];
	
	x = button.maxX;
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Back" forState:UIControlStateNormal];
	[button sizeToFit];
	[button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	button.x = x;
	[self.view addSubview:button];
	
	x = button.maxX;
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Root" forState:UIControlStateNormal];
	[button sizeToFit];
	[button addTarget:self action:@selector(root:) forControlEvents:UIControlEventTouchUpInside];
	button.x = x;
	[self.view addSubview:button];
	
	x = button.maxX;
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Second" forState:UIControlStateNormal];
	[button sizeToFit];
	[button addTarget:self action:@selector(second:) forControlEvents:UIControlEventTouchUpInside];
	button.x = x;
	[self.view addSubview:button];
	
	NSLog(@"array: %@", [NSFileManager removeItemsAtDirectory:DocumentPath() contains:@"icon"]);
}

-(void)click:(id)sender{
	printFunc;
	AdditionalLibraryViewController* viewController = [AdditionalLibraryViewController loadNib];
	viewController.view.backgroundColor = BlackColor();
	
	[self.navigationController pushViewController:viewController animation:UIViewControllerAnimationOpenDoor];
}

-(void)back:(id)sender{
	printFunc;
	NSLog(@"viewControllers: %@", self.navigationController.viewControllers);
	UIViewController* viewController = [self.navigationController popViewControllerWithAnimation:UIViewControllerAnimationCloseDoor];
//	UIViewController* viewController = [self.navigationController popViewControllerWithAnimation:UIViewControllerAnimationNormal];
	NSLog(@"viewController: %@", viewController);
}

-(void)root:(id)sender{
	printFunc;
	NSLog(@"viewControllers: %@", self.navigationController.viewControllers);
	NSArray* viewControllers = [self.navigationController popToRootViewControllerWithAnimation:UIViewControllerAnimationCloseDoor];
//	NSArray* viewControllers = [self.navigationController popToRootViewControllerWithAnimation:UIViewControllerAnimationNormal];
	NSLog(@"viewController: %@", viewControllers);
}

-(void)second:(id)sender{
//	printFunc;
//	NSLog(@"viewControllers: %@", self.navigationController.viewControllers);
//	if( self.navigationController.viewControllers.count > 1 ){
//		UIViewController* viewController = [self.navigationController.viewControllers objectAtIndex:1];
//		NSArray* viewControllers = [self.navigationController popToViewController:viewController animation:UIViewControllerAnimationOpenDoor];
//		NSArray* viewControllers = [self.navigationController popToViewController:viewController animation:UIViewControllerAnimationNormal];
//		NSLog(@"viewController: %@", viewControllers);
//	}
}

@end