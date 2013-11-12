//
//  ImageShowFullScreenView.m
//  PetNews
//
//  Created by fanty on 13-8-13.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ImageShowFullScreenView.h"
#import "iCarousel.h"
#import "ImageDownloadedView.h"
@interface ImageShowFullScreenView()<iCarouselDataSource,iCarouselDelegate>

@end

@implementation ImageShowFullScreenView

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        bgView=[[UIView alloc] init];
        bgView.backgroundColor=[UIColor blackColor];
        [self addSubview:bgView];
        [bgView release];
        carousel=[[iCarousel alloc] init];
        carousel.delegate=self;
        carousel.bounces=NO;
        carousel.dataSource=self;
        carousel.clipsToBounds=YES;
        
        [self addSubview:carousel];
        [carousel release];
        
        pageControl=[[UIPageControl alloc] initWithFrame:CGRectZero];
        [pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
        
        
        [self addSubview:pageControl];
        [pageControl release];
        
        
        self.frame=[[UIApplication sharedApplication] keyWindow].bounds;
        bgView.frame=self.bounds;
        carousel.frame=self.bounds;
        pageControl.frame=CGRectMake(0, self.bounds.size.height-36, self.bounds.size.width, 36);
        list=[[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

-(void)dealloc{
    [list release];
    [super dealloc];
}

-(void)setArray:(NSArray*)array{

    [list release];
    list=[array retain];
    [carousel reloadData];
    pageControl.numberOfPages=[array count];
    pageControl.currentPage=0;    
}

-(void)showInWindow{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.hidden=YES;
}

-(void)showImage:(int)pageIndex{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    pageControl.currentPage=pageIndex;
    [carousel scrollToItemAtIndex:pageIndex animated:NO];

    self.hidden=NO;
    self.alpha=1.0f;
    bgView.alpha=0.0f;
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        bgView.alpha=0.89f;
    } completion:^(BOOL finish){
        
    }];
    carousel.transform=CGAffineTransformMakeScale(0.6f, 0.6f);
    
    [UIView animateWithDuration:0.45f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        carousel.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finish){
        
    }];
    
}

-(void)touchesEnded{
    [UIView animateWithDuration:0.36f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha=0.0f;
    } completion:^(BOOL finish){
        self.hidden=YES;
        [self removeFromSuperview];
        
    }];
    
}


-(void)pageChange{
    [carousel scrollToItemAtIndex:pageControl.currentPage animated:YES];
}

#pragma mark carousel  delegate  datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [list count];
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel{
    return NO;
}

- (void)carouselDidScroll:(iCarousel *)_carousel{
    pageControl.currentPage=carousel.currentItemIndex;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    if(view==nil){
        view=[[[ImageDownloadedView alloc] initWithFrame:self.bounds] autorelease];
        view.contentMode=UIViewContentModeScaleAspectFit;
    }
    
    NSString* imageUrl=[list objectAtIndex:index];
    
    ImageDownloadedView* imgView=(ImageDownloadedView*)view;
    imgView.thumbnailSize=CGSizeMake(480.0f, 320.0f);
    [imgView setUrl:imageUrl];
	return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if(option==iCarouselOptionVisibleItems)
        return 3;
    return value;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    [UIView animateWithDuration:0.36f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha=0.0f;
    } completion:^(BOOL finish){
        self.hidden=YES;
        [self removeFromSuperview];
        
    }];
    

}


@end

