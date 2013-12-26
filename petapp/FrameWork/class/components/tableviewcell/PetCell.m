//
//  PetCell.m
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetCell.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZShadowView.h"
#import "Utils.h"
#import "LikeView.h"
#import "GTGZUtils.h"

#define CELL_HEIGHT  190.0f

#define IPAD_CELL_HEIGHT  320.0f

@interface PetCell()
-(void)btnClick;
@end

@implementation PetCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleGray;
        
        bgView=[[UIView alloc] init];
        bgView.backgroundColor=[GTGZUtils colorConvertFromString:@"#F0F0F0"];
        [self addSubview:bgView];
        [bgView release];
        
        if([Utils isIPad]){
            shadowView=[[GTGZShadowView alloc] initWithFrame:CGRectMake(40.0f, 20.0f, 110.0f, 110.0f)];

        }
        else{
            shadowView=[[GTGZShadowView alloc] initWithFrame:CGRectMake(5.0f, 10.0f, 70.0f, 70.0f)];
        }
        shadowView.shadowOpacity=0.9f;
        [self addSubview:shadowView];
        [shadowView release];
        
        if([Utils isIPad]){
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(50.0f, 30.0f, 90.0f, 90.0f)];

        }
        else{
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(15.0f, 20.0f, 50.0f, 50.0f)];
        }
        [self addSubview:headImageView];
        [headImageView release];
        
        headerButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [headerButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        headerButton.frame=headImageView.frame;
        [self addSubview:headerButton];
        
        nickNameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        nickNameLabel.numberOfLines=0;
        [nickNameLabel theme:@"new_petcell_title"];
        [self addSubview:nickNameLabel];
        [nickNameLabel release];
        
        dateLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        dateLabel.numberOfLines=0;
        dateLabel.textAlignment=NSTextAlignmentRight;
        [dateLabel theme:@"new_petcell_date"];
        [self addSubview:dateLabel];
        [dateLabel release];
        
        chatView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"pet_chat.png"]];
        [self addSubview:chatView];
        [chatView release];
        
        contentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.numberOfLines=0;
        [contentLabel theme:@"new_petcell_desc"];
        [chatView addSubview:contentLabel];
        [contentLabel release];

        
        likeView=[[LikeView alloc] init];
        [self addSubview:likeView];
        [likeView release];
        
        

        imageViews=[[NSMutableArray alloc] initWithCapacity:3];
        
    }
    return self;
}

- (void)dealloc{
    [imageViews release];
    [super dealloc];
}

-(void)headUrl:(NSString*)headUrl{
    [headImageView setUrl:headUrl];
}

-(void)content:(NSString *)content{
    contentLabel.text=content;
    updateNeed=YES;
}

-(void)createDate:(NSDate*)date{
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    dateLabel.text=[NSString stringWithFormat:lang(@"pet_date"),[formatter stringFromDate:date]];
    [formatter release];

}

-(void)images:(NSArray*)array{
    for(UIImageView* imgView in imageViews){
        [imgView removeFromSuperview];
    }
    [imageViews removeAllObjects];
    int count=0;
    float height=([Utils isIPad]?120.0f:60.0f);
    float width=([Utils isIPad]?155.0f:height);
    for(NSString* url in array){
        ImageDownloadedView* imgView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        imgView.thumbnailSize=CGSizeMake(width, height);
        [imgView setUrl:url];
        [imageViews addObject:imgView];
        [chatView addSubview:imgView];
        [imgView release];
        count++;
        if(count>=3)break;
    }
    updateNeed=YES;
}

-(void)nickName:(NSString*)nickName{
    nickNameLabel.text=nickName;
    updateNeed=YES;
}

-(void)like:(int)like comment:(int)comment{
    [likeView like:like comment:comment];
}

+(float)height{
    return ([Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT);
}

-(void)btnClick{
    if([self.delegate respondsToSelector:@selector(petCellDidClickUserHeader:)])
        [self.delegate petCellDidClickUserHeader:self];
}

-(void)hideHeaderEvent{
    headerButton.hidden=YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!updateNeed)return;
    updateNeed=NO;    
    
    if([Utils isIPad]){
        CGRect rect=bgView.frame;
        rect.origin.x=30.0f;
        rect.size.width=self.frame.size.width-60.0f;
        rect.size.height=IPAD_CELL_HEIGHT-10.0f;
        bgView.frame=rect;
        
        
        
        nickNameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+30.0f, 15, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-110.0f, 20);
        
        dateLabel.frame=nickNameLabel.frame;
        
        rect=chatView.frame;
        rect.origin.x=CGRectGetMaxX(headImageView.frame)+20.0f;
        rect.origin.y=CGRectGetMaxY(nickNameLabel.frame)+15.0f;
        chatView.frame=rect;
        
        float left=25.0f;
        
        contentLabel.frame=CGRectMake(left, 15.0f, chatView.frame.size.width-25.0f, 0);
        [contentLabel sizeToFit];
        rect=contentLabel.frame;
        if(rect.size.height>58.0f){
            rect.size.height=58.0f;
            contentLabel.frame=rect;
        }
        
        for(UIView* imgView in imageViews){
            rect=imgView.frame;
            rect.origin.x=left;
            rect.origin.y=75.0f;
            imgView.frame=rect;
            left+=rect.size.width+20.0f;
        }
        
        rect=likeView.frame;
        rect.origin.x=CGRectGetMaxX(dateLabel.frame)-rect.size.width;
        rect.origin.y=CGRectGetMaxY(chatView.frame)+15.0f;
        likeView.frame=rect;
    }
    else{
        CGRect rect=bgView.frame;
        rect.origin.x=10.0f;
        rect.size.width=self.frame.size.width-20.0f;
        rect.size.height=CELL_HEIGHT-10.0f;
        bgView.frame=rect;
        
        
        
        nickNameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, 15, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-40.0f, 20);
        
        dateLabel.frame=nickNameLabel.frame;
        
        rect=chatView.frame;
        rect.origin.x=CGRectGetMaxX(headImageView.frame)+10.0f;
        rect.origin.y=CGRectGetMaxY(nickNameLabel.frame)+5.0f;
        chatView.frame=rect;
        
        float left=15.0f;
        
        contentLabel.frame=CGRectMake(left, 5.0f, chatView.frame.size.width-25.0f, 0);
        [contentLabel sizeToFit];
        rect=contentLabel.frame;
        if(rect.size.height>36.0f){
            rect.size.height=36.0f;
            contentLabel.frame=rect;
        }
        
        for(UIView* imgView in imageViews){
            rect=imgView.frame;
            rect.origin.x=left;
            rect.origin.y=45.0f;
            imgView.frame=rect;
            left+=rect.size.width+8.0f;
        }
        
        rect=likeView.frame;
        rect.origin.x=CGRectGetMaxX(dateLabel.frame)-rect.size.width;
        rect.origin.y=CGRectGetMaxY(chatView.frame)+5.0f;
        likeView.frame=rect;
    }
    
    
}

-(void)hideLike{
    likeView.hidden=YES;
}

@end
