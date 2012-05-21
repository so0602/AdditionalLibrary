#import "ItemTableViewController.h"

#import "PetHunterItem.h"
#import "PetHunterUseItem.h"

@interface ItemTableViewController ()<UIAlertViewDelegate>

-(void)itemListDidSuccess:(NSNotification*)notification;
-(void)itemListDidFail:(NSNotification*)notification;

-(void)useItemDidSuccess:(NSNotification*)notification;
-(void)useItemDidFail:(NSNotification*)notification;

@property (nonatomic, retain) PetHunterItem* selectedItem;
@property (nonatomic, retain) UIAlertView* useItemAlertView;

@end

@implementation ItemTableViewController

-(void)viewDidLoad{
	[super viewDidLoad];
	
	RemoveNotifications(self, ItemListDidSuccessNotification, ItemListDidFailNotification, nil);
	AddNotification(self, @selector(itemListDidSuccess:), ItemListDidSuccessNotification, nil);
	AddNotification(self, @selector(itemListDidFail:), ItemListDidFailNotification, nil);
	
	RemoveNotifications(self, UseItemDidSuccessNotification, UseItemDidFailNotification, nil);
	AddNotification(self, @selector(useItemDidSuccess:), UseItemDidSuccessNotification, nil);
	AddNotification(self, @selector(useItemDidFail:), UseItemDidFailNotification, nil);
	
	[PHManager() itemList];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	RemoveNotifications(self, ItemListDidSuccessNotification, ItemListDidFailNotification, nil);
}

#pragma mark - UIViewController Additions

+(id)loadNib{
	return [[[self alloc] initWithNibName:@"PetHunterTableViewController" bundle:nil] autorelease];
}

#pragma mark - Private Functions

-(void)itemListDidSuccess:(NSNotification*)notification{
	self.data = [notification object];
	[self.tableView reloadData];
}

-(void)itemListDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"道具表失敗。" cancelButtonTitle:@"確定"];
}

-(void)useItemDidSuccess:(NSNotification*)notification{
	NSArray* useItems = [notification object];
	NSMutableArray* resultStrings = [NSMutableArray array];
	[useItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		PetHunterUseItem* item = obj;
		[resultStrings addObject:item.resultString];
	}];
	NSString* message = [NSString stringWithFormat:@"%@", [resultStrings componentsJoinedByString:@"\n"]];
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:message cancelButtonTitle:@"確定"];
	[PHManager() itemList];
}

-(void)useItemDidFail:(NSNotification*)notification{
	[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"使用道具失敗。" cancelButtonTitle:@"確定"];
}

-(UIAlertView*)useItemAlertView{
	if( !_useItemAlertView ){
		_useItemAlertView = [[UIAlertView alloc] initWithTitle:ApplicationName() message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"使用一件", @"使用全部", nil];
	}
	return _useItemAlertView;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	PetHunterItem* item = [self.data objectAtIndex:indexPath.row];
	self.selectedItem = item;
	
	[self.useItemAlertView show];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if( [alertView isEqual:self.useItemAlertView] ){
		switch( buttonIndex ){
			case 1:
				[PHManager() useItem:self.selectedItem useAll:FALSE];
				break;
			case 2:
				[PHManager() useItem:self.selectedItem useAll:TRUE];
				break;
		}
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	RemoveNotifications(self, ItemListDidSuccessNotification, ItemListDidFailNotification, nil);
	
	[_selectedItem release];
	[_useItemAlertView release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize selectedItem = _selectedItem;
@synthesize useItemAlertView = _useItemAlertView;

@end