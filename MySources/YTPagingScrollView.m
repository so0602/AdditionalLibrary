#import "YTPagingScrollView.h"

@interface YTPagingScrollView ()

@property (nonatomic, retain, readwrite) NSMutableArray* viewControllers;

@property (nonatomic, assign, readwrite) NSInteger currentPage;
@property (nonatomic, assign, readwrite) NSInteger totalPages;
@property (nonatomic, assign, readwrite) BOOL pageControlUsed;

-(void)loadScrollViewWithPage:(NSInteger)page;
-(void)changePage:(NSInteger)page animated:(BOOL)animated;

@end

@implementation YTPagingScrollView

-(id)initWithFrame:(CGRect)frame{
	if( self = [super initWithFrame:frame] ){
		[self addSubview:self.scrollView];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if( self = [super initWithCoder:aDecoder] ){
		[self addSubview:self.scrollView];
	}
	return self;
}

-(UIScrollView*)scrollView{
	if( !_scrollView ){
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.showsVerticalScrollIndicator = _scrollView.showsHorizontalScrollIndicator = _scrollView.scrollsToTop = FALSE;
		_scrollView.pagingEnabled = TRUE;
		_scrollView.delegate = self;
	}
	return _scrollView;
}

-(UIViewController*)currentViewController{
	return [self.viewControllers objectAtIndex:self.currentPage];
}

-(void)reloadData{
	self.scrollView.contentOffset = CGPointZero;
	self.scrollView.contentSize = CGSizeZero;
	
	for( UIViewController* viewController in self.viewControllers ){
		if( [viewController isKindOfClass:[UIViewController class]] ) [viewController.view removeFromSuperview];
	}
	self.viewControllers = nil;
	
	self.totalPages = [self.dataSouce numberOfPagesInPagingScrollView:self];
	
	if( self.totalPages > 0 ){
		self.viewControllers = [NSMutableArray arrayWithCapacity:self.totalPages];
		for( int i = 0; i < self.totalPages; i++ ) [(NSMutableArray*)self.viewControllers addObject:[NSNull null]];
		
		self.currentPage = [self.dataSouce currentPage:self];
		
		[self loadScrollViewWithPage:self.currentPage - 1];
		[self loadScrollViewWithPage:self.currentPage];
		[self loadScrollViewWithPage:self.currentPage + 1];
		
		self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.totalPages, self.scrollView.height);
		self.scrollView.contentOffset = CGPointMake(self.scrollView.width * self.currentPage, 0);
		if( RespondsToSelector(self.delegate, @selector(scrollViewDidEndScrollingAnimation:)) ){
			[self.delegate scrollViewDidEndScrollingAnimation:self];
		}
	}
}

-(void)previous:(BOOL)animated{
	[self changePage:self.currentPage - 1 animated:animated];
}

-(void)next:(BOOL)animated{
	[self changePage:self.currentPage + 1 animated:animated];
}

#pragma mark Override Functions

-(IBAction)didReceiveMemoryWarning{
	NSInteger currentPage = self.currentPage;
	for( int i = 0; i < self.viewControllers.count; i++ ){
		UIViewController* viewController = [self.viewControllers objectAtIndex:i];
		if( [viewController isKindOfClass:[NSNull class]] ) continue;
		if( i < currentPage - 1 || i > currentPage + 1 ){
			[viewController.view removeFromSuperview];
			[(NSMutableArray*)self.viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];
		}
	}
}

#pragma mark Private Functions

-(void)loadScrollViewWithPage:(NSInteger)page{
	if( page < 0 || page >= self.totalPages ) return;
	
	UIViewController* viewController = [self.viewControllers objectAtIndex:page];
	if( [viewController isKindOfClass:[NSNull class]] ){
		viewController = [self.dataSouce pagingScrollView:self viewControllerAtPage:page];
		[(NSMutableArray*)self.viewControllers replaceObjectAtIndex:page withObject:viewController];
	}
	
	if( !viewController.view.superview ){
		viewController.view.frame = self.bounds;
		viewController.view.x = viewController.view.width * page;
		[self.scrollView addSubview:viewController.view];
	}
}

-(void)changePage:(NSInteger)page animated:(BOOL)animated{
	[self loadScrollViewWithPage:page - 1];
	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page + 1];
	
	CGRect frame = self.scrollView.bounds;
	frame.origin.x = frame.size.width * page;
	[self.scrollView scrollRectToVisible:frame animated:animated];
	if( !animated ){
		self.currentPage = floor((self.scrollView.contentOffset.x - self.scrollView.width / 2) / self.scrollView.width) + 1;
		if( RespondsToSelector(self.delegate, @selector(scrollViewDidEndScrollingAnimation:)) ){
			[self.delegate scrollViewDidEndScrollingAnimation:self];
		}
	}
}

#pragma mark UIScrollViewDelegate Callback

-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
	if( self.pageControlUsed ) return;
	
	self.currentPage = floor((scrollView.contentOffset.x - scrollView.width / 2) / scrollView.width) + 1;
	
	[self loadScrollViewWithPage:self.currentPage - 1];
	[self loadScrollViewWithPage:self.currentPage];
	[self loadScrollViewWithPage:self.currentPage + 1];
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
	self.pageControlUsed = FALSE;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
	self.pageControlUsed = FALSE;
	
	self.currentPage = floor((self.scrollView.contentOffset.x - self.scrollView.width / 2) / self.scrollView.width) + 1;
	if( RespondsToSelector(self.delegate, @selector(scrollViewDidEndScrollingAnimation:)) ){
		[self.delegate scrollViewDidEndScrollingAnimation:self];
	}
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	self.currentPage = floor((self.scrollView.contentOffset.x - self.scrollView.width / 2) / self.scrollView.width) + 1;
	if( RespondsToSelector(self.delegate, @selector(scrollViewDidEndScrollingAnimation:)) ){
		[self.delegate scrollViewDidEndScrollingAnimation:self];
	}
}

#pragma mark Memory Management

-(void)dealloc{
	self.delegate = nil;
	self.dataSouce = nil;
	
	self.scrollView = nil;
	self.viewControllers = nil;
	
	self.currentPage = 0;
	self.totalPages = 0;
	self.pageControlUsed = FALSE;
	
	[super dealloc];
}

#pragma mark @synthesize

@synthesize delegate = _delegate;
@synthesize dataSouce = _dataSouce;
@synthesize scrollView = _scrollView;
@synthesize currentPage = _currentPage;
@synthesize totalPages = _totalPages;
@synthesize pageControlUsed = _pageControlUsed;
@synthesize viewControllers = _viewControllers;

@end