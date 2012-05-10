#import <UIKit/UIKit.h>

@interface UIViewController (Addition)

-(IBAction)click:(id)sender;

-(IBAction)languageDidChanged;

+(id)loadNib;
+(id)loadNibWithNavigationController;

@property (nonatomic, assign) BOOL buttonExclusiveTouch;

@end