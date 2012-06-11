//
// SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>

@interface SVPullToRefresh : UIView

@property (nonatomic, retain) UIColor *arrowColor;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, retain) NSDate *lastUpdatedDate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (void)triggerRefresh;
- (void)stopAnimating;

@end


// extends UIScrollView

@interface UIScrollView (SVPullToRefresh)

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;

@property (nonatomic, retain) SVPullToRefresh *pullToRefreshView;

@end