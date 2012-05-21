#import "PetHunterMissionCompleteInput.h"

@implementation PetHunterMissionCompleteInput

-(NSString*)ttype{
	return [self.data objectForKey:PetHunterCompleteMissionInput_TType];
}
-(void)setTtype:(NSString *)ttype{
	[_data setNilObject:ttype forKey:PetHunterCompleteMissionInput_TType];
}

-(NSString*)gid{
	return [self.data objectForKey:PetHunterCompleteMissionInput_Gid];
}
-(void)setGid:(NSString *)gid{
	[_data setNilObject:gid forKey:PetHunterCompleteMissionInput_Gid];
}

#pragma mark - PetHunterDataSourceInput

-(NSString*)method{
	return @"show";
}

-(NSString*)showId{
	return @"47";
}

@end

NSString* PetHunterCompleteMissionInput_TType = @"ttype";
NSString* PetHunterCompleteMissionInput_Gid = @"gid";