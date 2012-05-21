#import "PetHunterMapListInput.h"

@implementation PetHunterMapListInput

-(NSString*)page{
	return [self.data objectForKey:PetHunterMapListInput_Page];
}
-(void)setPage:(NSString *)page{
	[_data setNilObject:page forKey:PetHunterMapListInput_Page];
}

-(NSString*)count{
	return @"9";
}

#pragma mark - PetHunterDataSourceInput

-(NSString*)showId{
	return @"4";
}

-(NSString*)method{
	return @"show";
}

-(NSMutableDictionary*)postData{
	NSMutableDictionary* postData = super.postData;
	
	[postData setNilObject:self.count forKey:PetHunterMapListInput_Count];
	
	return postData;
}

@end

NSString* PetHunterMapListInput_Page = @"p";
NSString* PetHunterMapListInput_Count = @"n";