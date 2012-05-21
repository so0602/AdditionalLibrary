#import "PetHunterUseItemInput.h"

@implementation PetHunterUseItemInput

-(NSString*)index{
	return [self.data objectForKey:PetHunterUseItemInput_Index];
}
-(void)setIndex:(NSString *)index{
	[_data setNilObject:index forKey:PetHunterUseItemInput_Index];
}

-(NSString*)index1{
	return [self.data objectForKey:PetHunterUseItemInput_Index1];
}
-(void)setIndex1:(NSString *)index1{
	[_data setNilObject:index1 forKey:PetHunterUseItemInput_Index1];
}

#pragma mark - PetHunterDataSourceInput

-(NSString*)method{
	return @"show";
}

-(NSString*)showId{
	return @"50";
}

@end

NSString* PetHunterUseItemInput_Index = @"index";
NSString* PetHunterUseItemInput_Index1 = @"index1";