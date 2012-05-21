#import "PetHunterBattle.h"

@implementation PetHunterBattle

-(NSString*)actionCount{
	return [self.data objectForKey:PetHunterBattle_ActionCount];
}
-(void)setActionCount:(NSString *)actionCount{
	[_data setNilObject:actionCount forKey:PetHunterBattle_ActionCount];
}

-(NSString*)maxActionCount{
	return [self.data objectForKey:PetHunterBattle_MaxActionCount];
}
-(void)setMaxActionCount:(NSString *)maxActionCount{
	[_data setNilObject:maxActionCount forKey:PetHunterBattle_MaxActionCount];
}

-(NSString*)challengeCount{
	return [self.data objectForKey:PetHunterBattle_ChallengeCount];
}
-(void)setChallengeCount:(NSString *)challengeCount{
	[_data setNilObject:challengeCount forKey:PetHunterBattle_ChallengeCount];
}

-(NSString*)maxChallengeCount{
	return [self.data objectForKey:PetHunterBattle_MaxChallengeCount];
}
-(void)setMaxChallengeCount:(NSString *)maxChallengeCount{
	[_data setNilObject:maxChallengeCount forKey:PetHunterBattle_MaxChallengeCount];
}

-(NSString*)boost{
	return [self.data objectForKey:PetHunterBattle_Boost];
}
-(void)setBoost:(NSString *)boost{
	[_data setNilObject:boost forKey:PetHunterBattle_Boost];
}

-(NSString*)exp{
	return [self.data objectForKey:PetHunterBattle_Exp];
}
-(void)setExp:(NSString *)exp{
	[_data setNilObject:exp forKey:PetHunterBattle_Exp];
}

-(NSString*)bonus{
	return [self.data objectForKey:PetHunterBattle_Bonus];
}
-(void)setBonus:(NSString *)bonus{
	[_data setNilObject:bonus forKey:PetHunterBattle_Bonus];
}

#pragma mark - PetHunterDataSource

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	if( [resultString rangeOfString:@":"].length != 0 ){
		self.exp = @"0";
		self.boost = @"0";
	}else{
		NSArray* components = [resultString componentsSeparatedByString:@","];
		if( components.count == 12 ){
			self.exp = [components objectAtIndex:4];
			self.boost = [components objectAtIndex:9];
		}
	}
}

@end

NSString* PetHunterBattle_ActionCount = @"ActionCount";
NSString* PetHunterBattle_MaxActionCount = @"MaxActionCount";
NSString* PetHunterBattle_ChallengeCount = @"ChallengeCount";
NSString* PetHunterBattle_MaxChallengeCount = @"MaxChallengeCount";
NSString* PetHunterBattle_Boost = @"Boost";
NSString* PetHunterBattle_Exp = @"Exp";
NSString* PetHunterBattle_Bonus = @"Bonus";