#import "PetHunterItemListInput.h"

@implementation PetHunterItemListInput

-(NSString*)page{
	return [self.data objectForKey:PetHunterItemListInput_Page];
}
-(void)setPage:(NSString *)page{
	[_data setNilObject:page forKey:PetHunterItemListInput_Page];
}

-(NSString*)count{
	return [self.data objectForKey:PetHunterItemListInput_Count];
}
-(void)setCount:(NSString *)count{
	[_data setNilObject:count forKey:PetHunterItemListInput_Count];
}

-(NSString*)ttype{
	return @"1";
}

#pragma mark - PetHunterDataSourceInput

-(NSString*)method{
	return @"show";
}

-(NSString*)showId{
	return @"22";
}

@end

NSString* PetHunterItemListInput_Page = @"p";
NSString* PetHunterItemListInput_Count = @"n";
NSString* PetHunterItemListInput_TType = @"ttype";