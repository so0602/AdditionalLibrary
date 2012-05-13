#import "PetHunterDataSourceInput.h"

@implementation PetHunterDataSourceInput

-(NSString*)uid{
	return [self.data objectForKey:PetHunterDataSourceInput_Uid];
}
-(void)setUid:(NSString *)uid{
	[_data setNilObject:uid forKey:PetHunterDataSourceInput_Uid];
}

-(NSString*)time{
	return [NSString stringWithFormat:@"%0.f", [NSDate.date timeIntervalSince1970] * 1000];
}

-(NSString*)method{
	return nil;
}

-(NSString*)password{
	return [self.data objectForKey:PetHunterDataSourceInput_Password];
}
-(void)setPassword:(NSString *)password{
	[_data setNilObject:password forKey:PetHunterDataSourceInput_Password];
}

-(NSString*)type{
	return @"flash";
}

-(NSString*)showId{
	return nil;
}

-(NSMutableDictionary*)postData{
	if( !self.uid ){
		PetHunterAccount* account = PHManager().selectedAccount;
		self.uid = account.name;
		self.password = account.password;
	}
	NSMutableDictionary* postData = [NSMutableDictionary dictionaryWithDictionary:self.data];
	[postData setNilObject:self.time forKey:PetHunterDataSourceInput_Time];
	[postData setNilObject:self.method forKey:PetHunterDataSourceInput_Method];
	[postData setNilObject:self.type forKey:PetHunterDataSourceInput_Type];
	[postData setNilObject:self.showId forKey:PetHunterDataSourceInput_ShowId];
	
	return postData;
}

@end

NSString* PetHunterDataSourceInput_Uid = @"uid";
NSString* PetHunterDataSourceInput_Time = @"r";
NSString* PetHunterDataSourceInput_Method = @"m";
NSString* PetHunterDataSourceInput_Password = @"pwd";
NSString* PetHunterDataSourceInput_Type = @"type";
NSString* PetHunterDataSourceInput_ShowId = @"showId";