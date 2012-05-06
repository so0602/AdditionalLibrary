#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"

#import "YTInputAlertView.h"

@protocol YTDomainObjectDataSource;
@class YTSelectDomainActionSheet;

@protocol YTSelectDomainActionSheetDelegate

-(void)selectDomainActionSheet:(YTSelectDomainActionSheet*)actionSheet domainDidSelected:(id<YTDomainObjectDataSource>)obj;

@optional
-(BOOL)selectDomainActionSheet:(YTSelectDomainActionSheet*)actionSheet textFieldShouldEndEditing:(NSString*)text;
-(NSString*)errorMessage:(YTSelectDomainActionSheet*)actionSheet;

@end

@interface YTSelectDomainActionSheet : UIActionSheet<UIActionSheetDelegate, YTInputAlertViewDelegate>{
@private
	id<YTSelectDomainActionSheetDelegate> _domainDelegate;
	NSMutableArray<YTDomainObjectDataSource>* items;
	BOOL _hasOther;
}

-(id)initWithTitle:(NSString*)title delegate:(id<YTSelectDomainActionSheetDelegate>)domainDelegate hasOther:(BOOL)hasOther;

-(NSInteger)addDomainObject:(id<YTDomainObjectDataSource>)obj;
-(void)addDomainObjects:(NSArray<YTDomainObjectDataSource>*)objs;

@end

@protocol YTDomainObjectDataSource

-(NSString*)title:(id)target;
-(NSURL*)url:(id)target;

@optional
-(NSString*)tag:(id)target;

@end

@interface YTDomainObjectDataSource : NSObject<NSCopying, YTDomainObjectDataSource>{
@private
	NSString* _title;
	NSString* _tag;
	NSURL* _url;
}

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* tag;
@property (nonatomic, copy) NSURL* url;

-(id)initWithTitle:(NSString*)title;
-(id)initWithTitle:(NSString*)title url:(NSURL*)url;
-(id)initWithDataSource:(id<YTDomainObjectDataSource>)dataSource;

+(id)domainObjectWithTitle:(NSString*)title;
+(id)domainObjectWithTitle:(NSString*)title url:(NSURL*)url;
+(id)domainObjectWithDataSource:(id<YTDomainObjectDataSource>)dataSource;

@end