#import "PetHunterFriendGiftInput.h"

@implementation PetHunterFriendGiftInput

-(NSString*)gid{
	return [self.data objectForKey:PetHunterFriendGiftInput_Gid];
}
-(void)setGid:(NSString *)gid{
	[_data setNilObject:gid forKey:PetHunterFriendGiftInput_Gid];
}

#pragma mark - PetHunterDataSourceInput

-(NSString*)method{
	return @"show";
}

-(NSString*)showId{
	return @"54";
}

@end

NSString* PetHunterFriendGiftInput_Gid = @"gid";