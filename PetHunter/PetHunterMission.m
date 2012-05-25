#import "PetHunterMission.h"

@implementation PetHunterMission

-(NSString*)ID{
	return [self.data objectForKey:PetHunterMission_Id];
}
-(void)setID:(NSString *)ID{
	[_data setNilObject:ID forKey:PetHunterMission_Id];
}

-(NSString*)name{
	return [self.data objectForKey:PetHunterMission_Name];
}
-(void)setName:(NSString *)name{
	[_data setNilObject:name forKey:PetHunterMission_Name];
}

-(NSString*)completed{
	return [self.data objectForKey:PetHunterMission_Completed];
}
-(void)setCompleted:(NSString *)completed{
	[_data setNilObject:completed forKey:PetHunterMission_Completed];
}

-(BOOL)isCompleted{
	return [self.completed intValue];
}

#pragma mark - PetHunterDataSource

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	NSArray* components = [resultString componentsSeparatedByString:@","];
	if( components.count == 3 ){
		self.ID = [components objectAtIndex:0];
		self.name = [components objectAtIndex:1];
		self.completed = [components objectAtIndex:2];
	}
}

#pragma mark - PetHunterTableViewDataSource

-(NSString*)tableTitle{
	return [NSString stringWithFormat:@"%@ (%@完成)", self.name, self.isCompleted ? @"" : @"未"];
}

@end

NSString* PetHunterMission_Id = @"Id";
NSString* PetHunterMission_Name = @"Name";
NSString* PetHunterMission_Completed = @"Completed";