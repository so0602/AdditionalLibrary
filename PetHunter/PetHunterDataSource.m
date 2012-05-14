#import "PetHunterDataSource.h"

@implementation PetHunterDataSource

-(NSString*)resultString{
	return [self.data objectForKey:PetHunterDataSource_ResultString];
}
-(void)setResultString:(NSString *)resultString{
	[_data setNilObject:resultString forKey:PetHunterDataSource_ResultString];
}

@end

NSString* PetHunterDataSource_ResultString = @"ResultString";