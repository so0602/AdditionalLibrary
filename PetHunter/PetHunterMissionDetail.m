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
	
	NSArray* array = [resultString componentsSeparatedByString:@","];
	if( array.count < 2 ) return;
	self.ttype = [array objectAtIndex:0];
	self.gid = [array objectAtIndex:1];
}

@end

NSString* PetHunterMissionDetail_TType = @"ttype";
NSString* PetHunterMissionDetail_Gid = @"gid";