#import "PetHunterItem.h"

@implementation PetHunterItem

-(NSString*)ID{
	return [self.data objectForKey:PetHunterItem_ID];
}
-(void)setID:(NSString *)ID{
	[_data setNilObject:ID forKey:PetHunterItem_ID];
}

-(NSString*)name{
	return [self.data objectForKey:PetHunterItem_Name];
}
-(void)setName:(NSString *)name{
	[_data setNilObject:name forKey:PetHunterItem_Name];
}

-(NSString*)count{
	return [self.data objectForKey:PetHunterItem_Count];
}
-(void)setCount:(NSString *)count{
	[_data setNilObject:count forKey:PetHunterItem_Count];
}

#pragma mark - PetHunterTableViewDataSource

-(NSString*)tableTitle{
	return [NSString stringWithFormat:@"%@ (%@件)", self.name, self.count];
}

#pragma mark - PetHunterDataSource

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	NSArray* components = [resultString componentsSeparatedByString:@","];
	if( components.count == 8 ){
		self.ID = [components objectAtIndex:0];
		self.name = [components objectAtIndex:2];
		self.count = [components objectAtIndex:3];
	}
}

@end

NSString* PetHunterItem_ID = @"ID";
NSString* PetHunterItem_Name = @"Name";
NSString* PetHunterItem_Count = @"Count";