#import "PetHunterMissionDetailInput.h"

@implementation PetHunterMissionDetailInput

-(NSString*)gid{
	return [self.data objectForKey:PetHunterMissionDetailInput_Gid];
}
-(void)setGid:(NSString *)gid{
	[_data setNilObject:gid forKey:PetHunterMissionDetailInput_Gid];
}

#pragma mark - PetHunterDataSourceInput

-(NSString*)showId{
	return @"46";
}

@end

NSString* PetHunterMissionDetailInput_Gid = @"gid";