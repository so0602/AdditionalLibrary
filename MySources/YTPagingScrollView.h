#import <UIKit/UIKit.h>

#import "UIView+Addition.h"

#import "YTGlobalValues.h"

@class YTPagingScrollView;

@protocol YTPagingScrollViewDataSource

-(NSInteger)numberOfPagesInPagingScrollView:(YTPagingScrollView*)scrollView;
-(UIViewController*)pagingScrollView:(YTPagingScrollView*)scrollView viewControllerAtPage:(NSInteger)page;
-(NSUInteger)currentPage:(YTPagingScrollView*)scrollView;

@end

@protocol YTPagingScrollViewDelegate

@optional
-(void)scrollViewDidEndScrollingAnimation:(YTPagingScrollView*)scrollView;

@end

@interface YTPagingScrollView : UIView<UIScrollViewDelegate>{
@private
	id<YTPagingScrollViewDelegate> _delegate;
	id<YTPagingScrollViewDataSource> _dataSource;
	
	UIScrollView* _scrollView;
	
	NSMutableArray* _viewControllers;
	NSInteger _totalPages;
	NSInteger _currentPage;
	
	BOOL _pageControlUsed;
}

@property (nonatomic, retain) IBOutlet id<YTPagingScrollViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet id<YTPagingScrollViewDataSource> dataSource;

@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain, readonly) NSArray* viewControllers;

@property (nonatomic, assign, readonly) NSInteger currentPage;

@property (nonatomic, readonly) UIViewController* currentViewController;

-(void)reloadData;

-(void)previous:(BOOL)animated;
-(void)next:(BOOL)animated;

@end