#import "PetHunterAction.h"

@implementation PetHunterAction

-(NSString*)hunting{
	return [self.data objectForKey:PetHunterAction_Hunting];
}
-(void)setHunting:(NSString *)hunting{
	[_data setNilObject:hunting forKey:PetHunterAction_Hunting];
}

-(NSString*)maxHunting{
	return [self.data objectForKey:PetHunterAction_MaxHunting];
}
-(void)setMaxHunting:(NSString *)maxHunting{
	[_data setNilObject:maxHunting forKey:PetHunterAction_MaxHunting];
}

-(NSString*)challenge{
	return [self.data objectForKey:PetHunterAction_Challenge];
}
-(void)setChallenge:(NSString *)challenge{
	[_data setNilObject:challenge forKey:PetHunterAction_Challenge];
}

-(NSString*)maxChallenge{
	return [self.data objectForKey:PetHunterAction_MaxChallenge];
}
-(void)setMaxChallenge:(NSString *)maxChallenge{
	[_data setNilObject:maxChallenge forKey:PetHunterAction_MaxChallenge];
}

#pragma mark - PetHunterDataSource

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	NSArray* components = [resultString componentsSeparatedByString:@","];
	if( components.count == 12 ){
		self.hunting = [components objectAtIndex:7];
		self.maxHunting = [components objectAtIndex:8];
		self.challenge = [components objectAtIndex:9];
		self.maxChallenge = [components objectAtIndex:10];
	}
}

@end

NSString* PetHunterAction_Hunting = @"Hunting";
NSString* PetHunterAction_MaxHunting = @"MaxHunting";
NSString* PetHunterAction_Challenge = @"Challenge";
NSString* PetHunterAction_MaxChallenge = @"MaxChallenge";