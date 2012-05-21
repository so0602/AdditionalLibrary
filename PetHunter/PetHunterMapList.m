#import "PetHunterMapList.h"

@implementation PetHunterMapList

#pragma mark - PetHunterDataSource

-(void)setResultString:(NSString *)resultString{
	[super setResultString:resultString];
	
	NSDictionary* dictionary = [resultString JSONValue];
	NSArray* dictionaries = [dictionary objectForKey:PetHunterMapList_Maps];
	self.maps = (NSArray<PetHunterMap>*)[PetHunterMap arrayWithDictionaries:dictionaries];
}

#pragma mark - Memory Management

-(void)dealloc{
	[_maps release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize maps = _maps;

@end

NSString* PetHunterMapList_Maps = @"maps";