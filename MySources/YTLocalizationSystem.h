#import <Foundation/Foundation.h>

typedef enum{
	YTLanguageTypeEnglish,
	YTLanguageTypeTraditionalChinese,
	YTLanguageTypeSimplifiedChinese,
}YTLanguageType;

extern NSString* const UD_YTLocalizationSystemLanguage;

@interface YTLocalizationSystem : NSObject{
	@protected
	NSBundle* _bundle;
	NSArray* _supportingLanguages;
}

+(YTLocalizationSystem*)sharedLocalSystem;

-(NSString*)localizedStringForKey:(NSString*)key value:(NSString*)comment;

@property (nonatomic, copy) NSString* usingLanguage;
@property (nonatomic, readonly) NSString* systemLanguage;
@property (nonatomic, copy, readonly) NSArray* supportingLanguages;

@property (nonatomic, readonly) YTLanguageType usingLanguageType;

@end

YTLocalizationSystem* YTLocalizedSystem(void);
NSString* YTLocalizedString(NSString* key, NSString* comment);
NSLocale* YTLocalizedUsingLocale(void);