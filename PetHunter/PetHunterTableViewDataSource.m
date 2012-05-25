#import "PetHunterTableViewDataSource.h"

@implementation PetHunterTableViewDataSource

-(NSString*)tableTitle{
	return [self.data objectForKey:PetHunterTableViewDataSource_TableTitle];
}
-(void)setTableTitle:(NSString *)tableTitle{
	[_data setNilObject:tableTitle forKey:PetHunterTableViewDataSource_TableTitle];
}

@end

NSString* PetHunterTableViewDataSource_TableTitle = @"TableTitle";