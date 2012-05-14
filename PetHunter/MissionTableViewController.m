#import "MissionTableViewController.h"

#import "PetHunterMission.h"
#import "PetHunterMissionDetail.h"

@interface MissionTableViewController ()

-(void)missionListDidSuccess:(NSNotification*)notification;
-(void)missionListDidFail:(NSNotification*)notification;

-(void)missionDetailDidSuccess:(NSNotification*)notification;
-(void)missionDetailDidFail:(NSNotification*)notification;

-(void)missionCompleteDidSuccess:(NSNotification*)notification;
-(void)missionCompleteDidFail:(NSNotification*)notification;

@end

@implementation MissionTableViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
	[super viewDidLoad];
	
	RemoveNotifications(self, MissionListDidSuccessNotification, MissionListDidFailNotification, nil);
	AddNotification(self, @selector(missionListDidSuccess:), MissionListDidSuccessNotification, nil);
	AddNotification(self, @selector(missionListDidFail:), MissionListDidFailNotification, nil);
	
	RemoveNotifications(self, MissionDetailDidSuccessNotification, MissionDetailDidFailNotification, nil);
	AddNotification(self, @selector(missionDetailDidSuccess:), MissionDetailDidSuccessNotification, nil);
	AddNotification(self, @selector(missionDetailDidFail:), MissionDetailDidFailNotification, nil);
	
	RemoveNotifications(self, MissionCompleteDidSuccessNotification, MissionCompleteDidFailNotification, nil);
	AddNotification(self, @selector(missionCompleteDidSuccess:), MissionCompleteDidSuccessNotification, nil);
	AddNotification(self, @selector(missionCompleteDidFail:), MissionCompleteDidFailNotification, nil);
	
	[PHManager() showMissionList];
}

#pragma mark - UIViewController Additions

+(id)loadNib{
	return [[[self alloc] initWithNibName:@"PetHunterTableViewController" bundle:nil] autorelease];
}

#pragma mark - Private Functions

-(void)missionListDidSuccess:(NSNotification*)notification{
	NSArray<PetHunterMission>* missions = [notification object];
	self.data = missions;
	
	[self.tableView reloadData];
}

-(void)missionListDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"任務表失敗。" cancelButtonTitle:@"確定"];
}

-(void)missionDetailDidSuccess:(NSNotification*)notification{
	PetHunterMissionDetail* dataSource = [notification object];
	[PHManager() missionComplete:dataSource.gid ttype:dataSource.ttype];
}

-(void)missionDetailDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"詳細任務失敗。" cancelButtonTitle:@"確定"];
}

-(void)missionCompleteDidSuccess:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"完成任務。" cancelButtonTitle:@"確定"];
	[PHManager() showMissionList];
}

-(void)missionCompleteDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"完成任務失敗。" cancelButtonTitle:@"確定"];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	PetHunterMission* mission = [self.data objectAtIndex:indexPath.row];
	[PHManager() missionDetail:mission.ID];
}

#pragma mark - Memory Management

-(void)dealloc{
	RemoveNotifications(self, MissionListDidSuccessNotification, MissionListDidFailNotification, nil);
	RemoveNotifications(self, MissionDetailDidSuccessNotification, MissionDetailDidFailNotification, nil);
	RemoveNotifications(self, MissionCompleteDidSuccessNotification, MissionCompleteDidFailNotification, nil);
	
	[super dealloc];
}

#pragma mark - @synthesize

@end