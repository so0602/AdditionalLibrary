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