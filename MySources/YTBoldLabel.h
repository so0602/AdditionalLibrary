#import <UIKit/UIKit.h>

#import "UIColor+Addition.h"
#import "UILabel+Addition.h"
#import "UIView+Addition.h"

@interface YTBoldLabel : UIView{
@private
	UILabel* labels[9];
}

@property (nonatomic, assign) NSString* text;
@property (nonatomic, assign) UIColor* textColor;

@end