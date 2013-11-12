//
//  HeadTabView.h
//  PetNews
//
//  Created by fanty on 13-8-4.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadTabView;

@protocol HeadTabViewDelegte <NSObject>

-(void)tabDidSelected:(HeadTabView*)tabView index:(int)index;

@end

@interface HeadTabView : UIImageView{
    UIImageView* selectedImageView;
    NSMutableArray* labelList;
    NSMutableArray* lineList;
    
    UIImageView* vlineView1;
    UIImageView* vlineView2;
}
@property(nonatomic,assign) id<HeadTabViewDelegte> delegate;
@property(nonatomic,assign) BOOL hightlightWhenTouch;
-(void)setTabNameArray:(NSArray*)array;

-(void)showHighlight:(BOOL)value;

@end
