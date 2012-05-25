#import "PetHunterFriend.h"

@implementation PetHunterFriend

-(NSString*)ID{
	return [self.data objectForKey:PetHunterFriend_ID];
}
-(void)setID:(NSString *)ID{
	[_data setNilObject:ID forKey:PetHunterFriend_ID];
}

-(NSString*)name{
	return [self.data objectForKey:PetHunterFriend_Name];
}
-(void)setName:(NSString *)name{
	[_data setNilObject:name forKey:PetHunterFriend_Name];
}

-(NSString*)status{
	return [self.data objectForKey:PetHunterFriend_Status];
}
-(void)setStatus:(NSString *)status{
	[_data setNilObject:status forKey:PetHunterFriend_Status];
}

-(BOOL)hasGift{
	return [self.status intValue] == 2;
}

#pragma mark - PetHunterDataSource

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	NSArray* components = [resultString componentsSeparatedByString:@","];
	if( components.count == 5 ){
		self.ID = [components objectAtIndex:1];
		self.status = [components objectAtIndex:2];
		self.name = [components objectAtIndex:3];
	}
}

#pragma mark - PetHunterTableViewDataSource

-(NSString*)tableTitle{
	return [NSString stringWithFormat:@"%@ (%@禮物)", self.name, self.hasGift ? @"有" : @"無"];
}

@end

NSString* PetHunterFriend_ID = @"ID";
NSString* PetHunterFriend_Name = @"Name";
NSString* PetHunterFriend_Status = @"Status";