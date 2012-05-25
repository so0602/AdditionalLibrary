#import "PetHunterMissionDetail.h"

@implementation PetHunterMissionDetail

-(NSString*)ttype{
	return [self.data objectForKey:PetHunterMissionDetail_TType];
}
-(void)setTtype:(NSString *)ttype{
	[_data setNilObject:ttype forKey:PetHunterMissionDetail_TType];
}

-(NSString*)gid{
	return [self.data objectForKey:PetHunterMissionDetail_Gid];
}
-(void)setGid:(NSString *)gid{
	[_data setNilObject:gid forKey:PetHunterMissionDetail_Gid];
}

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	NSArray* components = [resultString componentsSeparatedByString:@","];
	if( components.count >= 2 ){
		self.ttype = [components objectAtIndex:0];
		self.gid = [components objectAtIndex:1];
	}
}

@end

NSString* PetHunterMissionDetail_TType = @"ttype";
NSString* PetHunterMissionDetail_Gid = @"gid";