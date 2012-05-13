#import <UIKit/UIKit.h>

#import "PetHunterTableViewDataSource.h"

@interface PetHunterTableViewController : UITableViewController

@property (nonatomic, retain) NSArray<PetHunterTableViewDataSource>* data;

@end