#import <UIKit/UIKit.h>

@interface UITableView (Addition)

-(void)reloadVisibleRows;
-(void)reloadVisibleRowsWithRowAnimation:(UITableViewRowAnimation)rowAnimation;

@end