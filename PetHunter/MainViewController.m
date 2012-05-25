#import "MainViewController.h"

#import "FriendTableViewController.h"
#import "ItemTableViewController.h"
#import "MissionTableViewController.h"
#import "ScheduleTableViewController.h"
#import "SettingTableViewController.h"

#import "PetHunterPickerView.h"

#import "PetHunterPickerTitle.h"

#import "PetHunterBattle.h"

@interface MainViewController ()<PetHunterPickerViewDelegate>

@property (nonatomic, readonly) IBOutlet UIBarButtonItem* settingButton;

@property (nonatomic, readonly) IBOutlet UITextField* uidTextField;
@property (nonatomic, readonly) IBOutlet UITextField* passwordTextField;

@property (nonatomic, readonly) IBOutlet UIButton* loginButton;
@property (nonatomic, readonly) IBOutlet UIButton* earlyLoginButton;

@property (nonatomic, readonly) IBOutlet UILabel* actionLabel;
@property (nonatomic, readonly) IBOutlet UILabel* latestUpdateActionLabel;
@property (nonatomic, readonly) IBOutlet UIButton* refreshActionButton;

@property (nonatomic, readonly) IBOutlet UIButton* missionButton;
@property (nonatomic, readonly) IBOutlet UIButton* friendButton;
@property (nonatomic, readonly) IBOutlet UIButton* itemButton;

@property (nonatomic, readonly) IBOutlet UIButton* autoBattleButton;
@property (nonatomic, readonly) IBOutlet UIButton* autoChallengeButton;
@property (nonatomic, readonly) IBOutlet UIButton* scheduleButton;

@property (nonatomic, retain) UIAlertView* autoBattleAlertView;

-(void)loginDidSuccess:(NSNotification*)notification;
-(void)loginDidFail:(NSNotification*)notification;

-(void)challengeDidSuccess:(NSNotification*)notification;
-(void)challengeDidFail:(NSNotification*)notification;

-(void)battleDidSuccess:(NSNotification*)notification;
-(void)battleDidFail:(NSNotification*)notification;

@property (nonatomic, retain) ASIHTTPRequest* autoUpdateActionRequest;
@property (nonatomic, retain) NSTimer* autoUpdateActionTimer;
-(void)autoUpdateAction;

@end

@implementation MainViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
	[super viewDidLoad];
	
	UINavigationItem* navigationItem = self.navigationItem;
	navigationItem.rightBarButtonItem = self.settingButton;
	
	RemoveNotifications(self, LoginDidSuccessNotification, LoginDidFailNotification, nil);
	AddNotification(self, @selector(loginDidSuccess:), LoginDidSuccessNotification, nil);
	AddNotification(self, @selector(loginDidFail:), LoginDidFailNotification, nil);
	
	RemoveNotifications(self, ChallengeDidSuccessNotification, ChallengeDidFailNotification, nil);
	AddNotification(self, @selector(challengeDidSuccess:), ChallengeDidSuccessNotification, nil);
	AddNotification(self, @selector(challengeDidFail:), ChallengeDidFailNotification, nil);
	
	RemoveNotifications(self, BattleDidSuccessNotification, BattleDidFailNotification, nil);
	AddNotification(self, @selector(battleDidSuccess:), BattleDidSuccessNotification, nil);
	AddNotification(self, @selector(battleDidFail:), BattleDidFailNotification, nil);
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if( PHManager().selectedAccount ){
		if( !PHManager().isAutoUpdateAction ){
			self.refreshActionButton.disable = FALSE;
			
			[self.autoUpdateActionTimer invalidate];
			[self.autoUpdateActionRequest cancel];
			self.autoUpdateActionRequest = [PHManager() action:self.actionLabel latestUpdateAction:self.latestUpdateActionLabel];
		}else{
			self.refreshActionButton.disable = TRUE;
			
			[self.autoUpdateActionTimer invalidate];
			[self.autoUpdateActionRequest cancel];
			self.autoUpdateActionRequest = [PHManager() action:self.actionLabel latestUpdateAction:self.latestUpdateActionLabel];
			self.autoUpdateActionTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(autoUpdateAction) userInfo:nil repeats:TRUE];
		}
	}
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
	}else if( !PHManager().selectedAccount ){
		[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"請先登錄。" cancelButtonTitle:@"確定"];
	}else{
		if( [self.refreshActionButton isEqual:sender] ){
			[PHManager() action:self.actionLabel latestUpdateAction:self.latestUpdateActionLabel];
		}else if( [self.missionButton isEqual:sender] ){
			MissionTableViewController* viewController = [MissionTableViewController loadNib];
			viewController.title = [self.missionButton titleForState:UIControlStateNormal];
			[self.navigationController pushViewController:viewController animated:TRUE];
		}else if( [self.friendButton isEqual:sender] ){
			FriendTableViewController* viewController = [FriendTableViewController loadNib];
			viewController.title = [self.friendButton titleForState:UIControlStateNormal];
			[self.navigationController pushViewController:viewController animated:TRUE];
		}else if( [self.itemButton isEqual:sender] ){
			ItemTableViewController* viewController = [ItemTableViewController loadNib];
			viewController.title = [self.itemButton titleForState:UIControlStateNormal];
			[self.navigationController pushViewController:viewController animated:TRUE];
		}else if( [self.autoBattleButton isEqual:sender] ){
			[self.autoBattleAlertView show];
		}else if( [self.autoChallengeButton isEqual:sender] ){
			PHManager().autoChallenge = TRUE;
			[PHManager() challenge];
		}else if( [self.scheduleButton isEqual:sender] ){
			ScheduleTableViewController* viewController = [ScheduleTableViewController loadNib];
			viewController.title = [self.scheduleButton titleForState:UIControlStateNormal];
			[self.navigationController pushViewController:viewController animated:TRUE];
		}else if( [self.settingButton isEqual:sender] ){
			SettingTableViewController* viewController = [SettingTableViewController loadNib];
			[self.navigationController pushViewController:viewController animated:TRUE];
		}
	}
}

#pragma mark - Private Functions

-(UIAlertView*)autoBattleAlertView{
	if( !_autoBattleAlertView ){
		_autoBattleAlertView = [[UIAlertView alloc] initWithTitle:ApplicationName() message:@"\n\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
		_autoBattleAlertView.delegate = self;
	}
	return _autoBattleAlertView;
}

-(void)loginDidSuccess:(NSNotification *)notification{
	[self viewWillAppear:TRUE];
}

-(void)loginDidFail:(NSNotification *)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"登錄失敗。" cancelButtonTitle:@"確定"];
}

-(void)challengeDidSuccess:(NSNotification*)notification{
	NSArray* challenges = [notification object];
	NSString* message = [NSString stringWithFormat:@"自動打擂台次數: %d", challenges.count];
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:message cancelButtonTitle:@"確定"];
	[self click:self.refreshActionButton];
}

-(void)challengeDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"自動打擂台失敗。" cancelButtonTitle:@"確定"];
}

-(void)battleDidSuccess:(NSNotification*)notification{
	NSArray* battles = [notification object];
	__block int totalExp = 0;
	__block NSMutableString* message = [NSMutableString stringWithFormat:@"自動戰鬥次數: %d", battles.count];
	__block NSMutableArray* bonusList = [NSMutableArray array];
	[battles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		PetHunterBattle* battle = obj;
		totalExp += [battle.exp intValue];
		if( battle.bonus.length != 0 ){
			NSArray* array = [battle.bonus componentsSeparatedByString:@","];
			[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
				[bonusList addObject:obj];
			}];
		}
	}];
	[message appendFormat:@"\n獎勵:\n%@", [bonusList componentsJoinedByString:@"\n"]];
	[message appendFormat:@"\n總經驗: %d", totalExp];
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:message cancelButtonTitle:@"確定"];
	[self click:self.refreshActionButton];
}

-(void)battleDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"自動戰鬥失敗。" cancelButtonTitle:@"確定"];
}

-(void)autoUpdateAction{
	YTLogF();
	[self.autoUpdateActionRequest cancel];
	self.autoUpdateActionRequest = [PHManager() action:self.actionLabel latestUpdateAction:self.latestUpdateActionLabel];
}

#pragma mark - PetHunterPickerViewDelegate

-(void)confirmButtonDidClick:(PetHunterPickerView*)pickerView selectedTitle:(id<PetHunterPickerTitle>)selectedTitle{
	PetHunterAccount* account = (PetHunterAccount*)selectedTitle;
	
	self.uidTextField.text = account.name;
	self.passwordTextField.text = account.password;
	
	[self click:self.loginButton];
	[pickerView dismiss];
}

#pragma mark - UIAlertViewDelegate

-(void)willPresentAlertView:(UIAlertView *)alertView{
	if( [self.autoBattleAlertView isEqual:alertView] ){
		
		UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertView.width - 24, 31)] autorelease];
		label.backgroundColor = ClearColor();
		label.textColor = WhiteColor();
		label.text = @"普通戰鬥:";
		label.center = CGPointMake(alertView.halfWidth, 60);
		[alertView addSubview:label];
		UITextField* textField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 31)] autorelease];
		textField.tag = 0;
		textField.placeholder = @"普通戰鬥";
		textField.text = PHManager().autoNormalBattleMap == 0 ? @"" : [NSString stringWithFormat:@"%d", PHManager().autoNormalBattleMap];
		textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.center = label.center;
		textField.x = label.maxX - textField.width;
		[alertView addSubview:textField];
		
		label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertView.width - 24, 31)] autorelease];
		label.backgroundColor = ClearColor();
		label.textColor = WhiteColor();
		label.text = @"無雙戰鬥:";
		label.center = CGPointMake(alertView.halfWidth, 95);
		[alertView addSubview:label];
		textField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 31)] autorelease];
		textField.tag = 1;
		textField.placeholder = @"無雙戰鬥";
		textField.text = PHManager().autoSpecialBattleMap == 0 ? @"" : [NSString stringWithFormat:@"%d", PHManager().autoSpecialBattleMap];
		textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.center = label.center;
		textField.x = label.maxX - textField.width;
		[alertView addSubview:textField];
	}
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if( [self.autoBattleAlertView isEqual:alertView] ){
		if( buttonIndex == 1 ){
			NSInteger normalBattle = 0;
			NSInteger specialBattle = 0;
			for( UIView* view in alertView.subviews ){
				if( [view isKindOfClass:[UITextField class]] ){
					NSInteger battle = [((UITextField*)view).text intValue];
					if( view.tag == 0 ){
						normalBattle = battle;
					}else{
						specialBattle = battle;
					}
				}
			}
			if( normalBattle <= 0 || specialBattle <= 0 ){
				[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"必需輸入正確。" cancelButtonTitle:@"確定"];
			}else{
				PHManager().autoNormalBattleMap = normalBattle;
				PHManager().autoSpecialBattleMap = specialBattle;
				[PHManager() specialBattle];
			}
		}
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	RemoveNotifications(self, LoginDidSuccessNotification, LoginDidFailNotification, nil);
	RemoveNotifications(self, ChallengeDidSuccessNotification, ChallengeDidFailNotification, nil);
	
	[_settingButton release];
	[_uidTextField release];
	[_passwordTextField release];
	[_loginButton release];
	[_earlyLoginButton release];
	[_actionLabel release];
	[_latestUpdateActionLabel release];
	[_refreshActionButton release];
	[_missionButton release];
	[_friendButton release];
	[_itemButton release];
	[_autoBattleButton release];
	[_autoChallengeButton release];
	[_scheduleButton release];
	
	[_autoBattleAlertView release];
	
	[_autoUpdateActionRequest release];
	[_autoUpdateActionTimer release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize settingButton = _settingButton;
@synthesize uidTextField = _uidTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize loginButton = _loginButton;
@synthesize earlyLoginButton = _earlyLoginButton;
@synthesize actionLabel = _actionLabel;
@synthesize latestUpdateActionLabel = _latestUpdateActionLabel;
@synthesize refreshActionButton = _refreshActionButton;
@synthesize missionButton = _missionButton;
@synthesize friendButton = _friendButton;
@synthesize itemButton = _itemButton;
@synthesize autoBattleButton = _autoBattleButton;
@synthesize autoChallengeButton = _autoChallengeButton;
@synthesize scheduleButton = _scheduleButton;

@synthesize autoBattleAlertView = _autoBattleAlertView;

@synthesize autoUpdateActionRequest = _autoUpdateActionRequest;
@synthesize autoUpdateActionTimer = _autoUpdateActionTimer;

@end