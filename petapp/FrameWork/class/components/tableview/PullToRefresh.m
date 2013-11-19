//
//  PullToRefresh.m
//  iPhone_SCMP
//
//  Created by GT mac_5 on 12-10-10.
//  Copyright (c) 2012年 GTGZ. All rights reserved.
//

#import "PullToRefresh.h"



#import <QuartzCore/QuartzCore.h>
#import "PullToRefresh.h"
#import "Constants.h"
#import "GTGZThemeManager.h"
#import "GTGZUtils.h"

enum {
    PullToRefreshStateHidden = 1,
	PullToRefreshStateVisible,
    PullToRefreshStateTriggered,
    PullToRefreshStateLoading
};

typedef NSUInteger PullToRefreshState;


@interface PullToRefresh ()

- (id)initWithScrollView:(UIScrollView*)scrollView;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)scrollViewDidScroll:(CGPoint)contentOffset;

@property (nonatomic, copy) void (^actionHandler)(void);
@property (nonatomic, readwrite) PullToRefreshState state;

@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, readwrite) UIEdgeInsets originalScrollViewContentInset;

@end



@implementation PullToRefresh

// public properties
@synthesize actionHandler, activityIndicatorViewStyle, lastUpdatedDate;

@synthesize state;
@synthesize scrollView = _scrollView;
@synthesize arrow, activityIndicatorView, titleLabel, dateLabel, dateFormatter, originalScrollViewContentInset;

- (void)dealloc {
    if(actionHandler!=nil){
        [actionHandler release];
        actionHandler=nil;
    }
    [arrow release];
    [activityIndicatorView release];
    [titleLabel release];
    [dateLabel release];
    [dateFormatter release];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollView=nil;
    [super dealloc];
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectZero];
    self.scrollView = scrollView;
    [_scrollView addSubview:self];
    
    // default styling values
   // self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad)?30.0f:20.0f)] autorelease];
    titleLabel.text = lang(@"pull");
    [titleLabel theme:@"pulltoRefresh_title"];
    [self addSubview:titleLabel];
    
    [self addSubview:self.arrow];
    
    
    
    UIImageView* shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad?85.0f:55.0f), (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad?768.0f:320.0f), 5)];
    shadowView.image = [[GTGZThemeManager sharedInstance] imageByTheme:@"shadow_bottom.png"];
    [self addSubview:shadowView];
    [shadowView release];
    
    
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    self.originalScrollViewContentInset = scrollView.contentInset;
	
    self.state = PullToRefreshStateHidden;
    self.frame = CGRectMake(0, -(UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad?100.0f:60.0f), scrollView.bounds.size.width, (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad?100.0f:60.0f));
    
    return self;
}

- (void)layoutSubviews {
    CGFloat remainingWidth = self.superview.bounds.size.width;
    float position = 0.50;
    
    CGRect titleFrame = titleLabel.frame;
    
    CGRect dateFrame = dateLabel.frame;
    dateFrame.origin.x = (remainingWidth - dateLabel.frame.size.width)*position;
    dateLabel.frame = dateFrame;
    
    titleFrame.origin.x = dateFrame.origin.x;
    titleLabel.frame = titleFrame;

    
    CGRect arrowFrame = arrow.frame;
    arrowFrame.origin.x = dateLabel.frame.origin.x - arrow.frame.size.width - 10;
    arrow.frame = arrowFrame;
    
    self.activityIndicatorView.center = self.arrow.center;
}

#pragma mark - Getters

- (UIImageView *)arrow {
    if(!arrow) {
        arrow = [[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"arrow_refresh.png"]];
        arrow.frame = CGRectMake(0, 15, 18, 26);
        arrow.backgroundColor = [UIColor clearColor];
    }
    return arrow;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!activityIndicatorView) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:activityIndicatorView];
        activityIndicatorView.color=[UIColor blackColor];
    }
    return activityIndicatorView;
}

- (UILabel *)dateLabel {
    if(!dateLabel) {
        if(UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad)
            dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 58.0f, 250.0f, 30.0f)];
        else
            dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 250, 20)];
        
        [dateLabel theme:@"pulltoRefresh_date"];
        [self addSubview:dateLabel];
        CGRect titleFrame = titleLabel.frame;
        if(UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad)
            titleFrame.origin.y=18.0f;
        else
            titleFrame.origin.y = 12;
        titleLabel.frame = titleFrame;
    }
    return dateLabel;
}

- (NSDateFormatter *)dateFormatter {
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];

        NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:locale];
        [locale release];
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return dateFormatter;
}

#pragma mark - Setters

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        if(self.state == PullToRefreshStateHidden && contentInset.top == self.originalScrollViewContentInset.top)
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                arrow.alpha = 0;
            } completion:NULL];
    }];
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate {
    self.dateLabel.text = [NSString stringWithFormat:lang(@"lastupdated"), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:lang(@"never")];
    [self.dateLabel sizeToFit];
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"] && self.state != PullToRefreshStateLoading)
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalScrollViewContentInset.top;
    
    if(!self.scrollView.isDragging && self.state == PullToRefreshStateTriggered)
        self.state = PullToRefreshStateLoading;
    else if(contentOffset.y > scrollOffsetThreshold && contentOffset.y < -self.originalScrollViewContentInset.top && self.scrollView.isDragging && self.state != PullToRefreshStateLoading)
        self.state = PullToRefreshStateVisible;
    else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == PullToRefreshStateVisible)
        self.state = PullToRefreshStateTriggered;
    else if(contentOffset.y >= -self.originalScrollViewContentInset.top && self.state != PullToRefreshStateHidden)
        self.state = PullToRefreshStateHidden;
}

- (void)triggerRefresh:(BOOL)handling {
//    CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalScrollViewContentInset.top;

    state=PullToRefreshStateLoading;
    titleLabel.text = lang(@"loading");
    [self rotateArrow:0 hide:YES];
    [self.activityIndicatorView startAnimating];
    [self setScrollViewContentInset:UIEdgeInsetsMake(self.frame.origin.y*-1+self.originalScrollViewContentInset.top, 0, 0, 0)];
    [titleLabel sizeToFit];

    CGPoint point=self.scrollView.contentOffset;
    point.y=0.0f;
    [self.scrollView setContentOffset:point animated:NO];

    point.y=(self.frame.origin.y-self.originalScrollViewContentInset.top);

    [self.scrollView setContentOffset:point animated:NO];
    
    if(handling && actionHandler)
        actionHandler();

}

- (void)stopAnimating {
    self.state = PullToRefreshStateHidden;
}

- (void)setState:(PullToRefreshState)newState {
    state = newState;
    
    switch (newState) {
        case PullToRefreshStateHidden:
            titleLabel.text = lang(@"pull");
            [self.activityIndicatorView stopAnimating];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            [self rotateArrow:0 hide:NO];
            break;
            
        case PullToRefreshStateVisible:
            titleLabel.text = lang(@"pull");
            arrow.alpha = 1;
            [self.activityIndicatorView stopAnimating];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            [self rotateArrow:0 hide:NO];
            break;
            
        case PullToRefreshStateTriggered:
            titleLabel.text = lang(@"releaseRefresh");
            [self rotateArrow:M_PI hide:NO];
            break;
            
        case PullToRefreshStateLoading:
            titleLabel.text = lang(@"loading");
            [self.activityIndicatorView startAnimating];
            [self setScrollViewContentInset:UIEdgeInsetsMake(self.frame.origin.y*-1+self.originalScrollViewContentInset.top, 0, 0, 0)];
            [self rotateArrow:0 hide:YES];
            if(actionHandler)
                actionHandler();
            break;
    }
    [titleLabel sizeToFit];

}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
    } completion:NULL];
}

@end


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (PullToRefresh)

@dynamic pullToRefreshView;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    PullToRefresh *pullToRefreshView = [[PullToRefresh alloc] initWithScrollView:self];
    pullToRefreshView.actionHandler = actionHandler;
    pullToRefreshView.backgroundColor =[UIColor clearColor];// [SCMPUtils colorConvertFromString:@"#F3EDA3"];
    self.pullToRefreshView = pullToRefreshView;
    [pullToRefreshView release];
}

- (void)setPullToRefreshView:(PullToRefresh *)pullToRefreshView {
    
    
    [self willChangeValueForKey:@"pullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"pullToRefreshView"];
}

- (PullToRefresh *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

-(void)releasePullToRefresh{
    if(self.pullToRefreshView.actionHandler!=nil){
        //[self.pullToRefreshView.actionHandler release];
        self.pullToRefreshView.actionHandler=nil;
    }
    self.pullToRefreshView=nil;
}

@end
