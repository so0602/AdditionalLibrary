#import "YTLocalizationSystem.h"

NSString* const UD_YTLocalizationSystemLanguage = @"UD_YTLocalizationSystemLanguage";

static YTLocalizationSystem* sharedInstance = nil;
static NSString* defaultLanguage = @"en";

@interface YTLocalizationSystem()

@property (nonatomic, retain) NSBundle* bundle;
@property (nonatomic, copy, readwrite) NSArray* supportingLanguages;

@end

@implementation YTLocalizationSystem

+(YTLocalizationSystem*)sharedLocalSystem{
	@synchronized([YTLocalizationSystem class] ){
		if( !sharedInstance ){
			sharedInstance = [[self alloc] init];
		}
		return sharedInstance;
	}
	return nil;
}

+(id)alloc{
	@synchronized([YTLocalizationSystem class] ){
		NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedInstance = [super alloc];
		return sharedInstance;
	}
	return nil;
}

-(id)init{
	if( self = [super init] ){
		self.usingLanguage = self.usingLanguage;
	}
	return self;
}

-(NSString*)localizedStringForKey:(NSString *)key value:(NSString *)comment{
	return [self.bundle localizedStringForKey:key value:comment table:nil];
}

-(void)setUsingLanguage:(NSString*)usingLanguage{
	NSString* path = [[NSBundle mainBundle] pathForResource:usingLanguage ofType:@"lproj"];
	if( path == nil ){
		usingLanguage = self.systemLanguage;
		path = [[NSBundle mainBundle] pathForResource:usingLanguage ofType:@"lproj"];
		if( path == nil ){
			usingLanguage = defaultLanguage;
			path = [[NSBundle mainBundle] pathForResource:usingLanguage ofType:@"lproj"];
		}
	}
	
	self.bundle = [NSBundle bundleWithPath:path];
	[[NSUserDefaults standardUserDefaults] setObject:usingLanguage forKey:UD_YTLocalizationSystemLanguage];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)usingLanguage{
	NSString* language = [[NSUserDefaults standardUserDefaults] objectForKey:UD_YTLocalizationSystemLanguage];
	if( !language ){
		language = self.systemLanguage;
		NSString* path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
		if( path == nil ){
			language = defaultLanguage;
		}
		[[NSUserDefaults standardUserDefaults] setObject:language forKey:UD_YTLocalizationSystemLanguage];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	return language;
}

-(NSString*)systemLanguage{
	NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
	NSString* preferredLangauge = [languages objectAtIndex:0];
	return preferredLangauge;
}

-(YTLanguageType)usingLanguageType{
	YTLanguageType type = YTLanguageTypeEnglish;
	NSString* language = self.usingLanguage;
	if( [language isEqualToString:@"zh-Hant"] ){
		type = YTLanguageTypeTraditionalChinese;
	}else if( [language isEqualToString:@"zh-Hans"] ){
		type = YTLanguageTypeSimplifiedChinese;
	}
	return type;
}

-(NSArray*)supportingLanguages{
	if( !_supportingLanguages ){
		
	}
	return _supportingLanguages;
}

#pragma mark - Memory Management

-(void)dealloc{
	[_bundle release];
	[_supportingLanguages release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize bundle = _bundle;
@synthesize supportingLanguages = _supportingLanguages;

@end

YTLocalizationSystem* YTLocalizedSystem(void){
	return [YTLocalizationSystem sharedLocalSystem];
}

NSString* YTLocalizedString(NSString* key, NSString* comment){
	return [YTLocalizedSystem() localizedStringForKey:key value:comment];
}

NSLocale* YTLocalizedUsingLocale(void){
	return [[[NSLocale alloc] initWithLocaleIdentifier:YTLocalizedSystem().usingLanguage] autorelease];
}

NSString* YTLocalizedUsingPath(void){
	return [[NSBundle mainBundle] pathForResource:YTLocalizedSystem().usingLanguage ofType:@"lproj"];
}