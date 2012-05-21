#import "FriendTableViewController.h"

#import "PetHunterFriend.h"
#import "PetHunterFriendGift.h"

@interface FriendTableViewController ()

@property (nonatomic, retain) UIBarButtonItem* giftButton;

-(void)friendListDidSuccess:(NSNotification*)notification;
-(void)friendListDidFail:(NSNotification*)notification;

-(void)friendGiftsDidSuccess:(NSNotification*)notification;
-(void)friendGiftsDidFail:(NSNotification*)notification;

@end

@implementation FriendTableViewController

-(void)viewDidLoad{
	[super viewDidLoad];
	
	self.giftButton = [[[UIBarButtonItem alloc] initWithTitle:@"收禮物" style:UIBarButtonItemStyleBordered target:self action:@selector(click:)] autorelease];
	UINavigationItem* navigationItem = self.navigationItem;
	navigationItem.rightBarButtonItem = self.giftButton;
	
	RemoveNotifications(self, FriendListDidSuccessNotification, FriendListDidFailNotification, nil);
	AddNotification(self, @selector(friendListDidSuccess:), FriendListDidSuccessNotification, nil);
	AddNotification(self, @selector(friendListDidFail:), FriendListDidFailNotification, nil);
	
	RemoveNotifications(self, FriendGiftsDidSuccessNotification, FriendGiftsDidFailNotification, nil);
	AddNotification(self, @selector(friendGiftsDidSuccess:), FriendGiftsDidSuccessNotification, nil);
	AddNotification(self, @selector(friendGiftsDidFail:), FriendGiftsDidFailNotification, nil);
	
	[PHManager() friendList];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	RemoveNotifications(self, FriendListDidSuccessNotification, FriendListDidFailNotification, nil);
	RemoveNotifications(self, FriendGiftsDidSuccessNotification, FriendGiftsDidFailNotification, nil);
}

#pragma mark - UIViewController Additions

+(id)loadNib{
	return [[[self alloc] initWithNibName:@"PetHunterTableViewController" bundle:nil] autorelease];
}

-(void)click:(id)sender{
	[super click:sender];
	
	if( [self.giftButton isEqual:sender] ){
		NSArray* friends = self.data;
		NSMutableArray* hasGiftFriends = [NSMutableArray array];
		[friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
			PetHunterFriend* friend = obj;
			if( friend.hasGift ){
				[hasGiftFriends addObject:friend];
			}
		}];
		[PHManager() friendGifts:hasGiftFriends];
	}
}

#pragma mark - Private Functions

-(void)friendListDidSuccess:(NSNotification*)notification{
	NSArray<PetHunterFriend>* data = [notification object];
	self.data = data;
	
	[self.tableView reloadData];
}

-(void)friendListDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"朋友失敗。" cancelButtonTitle:@"確定"];
}

-(void)friendGiftsDidSuccess:(NSNotification*)notification{
	NSArray* friendGifts = [notification object];
	NSMutableArray* strings = [NSMutableArray array];
	[friendGifts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		PetHunterFriendGift* gift = obj;
		[strings addObject:gift.name];
	}];
	
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:[strings componentsJoinedByString:@"\n"] cancelButtonTitle:@"確定"];
	
	[PHManager() friendList];
}

-(void)friendGiftsDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"收禮物失敗。" cancelButtonTitle:@"確定"];
}

#pragma mark - Memory Management

-(void)dealloc{
	RemoveNotifications(self, FriendListDidSuccessNotification, FriendListDidFailNotification, nil);
	RemoveNotifications(self, FriendGiftsDidSuccessNotification, FriendGiftsDidFailNotification, nil);
	[_giftButton release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize giftButton = _giftButton;

@end