//
//  GTGZScroller.h
//  GTGZLibrary
//
//  Created by fanty on 13-4-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTGZTouchScrollerDelegate <NSObject>
@optional
- (void)tableView:(UIScrollView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UIScrollView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UIScrollView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UIScrollView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;

@end

@interface  GTGZScrollView : UIScrollView
@property (nonatomic,assign) id<GTGZTouchScrollerDelegate> touchDelegate;
@end

@interface GTGZTableView : UITableView
@property (nonatomic,assign) id<GTGZTouchScrollerDelegate> touchDelegate;
@end
