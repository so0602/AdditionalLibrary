#import "YTInputAlertView.h"

@interface YTInputAlertView ()

@property (nonatomic, readonly) UILabel* errorLabel;
@property (nonatomic, readonly) UITextField* textField;
@property (nonatomic, retain) id<YTInputAlertViewDelegate> inputDelegate;

@end

@implementation YTInputAlertView

@synthesize errorLabel = _errorLabel;
@synthesize textField = _textField;
@synthesize inputDelegate = _inputDelegate;

-(id)initWithTitle:(NSString *)title delegate:(id<YTInputAlertViewDelegate>)inputDelegate{
	if( self = [super initWithTitle:title message:@"\n\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil] ){
		[self addSubview:self.errorLabel];
		[self addSubview:self.textField];
		self.inputDelegate = inputDelegate;
	}
	return self;
}

-(void)dismiss{
	[self.textField resignFirstResponder];
	[self dismissWithClickedButtonIndex:0 animated:TRUE];
}

-(void)show{
	[super show];
	[self.textField becomeFirstResponder];
}

-(NSString*)text{
	return self.textField.text;
}

-(NSString*)placeholder{
	return self.textField.placeholder;
}

-(void)setPlaceholder:(NSString*)placeHolder{
	self.textField.placeholder = placeHolder;
}

-(NSString*)errorMessage{
	return self.errorLabel.text;
}

-(void)setErrorMessage:(NSString*)errorMessage{
	self.errorLabel.text = errorMessage;
}

#pragma mark Private Functions

-(UILabel*)errorLabel{
	if( !_errorLabel ){
		_errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, 260, 0)];
		_errorLabel.textColor = [UIColor redColor];
		_errorLabel.backgroundColor = [UIColor clearColor];
		_errorLabel.numberOfLines = 2;
		_errorLabel.font = [UIFont fontWithName:_errorLabel.font.fontName size:14];
		_errorLabel.height = _errorLabel.numberOfLines * _errorLabel.font.lineHeight;
	}
	return _errorLabel;
}

-(UITextField*)textField{
	if( !_textField ){
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(12, self.errorLabel.frame.origin.y + self.errorLabel.frame.size.height + 5, 260, 32)];
		_textField.font = [UIFont fontWithName:_textField.font.fontName size:20];
		_textField.adjustsFontSizeToFitWidth = TRUE;
		_textField.minimumFontSize = 10;
		_textField.backgroundColor = [UIColor clearColor];
		_textField.borderStyle = UITextBorderStyleRoundedRect;
		_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		_textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_textField.autocorrectionType = UITextAutocorrectionTypeNo;
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.delegate = self;
	}
	return _textField;
}

#pragma mark UITextFieldDelegate Callback

-(BOOL)textFieldShouldReturn:(UITextField*)view{
	return [self.inputDelegate inputAlertViewButtonWillClick:self];
}

#pragma mark Memory Management

-(void)dealloc{
	self.inputDelegate = nil;
	[_errorLabel release], _errorLabel = nil;
	[_textField release], _textField = nil;
	
	[super dealloc];
}

@end