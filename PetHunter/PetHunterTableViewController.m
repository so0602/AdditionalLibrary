#import "PetHunterTableViewController.h"

@interface PetHunterTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PetHunterTableViewController

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( !cell ) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
	PetHunterTableViewDataSource* data = [self.data objectAtIndex:indexPath.row];
	
	cell.textLabel.text = data.tableTitle;
	
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

#pragma mark - Memory Management

-(void)dealloc{
	[_data release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize data = _data;

@end