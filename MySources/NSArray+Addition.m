#import "NSArray+Addition.h"

@interface NSArray ()

-(NSString*)ignore:(FilteringOption)option;

@end

@implementation NSArray (Addition)

-(id)firstObject{
	return [self objectAtIndex:0];
}

-(id)lastSecondObject{
	return [self objectAtIndex:self.count - 2];
}

#pragma mark - Filtering

-(NSArray*)filteredArrayWithMatch:(NSString*)match{
	return [self filteredArrayWithMatch:match inclusive:TRUE];
}

-(NSArray*)filteredArrayWithMatch:(NSString*)match inclusive:(BOOL)inclusive{
	NSPredicate* predicate = nil;
	if( inclusive ) predicate = [NSPredicate predicateWithFormat:@"SELF == %@", match];
	else predicate = [NSPredicate predicateWithFormat:@"SELF != %@", match];
	
	return [self filteredArrayUsingPredicate:predicate];
}

-(NSArray*)filteredArrayWithIn:(NSArray*)objects{
	return [self filteredArrayWithIn:objects inclusive:TRUE];
}

-(NSArray*)filteredArrayWithIn:(NSArray*)objects inclusive:(BOOL)inclusive{
	NSPredicate* predicate = nil;
	if( inclusive ) predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", objects];
	else predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", objects];
	
	return [self filteredArrayUsingPredicate:predicate];
}

-(NSArray*)filteredArrayWithContains:(NSString*)contains{
	return [self filteredArrayWithContains:contains filteringOption:FilteringOption_None inclusive:TRUE];
}

-(NSArray*)filteredArrayWithContains:(NSString*)contains inclusive:(BOOL)inclusive{
	return [self filteredArrayWithContains:contains filteringOption:FilteringOption_None inclusive:inclusive];
}

-(NSArray*)filteredArrayWithContains:(NSString*)contains filteringOption:(FilteringOption)option{
	return [self filteredArrayWithContains:contains filteringOption:option inclusive:TRUE];
}

-(NSArray*)filteredArrayWithContains:(NSString*)contains filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive{
	NSString* format = nil;
	if( inclusive ) format = [NSString stringWithFormat:@"SELF CONTAINS%@ %%@", [self ignore:option]];
	else format = [NSString stringWithFormat:@"NOT (SELF CONTAINS%@ %%@)", [self ignore:option]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:format, contains];
	return [self filteredArrayUsingPredicate:predicate];
}

-(NSArray*)filteredArrayWithLike:(NSString*)like{
	return [self filteredArrayWithLike:like filteringOption:FilteringOption_None inclusive:TRUE];
}

-(NSArray*)filteredArrayWithLike:(NSString*)like inclusive:(BOOL)inclusive{
	return [self filteredArrayWithLike:like filteringOption:FilteringOption_None inclusive:inclusive];
}

-(NSArray*)filteredArrayWithLike:(NSString*)like filteringOption:(FilteringOption)option{
	return [self filteredArrayWithLike:like filteringOption:option inclusive:TRUE];
}

-(NSArray*)filteredArrayWithLike:(NSString*)like filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive{
	NSString* format = nil;
	if( inclusive ) format = [NSString stringWithFormat:@"SELF LIKE%@ %%@", [self ignore:option]];
	else format = [NSString stringWithFormat:@"NOT (SELF LIKE%@ %%@)", [self ignore:option]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:format, like];
	return [self filteredArrayUsingPredicate:predicate];
}

#pragma mark - Private Functions

-(NSString*)ignore:(FilteringOption)option{
	NSString* ignore = @"";
	switch( option ){
		case FilteringOption_Case:
			ignore = @"[c]";
			break;
		case FilteringOption_Diacritic:
			ignore = @"[d]";
			break;
		case FilteringOption_Case | FilteringOption_Diacritic:
			ignore = @"[cd]";
			break;
		default:
			break;
	}
	return ignore;
}

@end