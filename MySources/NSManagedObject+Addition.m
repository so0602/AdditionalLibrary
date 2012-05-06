#import "NSManagedObject+Addition.h"

@implementation NSManagedObject (Addition)

-(void)setValuesForKeyWithDictionary:(NSDictionary*)dictionary{
	NSDictionary* attributes = self.entity.attributesByName;
	for( NSString* attribute in attributes ){
		id value = [dictionary objectForKey:attribute];
		if( !value ) continue;
		[self setValue:value forKey:attribute];
	}
}

-(void)safeSetValuesForKeyWithDictionary:(NSDictionary*)dictionary{
	NSDictionary* attributes = self.entity.attributesByName;
	for( NSString* attribute in attributes ){
		id value = [dictionary objectForKey:attribute];
		if( !value ) continue;
		
		NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
		if( attributeType == NSStringAttributeType && [value isKindOfClass:NSNumber.class] ){
			value = [value stringValue];
		}else if( (attributeType == NSInteger16AttributeType || attributeType == NSInteger32AttributeType || attributeType == NSInteger64AttributeType || attributeType == NSBooleanAttributeType) && [value isKindOfClass:NSString.class] ){
			value = [NSNumber numberWithInteger:[value integerValue]];
		}else if( attributeType == NSFloatAttributeType && [value isKindOfClass:NSString.class] ){
			value = [NSNumber numberWithDouble:[value doubleValue]];
		}
		[self setValue:value forKey:attribute];
	}
}

-(void)safeSetValuesForKeyWithDictionary:(NSDictionary*)dictionary dateFormatter:(NSDateFormatter*)dateFormatter{
	NSDictionary* attributes = self.entity.attributesByName;
	for( NSString* attribute in attributes ){
		id value = [dictionary objectForKey:attribute];
		if( !value ) continue;
		
		NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
		if( attributeType == NSStringAttributeType && [value isKindOfClass:NSNumber.class] ){
			value = [value stringValue];
		}else if( (attributeType == NSInteger16AttributeType || attributeType == NSInteger32AttributeType || attributeType == NSInteger64AttributeType || attributeType == NSBooleanAttributeType) && [value isKindOfClass:NSString.class] ){
			value = [NSNumber numberWithInteger:[value integerValue]];
		}else if( attributeType == NSFloatAttributeType && [value isKindOfClass:NSString.class] ){
			value = [NSNumber numberWithDouble:[value doubleValue]];
		}else if( attributeType == NSDateAttributeType && [value isKindOfClass:NSString.class] ){
			value = [dateFormatter dateFromString:value];
		}
		[self setValue:value forKey:attribute];
	}
}

@end