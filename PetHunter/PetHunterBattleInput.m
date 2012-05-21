#import "PetHunterBattleInput.h"

@implementation PetHunterBattleInput

-(NSString*)hid{
	return [self.data objectForKey:PetHunterBattleInput_HID];
}
-(void)setHid:(NSString *)hid{
	[_data setNilObject:hid forKey:PetHunterBattleInput_HID];
}

#pragma mark - PetHunterDataSourceInput

-(NSString*)showId{
	return @"6";
}

-(NSString*)method{
	return @"show";
}

-(NSMutableDictionary*)postData{
	NSMutableDictionary* postData = [super postData];
	
	[postData setNilObject:self.hid forKey:PetHunterBattleInput_HID];
	
	return postData;
}

@end

NSString* PetHunterBattleInput_HID = @"hid";