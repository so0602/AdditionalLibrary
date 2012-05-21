#import "PetHunterFriendInput.h"

@implementation PetHunterFriendInput

-(NSString*)page{
	return [self.data objectForKey:PetHunterFriendInput_Page];
}
-(void)setPage:(NSString *)page{
	[_data setNilObject:page forKey:PetHunterFriendInput_Page];
}

-(NSString*)count{
	return @"6";
}

#pragma mark - PetHunterDataSourceInput

-(NSString*)showId{
	return @"51";
}

-(NSString*)method{
	return @"show";
}

-(NSMutableDictionary*)postData{
	NSMutableDictionary* postData = super.postData;
	
	[postData setNilObject:self.count forKey:PetHunterFriendInput_Count];
	
	return postData;
}

@end

NSString* PetHunterFriendInput_Page = @"p";
NSString* PetHunterFriendInput_Count = @"n";