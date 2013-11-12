//
//  PullToRefresh.h
//  iPhone_SCMP
//
//  Created by GT mac_5 on 12-10-10.
//  Copyright (c) 2012年 GTGZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullToRefresh : UIView

@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, strong) NSDate *lastUpdatedDate;

- (void)triggerRefresh:(BOOL)handling;
- (void)stopAnimating;
@end


// extends UIScrollView

@interface UIScrollView (PullToRefresh)

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
-(void)releasePullToRefresh;
@property (nonatomic, strong) PullToRefresh *pullToRefreshView;

@end
