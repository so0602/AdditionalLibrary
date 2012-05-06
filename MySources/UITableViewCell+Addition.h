#import <UIKit/UIKit.h>

#import "UIView+Addition.h"

@interface UITableViewCell (Addition)

+(UITableViewCell*)cell;

+(NSString*)reuseIdentifier;

+(CGFloat)cellHeight;

-(void)didSelect;

@property (nonatomic, assign) UIImage* backgroundImage;

@end