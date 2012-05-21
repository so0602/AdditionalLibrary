#import "PetHunterMap.h"

@implementation PetHunterMap

-(NSString*)ID{
	return [self.data objectForKey:PetHunterMap_ID];
}

-(NSString*)rate{
	return [self.data objectForKey:PetHunterMap_Rate];
}

-(BOOL)isFinish{
	return [[self.data objectForKey:PetHunterMap_IsFinish] boolValue];
}

-(NSString*)name{
	return [self.data objectForKey:PetHunterMap_Name];
}

#pragma mark - PetHunterDataSource

#pragma mark - PetHunterTableViewDataSource

-(NSString*)tableTitle{
	return [NSString stringWithFormat:@"%@ (完成度:%@%%)", self.name, self.rate];
}

@end

NSString* PetHunterMap_ID = @"id";
NSString* PetHunterMap_Rate = @"rate";
NSString* PetHunterMap_IsFinish = @"is_finish";
NSString* PetHunterMap_Name = @"name";