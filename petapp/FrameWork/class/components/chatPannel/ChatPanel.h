//
//  ChatPanel.h
//  WeChat
//
//  Created by apple2310 on 13-9-5.
//  Copyright (c) 2013年 apple2310. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatPanel;

@protocol ChatPanelDelegate <NSObject>
-(void)chatPanelDidSend:(ChatPanel*)chatPanel;
-(void)chatPanelDidSelectedAdd:(ChatPanel*)chatPanel;
-(void)chatPanelKeyworkShow:(int)height;

@end

@interface ChatPanel : UIImageView{
    UIButton* addButton;

    UIImageView*  textBgView;
    UITextView* textView;
    
    float currentHeight;
    
    float textViewHeight;
}

@property(nonatomic,assign) id<ChatPanelDelegate> delegate;
@property(nonatomic,assign) NSUInteger limitMaxNumber;
@property(nonatomic,retain) NSString* text;
@property(nonatomic,assign) float superViewHeight;

@end
