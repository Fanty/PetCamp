//
//  ImageShowFullScreenView.h
//  PetNews
//
//  Created by fanty on 13-8-13.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iCarousel;
@interface ImageShowFullScreenView : UIView{
    UIView* bgView;
    iCarousel* carousel;
    UIPageControl* pageControl;
    NSArray* list;
}


-(void)showImage:(int)pageIndex;
-(void)showInWindow;

-(void)setArray:(NSArray*)array;

@end
