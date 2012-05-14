#import "PetHunterAppDelegate.h"

@implementation PetHunterAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	self.window = [[[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds] autorelease];
//	self.window.backgroundColor = WhiteColor();
	
	self.mainViewController = [MainViewController loadNib];
	self.mainViewController.title = @"寵物獵人";
	
	self.navigationController = [[[UINavigationController alloc] initWithRootViewController:self.mainViewController] autorelease];
	self.navigationController.title = @"寵物獵人";
	
	self.window.rootViewController = self.navigationController;
	
	[self.window makeKeyAndVisible];
	
	return TRUE;
}

-(void)applicationWillResignActive:(UIApplication *)application{
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
}

-(void)applicationWillTerminate:(UIApplication *)application{
}

-(void)dealloc{
	[_window release];
	[_navigationController release];
	[_mainViewController release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize mainViewController = _mainViewController;

@end