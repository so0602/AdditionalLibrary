#import "PetHunterFriendGift.h"

@implementation PetHunterFriendGift

-(NSString*)name{
	return [self.data objectForKey:PetHunterFriendGift_Name];
}
-(void)setName:(NSString *)name{
	[_data setNilObject:name forKey:PetHunterFriendGift_Name];
}

#pragma mark - PetHunterFriendGift

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	self.name = resultString;
}

@end

NSString* PetHunterFriendGift_Name = @"name";