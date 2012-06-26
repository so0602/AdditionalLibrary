#import "UITableView+Addition.h"

@implementation UITableView (Addition)

-(void)reloadVisibleRows{
	[self reloadVisibleRowsWithRowAnimation:UITableViewRowAnimationNone];
}

-(void)reloadVisibleRowsWithRowAnimation:(UITableViewRowAnimation)rowAnimation{
	NSArray* indexPaths = [self indexPathsForVisibleRows];
	[self reloadRowsAtIndexPaths:indexPaths withRowAnimation:rowAnimation];
}

@end