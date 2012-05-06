#import "UIViewController+Addition.h"

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

@end