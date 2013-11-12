//
//  WriterView.h
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollTextView;
@class WriterView;
@protocol WriterViewDelegate <NSObject>
-(void)didPostInWriterView:(WriterView*)writerView;
-(void)didCancelInWriterView:(WriterView*)writerView;
@end

@interface WriterView : UIView{
    UIView* bgView;
    UIImageView* pannelView;
    UIImageView*  textBgView;
    ScrollTextView* textView;
    UILabel* placeHoldView;
    UIButton* postButton;
}

@property(nonatomic,assign) int limitMaxNumber;
@property(nonatomic,assign) id<WriterViewDelegate> delegate;
-(NSString*)text;
-(void)text:(NSString*)value;
-(void)buttonText:(NSString*)value;
-(void)show;

-(void)close;

-(void)placeholder:(NSString*)value;

@end
