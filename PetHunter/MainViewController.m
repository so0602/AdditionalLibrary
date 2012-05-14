#import "MainViewController.h"

#import "MissionTableViewController.h"

#import "PetHunterPickerView.h"

#import "PetHunterPickerTitle.h"

@interface MainViewController ()<PetHunterPickerViewDelegate>

@property (nonatomic, readonly) IBOutlet UITextField* uidTextField;
@property (nonatomic, readonly) IBOutlet UITextField* passwordTextField;

@property (nonatomic, readonly) IBOutlet UIButton* loginButton;
@property (nonatomic, readonly) IBOutlet UIButton* earlyLoginButton;

@property (nonatomic, readonly) IBOutlet UIButton* missionButton;

-(void)loginDidSuccess:(NSNotification*)notification;
-(void)loginDidFail:(NSNotification*)notification;

@end

@implementation MainViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
	[super viewDidLoad];
	
	RemoveNotifications(self, LoginDidSuccessNotification, LoginDidFailNotification, nil);
	AddNotification(self, @selector(loginDidSuccess:), LoginDidSuccessNotification, nil);
	AddNotification(self, @selector(loginDidFail:), LoginDidFailNotification, nil);
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return TRUE;
}

#pragma mark - UIViewController Additions

-(void)click:(id)sender{
	[super click:sender];
	
	if( [self.loginButton isEqual:sender] ){
		if( self.uidTextField.text.length < 6 ){
			[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"使用者名稱太短。" cancelButtonTitle:@"確定"];
			return;
		}else if( self.passwordTextField.text.length < 6 ){
			[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"密碼太短。" cancelButtonTitle:@"確定"];
			return;
		}
		
		[PHManager() loginWithUid:self.uidTextField.text password:self.passwordTextField.text];
		[self.view endEditing:TRUE];
	}else if( [self.earlyLoginButton isEqual:sender] ){
		NSArray<PetHunterAccount>* accounts = PHManager().accounts;
		if( accounts.count == 0 ){
			[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"沒有任何以往紀錄。" cancelButtonTitle:@"確定"];
		}else{
			PetHunterPickerView* view = [PetHunterPickerView loadNib];
			view.delegate = self;
			[view reloadData:accounts];
			[view show];
		}
	}else if( [self.missionButton isEqual:sender] ){
		if( !PHManager().selectedAccount ){
			[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"請先登錄。" cancelButtonTitle:@"確定"];
		}else{
			MissionTableViewController* viewController = [MissionTableViewController loadNib];
			viewController.title = [self.missionButton titleForState:UIControlStateNormal];
			[self.navigationController pushViewController:viewController animated:TRUE];
		}
	}
}

#pragma mark - Private Functions

-(void)loginDidSuccess:(NSNotification *)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"登錄完成。" cancelButtonTitle:@"確定"];
}

-(void)loginDidFail:(NSNotification *)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"登錄失敗。" cancelButtonTitle:@"確定"];
}

#pragma mark - PetHunterPickerViewDelegate

-(void)confirmButtonDidClick:(PetHunterPickerView*)pickerView selectedTitle:(id<PetHunterPickerTitle>)selectedTitle{
	PetHunterAccount* account = (PetHunterAccount*)selectedTitle;
	
	self.uidTextField.text = account.name;
	self.passwordTextField.text = account.password;
	
	[self click:self.loginButton];
	[pickerView dismiss];
}

#pragma mark - Memory Management

-(void)dealloc{
	RemoveNotifications(self, LoginDidSuccessNotification, LoginDidFailNotification, nil);
	
	[_uidTextField release];
	[_passwordTextField release];
	[_loginButton release];
	[_earlyLoginButton release];
	[_missionButton release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize uidTextField = _uidTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize loginButton = _loginButton;
@synthesize earlyLoginButton = _earlyLoginButton;
@synthesize missionButton = _missionButton;

@end