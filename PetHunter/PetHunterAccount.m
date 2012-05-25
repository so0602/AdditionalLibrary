#import "PetHunterAccount.h"

static NSString* PetHunterAccount_Source = @"Source";

@interface PetHunterAccount()<NSCoding>

@end

@implementation PetHunterAccount

-(NSString*)name{
	return [self.data objectForKey:PetHunterAccount_Name];
}
-(void)setName:(NSString *)name{
	[_data setNilObject:name forKey:PetHunterAccount_Name];
}

-(NSString*)password{
	return [self.data objectForKey:PetHunterAccount_Password];
}
-(void)setPassword:(NSString *)password{
	[_data setNilObject:password forKey:PetHunterAccount_Password];
}

-(BOOL)autoUpdateAction{
	return [[self.data objectForKey:PetHunterAccount_AutoUpdateAction] boolValue];
}
-(void)setAutoUpdateAction:(BOOL)autoUpdateAction{
	[_data setNilObject:[NSNumber numberWithBool:autoUpdateAction] forKey:PetHunterAccount_AutoUpdateAction];
}

-(BOOL)autoBattle{
	return [[self.data objectForKey:PetHunterAccount_AutoBattle] boolValue];
}
-(void)setAutoBattle:(BOOL)autoBattle{
	[_data setNilObject:[NSNumber numberWithBool:autoBattle] forKey:PetHunterAccount_AutoBattle];
}

-(NSInteger)autoNormalBattleMap{
	return [[self.data objectForKey:PetHunterAccount_AutoNormalBattleMap] intValue];
}
-(void)setAutoNormalBattleMap:(NSInteger)autoNormalBattleMap{
	[_data setNilObject:[NSNumber numberWithInt:autoNormalBattleMap] forKey:PetHunterAccount_AutoNormalBattleMap];
}

-(NSInteger)autoSpecialBattleMap{
	return [[self.data objectForKey:PetHunterAccount_AutoSpecialBattleMap] intValue];
}
-(void)setAutoSpecialBattleMap:(NSInteger)autoSpecialBattleMap{
	[_data setNilObject:[NSNumber numberWithInt:autoSpecialBattleMap] forKey:PetHunterAccount_AutoSpecialBattleMap];
}

-(BOOL)autoChallenge{
	return [[self.data objectForKey:PetHunterAccount_AutoChallenge] boolValue];
}
-(void)setAutoChallenge:(BOOL)autoChallenge{
	[_data setNilObject:[NSNumber numberWithBool:autoChallenge] forKey:PetHunterAccount_AutoChallenge];
}

#pragma mark - PetHunterPickerTitle

-(NSString*)title{
	return self.name;
}
-(void)setTitle:(NSString *)title{
}

-(NSArray<PetHunterPickerTitle>*)subtitles{
	return nil;
}
-(void)setSubtitles:(NSArray<PetHunterPickerTitle> *)subtitles{
}

#pragma mark - NSObject

-(BOOL)isEqual:(id)object{
	PetHunterAccount* other = (PetHunterAccount*)object;
	if( ![other isKindOfClass:PetHunterAccount.class] ){
		return FALSE;
	}
	return [self.name isEqualToString:other.name];
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:self.data forKey:PetHunterAccount_Source];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	NSDictionary* data = [aDecoder decodeObjectForKey:PetHunterAccount_Source];
	if( self = [super initWithDictionary:data] ){
	}
	return self;
}

@end

NSString* PetHunterAccount_Name = @"Name";
NSString* PetHunterAccount_Password = @"Password";
NSString* PetHunterAccount_AutoUpdateAction = @"AutoUpdateAction";
NSString* PetHunterAccount_AutoBattle = @"AutoBattle";
NSString* PetHunterAccount_AutoNormalBattleMap = @"AutoNormalBattleMap";
NSString* PetHunterAccount_AutoSpecialBattleMap = @"AutoSpecialBattleMap";
NSString* PetHunterAccount_AutoChallenge = @"AutoChallenge";