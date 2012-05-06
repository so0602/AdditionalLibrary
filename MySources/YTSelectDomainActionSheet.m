#import "YTSelectDomainActionSheet.h"

static NSString* OTHER_BUTTON_TITLE = @"Other";

@interface YTOtherDomainObjectDataSource : YTDomainObjectDataSource{
}

@end

@implementation YTOtherDomainObjectDataSource

-(NSString*)title:(id)target{
	return OTHER_BUTTON_TITLE;
}

@end

@interface YTSelectDomainActionSheet ()

-(void)addOtherButton;

@property (nonatomic, retain) id<YTSelectDomainActionSheetDelegate> domainDelegate;
@property (nonatomic, assign) BOOL hasOther;

@end

@implementation YTSelectDomainActionSheet

@synthesize domainDelegate = _domainDelegate;
@synthesize hasOther = _hasOther;

-(id)initWithTitle:(NSString *)title delegate:(id<YTSelectDomainActionSheetDelegate>)domainDelegate hasOther:(BOOL)hasOther{
	if( self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] ){
		self.domainDelegate = domainDelegate;
		self.hasOther = hasOther;
	}
	return self;
}

-(NSInteger)addDomainObject:(id<YTDomainObjectDataSource>)obj{
	if( items ) [items addObject:obj];
	else items = [[NSMutableArray alloc] initWithObjects:obj, nil];
	return [self addButtonWithTitle:[obj title:self]];
}

-(void)addDomainObjects:(NSArray<YTDomainObjectDataSource>*)objs{
	if( items ) [items addObjectsFromArray:objs];
	else items = [[NSMutableArray alloc] initWithArray:objs];
	
	for( id<YTDomainObjectDataSource> obj in objs ) [self addButtonWithTitle:[obj title:self]];
}

#pragma mark Override Functions

-(void)showFromToolbar:(UIToolbar*)view{
	[self addOtherButton];
	[super showFromToolbar:view];
}

-(void)showFromTabBar:(UITabBar*)view{
	[self addOtherButton];
	[super showFromTabBar:view];
}

-(void)showFromBarButtonItem:(UIBarButtonItem*)item animated:(BOOL)animated{
	[self addOtherButton];
	[super showFromBarButtonItem:item animated:animated];
}

-(void)showFromRect:(CGRect)rect inView:(UIView*)view animated:(BOOL)animated{
	[self addOtherButton];
	[super showFromRect:rect inView:view animated:animated];
}

-(void)showInView:(UIView*)view{
	[self addOtherButton];
	[super showInView:view];
}

#pragma mark Private Functions

-(void)addOtherButton{
	if( self.hasOther ){
		[self addButtonWithTitle:OTHER_BUTTON_TITLE];
		self.cancelButtonIndex = items.count;
	}
}

#pragma mark YTInputAlertViewDelegate Callback

-(BOOL)inputAlertViewButtonWillClick:(YTInputAlertView*)alertView{
	BOOL shouldEndEditing = TRUE;
	if( RespondsToSelector(self.domainDelegate, @selector(selectDomainActionSheet:textFieldShouldEndEditing:)) ){
		shouldEndEditing = [self.domainDelegate selectDomainActionSheet:self textFieldShouldEndEditing:alertView.text];
	}
	
	if( shouldEndEditing ){
		YTOtherDomainObjectDataSource* obj = [YTOtherDomainObjectDataSource domainObjectWithTitle:OTHER_BUTTON_TITLE];
		obj.url = [NSURL URLWithString:alertView.text];
		[self.domainDelegate selectDomainActionSheet:self domainDidSelected:obj];
	}else{
		if( RespondsToSelector(self.domainDelegate, @selector(errorMessage:)) ){
			alertView.errorMessage = [self.domainDelegate errorMessage:self];
		}
	}
	return shouldEndEditing;
}

#pragma mark UIActionSheetDelegate Callback

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if( buttonIndex == items.count ){
		YTInputAlertView* alertView = [[YTInputAlertView alloc] initWithTitle:@"Domain Name" delegate:self];
		[alertView show];
		[alertView release];
		return;
	}
	
	YTDomainObjectDataSource* obj = [items objectAtIndex:buttonIndex];
	[self.domainDelegate selectDomainActionSheet:self domainDidSelected:obj];
}

#pragma mark Memory Management

-(void)dealloc{
	self.domainDelegate = nil;
	[items release], items = nil;
	self.hasOther = FALSE;
	
	[super dealloc];
}

@end

@implementation YTDomainObjectDataSource

@synthesize title = _title;
@synthesize tag = _tag;
@synthesize url = _url;

-(id)initWithTitle:(NSString*)title{
	return [self initWithTitle:title url:nil];
}

-(id)initWithTitle:(NSString*)title url:(NSURL*)url{
	if( self = [super init] ){
		self.title = title;
		self.url = url;
	}
	return self;
}

-(id)initWithDataSource:(id<YTDomainObjectDataSource>)dataSource{
	return [self initWithTitle:[dataSource title:self] url:[dataSource url:self]];
}

+(id)domainObjectWithTitle:(NSString*)title{
	return [self domainObjectWithTitle:title url:nil];
}

+(id)domainObjectWithTitle:(NSString*)title url:(NSURL*)url{
	return [[[self alloc] initWithTitle:title url:url] autorelease];
}

+(id)domainObjectWithDataSource:(id<YTDomainObjectDataSource>)dataSource{
	return [self domainObjectWithTitle:[dataSource title:self] url:[dataSource url:self]];
}

#pragma mark Override Functions

-(id)copyWithZone:(NSZone*)zone{
	YTDomainObjectDataSource* obj = [[YTDomainObjectDataSource allocWithZone:zone] initWithTitle:self.title url:self.url];
	obj.tag = self.tag;
	return obj;
}

#pragma mark YTDomainObjectDataSource Protocol

-(NSString*)title:(id)target{
	return self.title;
}

-(NSString*)tag:(id)target{
	return self.tag;
}

-(NSURL*)url:(id)target{
	return self.url;
}

#pragma mark Memory Management

-(void)dealloc{
	self.title = nil;
	self.tag = nil;
	self.url = nil;
	
	[super dealloc];
}

@end