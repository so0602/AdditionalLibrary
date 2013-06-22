#import "NSMutableArray+Addition.h"

@interface NSMutableArray ()

-(NSString*)ignore:(FilteringOption)option;

@end

@implementation NSMutableArray (Addition)

-(void)addNilObject:(id)obj{
    if( obj ){
        [self addObject:obj];
    }
}

-(void)addNilObjectsFromArray:(NSArray *)otherArray{
    if( otherArray ){
        [self addObjectsFromArray:otherArray];
    }
}

#pragma mark - Filtering

-(void)filterWithMatch:(NSString*)match{
	[self filterWithMatch:match inclusive:TRUE];
}

-(void)filterWithMatch:(NSString*)match inclusive:(BOOL)inclusive{
	NSPredicate* predicate = nil;
	if( inclusive ) predicate = [NSPredicate predicateWithFormat:@"SELF == %@", match];
	else predicate = [NSPredicate predicateWithFormat:@"SELF != %@", match];
	
	[self filterUsingPredicate:predicate];
}

-(void)filterWithIn:(NSArray*)objects{
	[self filterWithIn:objects inclusive:TRUE];
}

-(void)filterWithIn:(NSArray*)objects inclusive:(BOOL)inclusive{
	NSPredicate* predicate = nil;
	if( inclusive ) predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", objects];
	else predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", objects];
	
	[self filterUsingPredicate:predicate];
}

-(void)filterWithContains:(NSString*)contains{
	[self filterWithContains:contains filteringOption:FilteringOption_None inclusive:TRUE];
}

-(void)filterWithContains:(NSString*)contains inclusive:(BOOL)inclusive{
	[self filterWithContains:contains filteringOption:FilteringOption_None inclusive:inclusive];
}

-(void)filterWithContains:(NSString*)contains filteringOption:(FilteringOption)option{
	[self filterWithContains:contains filteringOption:option inclusive:TRUE];
}

-(void)filterWithContains:(NSString*)contains filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive{
	NSString* format = nil;
	if( inclusive ) format = [NSString stringWithFormat:@"SELF CONTAINS%@ %%@", [self ignore:option]];
	else format = [NSString stringWithFormat:@"NOT (SELF CONTAINS%@ %%@)", [self ignore:option]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:format, contains];
	[self filterUsingPredicate:predicate];
}

-(void)filterWithLike:(NSString*)like{
	[self filterWithLike:like filteringOption:FilteringOption_None inclusive:TRUE];
}

-(void)filterWithLike:(NSString*)like inclusive:(BOOL)inclusive{
	[self filterWithLike:like filteringOption:FilteringOption_None inclusive:inclusive];
}

-(void)filterWithLike:(NSString*)like filteringOption:(FilteringOption)option{
	[self filterWithLike:like filteringOption:option inclusive:TRUE];
}

-(void)filterWithLike:(NSString*)like filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive{
	NSString* format = nil;
	if( inclusive ) format = [NSString stringWithFormat:@"SELF LIKE%@ %%@", [self ignore:option]];
	else format = [NSString stringWithFormat:@"NOT (SELF LIKE%@ %%@)", [self ignore:option]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:format, like];
	[self filterUsingPredicate:predicate];
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