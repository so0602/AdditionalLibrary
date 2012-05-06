#import <UIKit/UIKit.h>

#import "UIView+Addition.h"

@class YTInputAlertView;

@protocol YTInputAlertViewDelegate

-(BOOL)inputAlertViewButtonWillClick:(YTInputAlertView*)alertView;

@end

@interface YTInputAlertView : UIAlertView<UITextFieldDelegate>{
@private
	id<YTInputAlertViewDelegate> _inputDelegate;
	UILabel* _errorLabel;
	UITextField* _textField;
}

-(id)initWithTitle:(NSString*)title delegate:(id<YTInputAlertViewDelegate>)inputDelegate;
-(void)dismiss;

@property (nonatomic, assign) NSString* placeholder;
@property (nonatomic, assign) NSString* errorMessage;
@property (nonatomic, readonly) NSString* text;

@end