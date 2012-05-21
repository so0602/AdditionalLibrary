#import "PetHunterChallengeGift.h"

@implementation PetHunterChallengeGift

-(NSString*)name{
	return [self.data objectForKey:PetHunterChallengeGift_Name];
}
-(void)setName:(NSString *)name{
	[_data setNilObject:name forKey:PetHunterChallengeGift_Name];
}

-(NSString*)gift{
	return [self.data objectForKey:PetHunterChallengeGift_Gift];
}
-(void)setGift:(NSString *)gift{
	[_data setNilObject:gift forKey:PetHunterChallengeGift_Gift];
}

#pragma mark - PetHunterDataSource

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	NSArray* components = [resultString componentsSeparatedByString:@","];
	if( components.count == 2 ){
		self.name = [components objectAtIndex:0];
		self.gift = [components objectAtIndex:1];
	}
}

@end

NSString* PetHunterChallengeGift_Name = @"Name";
NSString* PetHunterChallengeGift_Gift = @"Gift";