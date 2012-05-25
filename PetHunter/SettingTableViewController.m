#import "SettingTableViewController.h"

#import "DCRoundSwitch.h"

@interface SettingTableViewController ()<UIAlertViewDelegate>

@property (nonatomic, retain) DCRoundSwitch* autoRefreshActionSwitch;
@property (nonatomic, retain) DCRoundSwitch* autoBattleSwitch;

@property (nonatomic, retain) UIAlertView* autoBattleAlertView;

@end

@implementation SettingTableViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
	
	PetHunterTableViewDataSource* dataSource = nil;
	NSMutableArray<PetHunterTableViewDataSource>* data = [NSMutableArray array];
	
	dataSource = [PetHunterTableViewDataSource dataSourceWithDictionary:nil];
	dataSource.tableTitle = @"自動更新狩獵值, 擂台值";
	[data addObject:dataSource];
	
//	dataSource = [PetHunterTableViewDataSource dataSourceWithDictionary:nil];
//	dataSource.tableTitle = @"自動戰鬥";
//	[data addObject:dataSource];
//	
//	dataSource = [PetHunterTableViewDataSource dataSourceWithDictionary:nil];
//	dataSource.tableTitle = @"自動打擂台";
//	[data addObject:dataSource];
	
	self.data = data;
	
	[super viewDidLoad];
}

#pragma mark - UIViewController Additions

+(id)loadNib{
	return [[[self alloc] initWithNibName:@"PetHunterTableViewController" bundle:nil] autorelease];
}

-(void)click:(id)sender{
	[super click:sender];
	
	if( [self.autoRefreshActionSwitch isEqual:sender] ){
		PHManager().autoUpdateAction = self.autoRefreshActionSwitch.isOn;
	}else if( [self.autoBattleSwitch isEqual:sender] ){
		PHManager().autoBattle = self.autoBattleSwitch.isOn;
//		if( self.autoBattleSwitch.isOn ){
//			[self.autoBattleAlertView performSelector:@selector(show) withObject:nil afterDelay:0.1];
//		}
	}
}

#pragma mark - Private Functions

-(DCRoundSwitch*)autoRefreshActionSwitch{
	if( !_autoRefreshActionSwitch ){
		_autoRefreshActionSwitch = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 28)];
		[_autoRefreshActionSwitch addTarget:self action:@selector(click:) forControlEvents:UIControlEventValueChanged];
		[_autoRefreshActionSwitch setOn:PHManager().isAutoUpdateAction animated:FALSE ignoreControlEvents:TRUE];
	}
	return _autoRefreshActionSwitch;
}

-(DCRoundSwitch*)autoBattleSwitch{
	if( !_autoBattleSwitch ){
		_autoBattleSwitch = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 28)];
		[_autoBattleSwitch addTarget:self action:@selector(click:) forControlEvents:UIControlEventValueChanged];
		[_autoBattleSwitch setOn:PHManager().isAutoBattle animated:FALSE ignoreControlEvents:TRUE];
	}
	return _autoBattleSwitch;
}

-(UIAlertView*)autoBattleAlertView{
	if( !_autoBattleAlertView ){
		_autoBattleAlertView = [[UIAlertView alloc] initWithTitle:ApplicationName() message:@"\n\n\n" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
		_autoBattleAlertView.delegate = self;
	}
	return _autoBattleAlertView;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	switch( indexPath.row ){
		case 0:
			cell.accessoryView = self.autoRefreshActionSwitch;
			break;
		case 1:
			cell.accessoryView = self.autoBattleSwitch;
			break;
		default:
			cell.accessoryView = nil;
	}
	
	return cell;
}

#pragma mark - UIAlertViewDelegate

-(void)willPresentAlertView:(UIAlertView *)alertView{
	if( [self.autoBattleAlertView isEqual:alertView] ){
		UITextField* textField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, alertView.width - 24, 31)] autorelease];
		textField.tag = 0;
		textField.placeholder = @"普通戰鬥";
		textField.text = PHManager().autoNormalBattleMap == 0 ? @"" : [NSString stringWithFormat:@"%d", PHManager().autoNormalBattleMap];
		textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.center = CGPointMake(alertView.halfWidth, 60);
		[alertView addSubview:textField];
		
		textField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, alertView.width - 24, 31)] autorelease];
		textField.tag = 1;
		textField.placeholder = @"無雙戰鬥";
		textField.text = PHManager().autoSpecialBattleMap == 0 ? @"" : [NSString stringWithFormat:@"%d", PHManager().autoSpecialBattleMap];
		textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.center = CGPointMake(alertView.halfWidth, 95);
		[alertView addSubview:textField];
	}
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if( [self.autoBattleAlertView isEqual:alertView] ){
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
			[self.autoBattleSwitch setOn:FALSE animated:TRUE];
		}else{
			PHManager().autoNormalBattleMap = normalBattle;
			PHManager().autoSpecialBattleMap = specialBattle;
		}
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	[_autoRefreshActionSwitch release];
	[_autoBattleSwitch release];
	
	[_autoBattleAlertView release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize autoRefreshActionSwitch = _autoRefreshActionSwitch;
@synthesize autoBattleSwitch = _autoBattleSwitch;

@synthesize autoBattleAlertView = _autoBattleAlertView;

@end