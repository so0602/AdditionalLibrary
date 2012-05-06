#import "NSNumber+Addition.h"

@implementation NSNumber (Addition)

static int ROMAN_NUMERAL_MAX = 4999;
static int ROMAN_NUMERAL_M = 1000;
static int ROMAN_NUMERAL_CM = 900;
static int ROMAN_NUMERAL_D = 500;
static int ROMAN_NUMERAL_CD = 400;
static int ROMAN_NUMERAL_C = 100;
static int ROMAN_NUMERAL_XC = 90;
static int ROMAN_NUMERAL_L = 50;
static int ROMAN_NUMERAL_XL = 40;
static int ROMAN_NUMERAL_X = 10;
static int ROMAN_NUMERAL_IX = 9;
static int ROMAN_NUMERAL_V = 5;
static int ROMAN_NUMERAL_IV = 4;
static int ROMAN_NUMERAL_I = 1;

//M(1000), D(500), C(100), L(50), X(10), V(5), I(1)
-(NSString*)roman{
	NSInteger num = [self intValue];
	
	if( num > ROMAN_NUMERAL_MAX ){
		NSLog(@"Not Support At Current. 1 - 4999");
		return nil;
	}
	
	NSMutableString* roman = [NSMutableString string];
	
	while( num >= ROMAN_NUMERAL_M ){
		[roman appendString:@"M"];
		num -= ROMAN_NUMERAL_M;
	}
	
	while( num >= ROMAN_NUMERAL_CM ){
		[roman appendString:@"CM"];
		num -= ROMAN_NUMERAL_CM;
	}
	
	while( num >= ROMAN_NUMERAL_D ){
		[roman appendString:@"D"];
		num -= ROMAN_NUMERAL_D;
	}
	
	while( num >= ROMAN_NUMERAL_CD ){
		[roman appendString:@"CD"];
		num -= ROMAN_NUMERAL_CD;
	}
	
	while( num >= ROMAN_NUMERAL_C ){
		[roman appendString:@"C"];
		num -= ROMAN_NUMERAL_C;
	}
	
	while( num >= ROMAN_NUMERAL_XC ){
		[roman appendString:@"XC"];
		num -= ROMAN_NUMERAL_XC;
	}
	
	while( num >= ROMAN_NUMERAL_L ){
		[roman appendString:@"L"];
		num -= ROMAN_NUMERAL_L;
	}
	
	while( num >= ROMAN_NUMERAL_XL ){
		[roman appendString:@"XL"];
		num -= ROMAN_NUMERAL_XL;
	}
	
	while( num >= ROMAN_NUMERAL_X ){
		[roman appendString:@"X"];
		num -= ROMAN_NUMERAL_X;
	}
	
	while( num >= ROMAN_NUMERAL_IX ){
		[roman appendString:@"IX"];
		num -= ROMAN_NUMERAL_IX;
	}
	
	while( num >= ROMAN_NUMERAL_V ){
		[roman appendString:@"V"];
		num -= ROMAN_NUMERAL_V;
	}
	
	while( num >= ROMAN_NUMERAL_IV ){
		[roman appendString:@"IV"];
		num -= ROMAN_NUMERAL_IV;
	}
	
	while( num >= ROMAN_NUMERAL_I ){
		[roman appendString:@"I"];
		num -= ROMAN_NUMERAL_I;
	}
	
	return roman;
}

@end