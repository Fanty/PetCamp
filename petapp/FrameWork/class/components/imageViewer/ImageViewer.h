//
//  ImageViewer.h
//  PetNews
//
//  Created by 肖昶 on 13-9-23.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTGZHorizalTableView;
@class ImageViewer;
@protocol ImageViewerDelegate <NSObject>

-(void)didImageViewerSelected:(ImageViewer*)imageViewer index:(int)index;

@end

@interface ImageViewer : UIView{
    GTGZHorizalTableView*  tableView;
    
    UIPageControl* pageControl;
    NSTimer* timer;
}
@property(nonatomic,assign) id<ImageViewerDelegate> delegate;
@property(nonatomic,retain) NSArray* list;
@end

