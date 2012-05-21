#import "PetHunterChallenge.h"

@implementation PetHunterChallenge

-(NSString*)actionCount{
	return [self.data objectForKey:PetHunterChallenge_ActionCount];
}
-(void)setActionCount:(NSString *)actionCount{
	[_data setNilObject:actionCount forKey:PetHunterChallenge_ActionCount];
}

-(NSString*)maxActionCount{
	return [self.data objectForKey:PetHunterChallenge_MaxActionCount];
}
-(void)setMaxActionCount:(NSString *)maxActionCount{
	[_data setNilObject:maxActionCount forKey:PetHunterChallenge_MaxActionCount];
}

-(NSString*)challengeCount{
	return [self.data objectForKey:PetHunterChallenge_ChallengeCount];
}
-(void)setChallengeCount:(NSString *)challengeCount{
	[_data setNilObject:challengeCount forKey:PetHunterChallenge_ChallengeCount];
}

-(NSString*)maxChallengeCount{
	return [self.data objectForKey:PetHunterChallenge_MaxChallengeCount];
}
-(void)setMaxChallengeCount:(NSString *)maxChallengeCount{
	[_data setNilObject:maxChallengeCount forKey:PetHunterChallenge_MaxChallengeCount];
}

@end

NSString* PetHunterChallenge_ActionCount = @"ActionCount";
NSString* PetHunterChallenge_MaxActionCount = @"MaxActionCount";
NSString* PetHunterChallenge_ChallengeCount = @"ChallengeCount";
NSString* PetHunterChallenge_MaxChallengeCount = @"MaxChallengeCount";