//
//  ProfileTab.m
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ProfileTab.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@implementation ProfileTab
@synthesize delegate;
- (id)init{
    self=[self initWithImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"profile_tab.png"]];
    if(self){
        float x=([Utils isIPad]?25.0f:10.0f);
        float y=([Utils isIPad]?20.0f:10.0f);

        float sizeWith=([Utils isIPad]?115.0f:50.0f);
        float sizeHeight=([Utils isIPad]?30.0f:15.0f);
        self.userInteractionEnabled=YES;
        petNumberView=[[UILabel  alloc] initWithFrame:CGRectMake(x,y, sizeWith, sizeHeight)];
        
        x=([Utils isIPad]?173.0f:73.0f);
        friendNumberView=[[UILabel  alloc] initWithFrame:CGRectMake(x, y, sizeWith, sizeHeight)];

        x=([Utils isIPad]?328.0f:136.0f);
        fansNumberView=[[UILabel  alloc] initWithFrame:CGRectMake(x, y, sizeWith, sizeHeight)];

        x=([Utils isIPad]?480.0f:200.0f);
        addNumberView=[[UILabel  alloc] initWithFrame:CGRectMake(x, y, sizeWith, sizeHeight)];

        x=([Utils isIPad]?637.0f:263.0f);
        messageNumberView=[[UILabel  alloc] initWithFrame:CGRectMake(x, y, sizeWith, sizeHeight)];
        
        [petNumberView theme:@"profile_tab_number"];
        [friendNumberView theme:@"profile_tab_number"];
        [fansNumberView theme:@"profile_tab_number"];
        [addNumberView theme:@"profile_tab_number"];
        [messageNumberView theme:@"profile_tab_number"];
        
        petNumberView.numberOfLines=1;
        friendNumberView.numberOfLines=1;
        fansNumberView.numberOfLines=1;
        addNumberView.numberOfLines=1;
        messageNumberView.numberOfLines=1;
        
        petNumberView.textAlignment=NSTextAlignmentCenter;
        friendNumberView.textAlignment=NSTextAlignmentCenter;
        fansNumberView.textAlignment=NSTextAlignmentCenter;
        addNumberView.textAlignment=NSTextAlignmentCenter;
        messageNumberView.textAlignment=NSTextAlignmentCenter;
        
        [self addSubview:petNumberView];
        [self addSubview:friendNumberView];
        [self addSubview:fansNumberView];
        [self addSubview:addNumberView];
        [self addSubview:messageNumberView];
        
        [petNumberView release];
        [friendNumberView release];
        [fansNumberView release];
        [addNumberView release];
        [messageNumberView release];

    }
    
    return self;
}

-(void)petNumber:(int)petNumber friendNumber:(int)friendNumber fansNumber:(int)fansNumber addNumber:(int)addnumber messageNumber:(int)messageNumber{
    petNumberView.text=[NSString stringWithFormat:@"%d",petNumber];
    friendNumberView.text=[NSString stringWithFormat:@"%d",friendNumber];
    fansNumberView.text=[NSString stringWithFormat:@"%d",fansNumber];
    addNumberView.text=[NSString stringWithFormat:@"%d",addnumber];
    messageNumberView.text=[NSString stringWithFormat:@"%d",messageNumber];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];

    if([self.delegate respondsToSelector:@selector(profileTab:click:)]){
        int clickIndex=0;
        if(point.x<=CGRectGetMaxX(petNumberView.frame))
            clickIndex=0;
        else if(point.x<=CGRectGetMaxX(friendNumberView.frame))
            clickIndex=1;
        else if(point.x<=CGRectGetMaxX(fansNumberView.frame))
            clickIndex=2;
        else if(point.x<=CGRectGetMaxX(addNumberView.frame))
            clickIndex=3;
        else if(point.x<=CGRectGetMaxX(messageNumberView.frame))
            clickIndex=4;

        [self.delegate profileTab:self click:clickIndex];
    }
}

@end
