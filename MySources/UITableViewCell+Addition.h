#import <UIKit/UIKit.h>

#import "UIView+Addition.h"

@interface UITableViewCell (Addition)

+(id)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;

+(id)cell;

+(NSString*)reuseIdentifier;

+(CGFloat)cellHeight;

-(void)didSelect;

@property (nonatomic, assign) UIImage* backgroundImage;

@end