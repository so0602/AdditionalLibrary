#import "PetHunterSpecialBattleInput.h"

@implementation PetHunterSpecialBattleInput

-(NSString*)ttype{
	return @"2";
}

#pragma mark - PetHunterDataSourceInput

-(NSMutableDictionary*)postData{
	NSMutableDictionary* postData = [super postData];
	
	[postData setNilObject:self.ttype forKey:PetHunterSpecialBattleInput_TType];
	
	return postData;
}

@end

NSString* PetHunterSpecialBattleInput_TType = @"ttype";