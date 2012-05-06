#import "YTScrollWebView.h"

@implementation YTScrollWebView

-(id)initWithFrame:(CGRect)frame{
	if( self = [super initWithFrame:frame] ){
		self.scalesPageToFit = TRUE;
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if( self = [super initWithCoder:aDecoder] ){
		self.scalesPageToFit = TRUE;
	}
	return self;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
	[self.scrollViewDelegate webViewDidScroll:self];
}

#pragma mark - Memory Management

-(void)dealloc{
	[_scrollViewDelegate release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize scrollViewDelegate = _scrollViewDelegate;

@end