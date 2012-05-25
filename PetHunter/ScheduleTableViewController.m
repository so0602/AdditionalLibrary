#import "ScheduleTableViewController.h"

@interface ScheduleTableViewController ()<UIActionSheetDelegate>

@property (nonatomic, retain) UIBarButtonItem* addButton;
@property (nonatomic, retain) UIActionSheet* repeatActionSheet;
@property (nonatomic, assign) NSUInteger repeatType;
@property (nonatomic, retain) UIActionSheet* autoEventActionSheet;
@property (nonatomic, assign) NSUInteger autoEventType;

@end

@implementation ScheduleTableViewController

-(void)viewDidLoad{
	[super viewDidLoad];
	
	UINavigationItem* navigationItem = self.navigationItem;
	navigationItem.rightBarButtonItem = self.addButton;
}

#pragma mark - UIViewController Additions

+(id)loadNib{
	return [[[self alloc] initWithNibName:@"PetHunterTableViewController" bundle:nil] autorelease];
}

-(void)click:(id)sender{
	[super click:sender];
	
	if( [self.addButton isEqual:sender] ){
		[self.repeatActionSheet showInView:self.view];
	}
}

#pragma mark - Private Functions

-(UIBarButtonItem*)addButton{
	if( !_addButton ){
		_addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(click:)];
	}
	return _addButton;
}

-(UIActionSheet*)repeatActionSheet{
	if( !_repeatActionSheet ){
		_repeatActionSheet = [[UIActionSheet alloc] initWithTitle:ApplicationName() delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"每日", @"每小時", nil];
		_repeatActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	}
	return _repeatActionSheet;
}

-(UIActionSheet*)autoEventActionSheet{
	if( !_autoEventActionSheet ){
		_autoEventActionSheet = [[UIActionSheet alloc] initWithTitle:ApplicationName() delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"自動戰鬥", @"自動打擂台", nil];
		_autoEventActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	}
	return _autoEventActionSheet;
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if( [actionSheet isEqual:self.repeatActionSheet] ){
		if( buttonIndex != actionSheet.cancelButtonIndex ){
			self.repeatType = buttonIndex;
			[self.autoEventActionSheet showInView:self.view];
		}
	}else if( [actionSheet isEqual:self.autoEventActionSheet] ){
		if( buttonIndex != actionSheet.cancelButtonIndex ){
			self.autoEventType = buttonIndex;
			
			UILocalNotification* notification = [[[UILocalNotification alloc] init] autorelease];
			notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
			[SharedApplication() scheduleLocalNotification:notification];
			
			NSMutableArray<PetHunterTableViewDataSource>* array = [NSMutableArray array];
			NSArray* notifications = [SharedApplication() scheduledLocalNotifications];
			[notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
				UILocalNotification* notifi = obj;
				PetHunterTableViewDataSource* dataSource = [PetHunterTableViewDataSource dataSourceWithDictionary:nil];
				dataSource.tableTitle = [notifi description];
				[array addObject:dataSource];
			}];
			self.data = array;
			[self.tableView reloadData];
		}
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	[_addButton release];
	[_repeatActionSheet release];
	[_autoEventActionSheet release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize addButton = _addButton;
@synthesize repeatActionSheet = _repeatActionSheet;
@synthesize repeatType = _repeatType;
@synthesize autoEventActionSheet = _autoEventActionSheet;
@synthesize autoEventType = _autoEventType;

@end