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

#define CELL_HEIGHT  105.0f

#define IPAD_CELL_HEIGHT  120.0f

@interface PetCell()
-(void)btnClick;
@end

@implementation PetCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleGray;
        
        
        if([Utils isIPad]){
            shadowView=[[GTGZShadowView alloc] initWithFrame:CGRectMake(10.0f, (IPAD_CELL_HEIGHT-70.0f)*0.5f-10.0f, 90.0f, 90.0f)];

        }
        else{
            shadowView=[[GTGZShadowView alloc] initWithFrame:CGRectMake(5.0f, (CELL_HEIGHT-50.0f)*0.5f-10.0f, 70.0f, 70.0f)];
        }
        shadowView.shadowOpacity=0.9f;
        [self addSubview:shadowView];
        [shadowView release];
        
        if([Utils isIPad]){
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(20.0f, (IPAD_CELL_HEIGHT-70.0f)*0.5f, 70.0f, 70.0f)];

        }
        else{
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(15.0f, (CELL_HEIGHT-50.0f)*0.5f, 50.0f, 50.0f)];
        }
        [self addSubview:headImageView];
        [headImageView release];
        
        UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame=headImageView.frame;
        [self addSubview:button];
        
        nickNameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        nickNameLabel.numberOfLines=0;
        [nickNameLabel theme:@"petcell_desc"];
        [self addSubview:nickNameLabel];
        [nickNameLabel release];
        
        contentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.numberOfLines=0;
        [contentLabel theme:@"petcell_desc"];
        [self addSubview:contentLabel];
        [contentLabel release];
        
        likeImageView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"fav.png"]];
        [self addSubview:likeImageView];
        [likeImageView release];
                
        likeLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        likeLabel.numberOfLines=1;
        [likeLabel theme:@"petcell_smalltip"];
        [self addSubview:likeLabel];
        [likeLabel release];

        commentImageView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"comment.png"]];
        [self addSubview:commentImageView];
        [commentImageView release];
        
        commentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.numberOfLines=1;
        [commentLabel theme:@"petcell_smalltip"];
        [self addSubview:commentLabel];
        [commentLabel release];

        
        
        lineView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"]];
        [self addSubview:lineView];
        [lineView release];

    }
    return self;
}

-(void)headUrl:(NSString*)headUrl{
    [headImageView setUrl:headUrl];
}

-(void)content:(NSString *)content{
    contentLabel.text=content;
    updateNeed=YES;
}

-(void)nickName:(NSString*)nickName{
    nickNameLabel.text=nickName;
    updateNeed=YES;
}

-(void)like:(int)like comment:(int)comment{
    likeLabel.text=[NSString stringWithFormat:@"%d",like];
    commentLabel.text=[NSString stringWithFormat:@"%d",comment];
}

+(float)height{
    return ([Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT);
}

-(void)btnClick{
    if([self.delegate respondsToSelector:@selector(petCellDidClickUserHeader:)])
        [self.delegate petCellDidClickUserHeader:self];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!updateNeed)return;
    updateNeed=NO;    
        
    nickNameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, 20, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-25.0f, 20);
    
    contentLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, CGRectGetMaxY(nickNameLabel.frame)+5.0f, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-25.0f, 0.0f);
    
    [contentLabel sizeToFit];
    
    CGRect rect=contentLabel.frame;
    if(rect.size.height>36.0f){
        rect.size.height=36.0f;
        contentLabel.frame=rect;
    }
    if([Utils isIPad]){
        float y=CGRectGetMaxY(contentLabel.frame)+10.0f;
        
        likeLabel.frame=CGRectMake(0.0f, 0.0f, 50.0f, 0.0f);
        commentLabel.frame=CGRectMake(0.0f, 0.0f, 50.0f, 0.0f);
        
        rect=commentLabel.frame;
        rect.origin.y=y-5.0f;
        rect.size.height=commentImageView.frame.size.height+10.0f;
        rect.origin.x=self.frame.size.width-rect.size.width;
        commentLabel.frame=rect;
        
        rect=commentImageView.frame;
        rect.origin.y=y;
        rect.origin.x=CGRectGetMinX(commentLabel.frame)-rect.size.width-10.0f;
        commentImageView.frame=rect;
        
        rect=likeLabel.frame;
        rect.origin.y=y-5.0f;
        rect.size.height=likeImageView.frame.size.height+10.0f;
        rect.origin.x=CGRectGetMinX(commentImageView.frame)-rect.size.width;
        likeLabel.frame=rect;
        
        rect=likeImageView.frame;
        rect.origin.y=y;
        rect.origin.x=CGRectGetMinX(likeLabel.frame)-rect.size.width-10.0f;
        likeImageView.frame=rect;
    }
    else{
        float y=CGRectGetMaxY(contentLabel.frame)+10.0f;
        
        likeLabel.frame=CGRectMake(0.0f, 0.0f, 30.0f, 0.0f);
        commentLabel.frame=CGRectMake(0.0f, 0.0f, 30.0f, 0.0f);
        
        rect=commentLabel.frame;
        rect.origin.y=y-2.0f;
        rect.size.height=commentImageView.frame.size.height+5;
        rect.origin.x=self.frame.size.width-rect.size.width;
        commentLabel.frame=rect;
        
        rect=commentImageView.frame;
        rect.origin.y=y;
        rect.origin.x=CGRectGetMinX(commentLabel.frame)-rect.size.width-5.0f;
        commentImageView.frame=rect;
        
        rect=likeLabel.frame;
        rect.origin.y=y-2.0f;
        rect.size.height=likeImageView.frame.size.height+5;
        rect.origin.x=CGRectGetMinX(commentImageView.frame)-rect.size.width;
        likeLabel.frame=rect;
        
        rect=likeImageView.frame;
        rect.origin.y=y;
        rect.origin.x=CGRectGetMinX(likeLabel.frame)-rect.size.width-5.0f;
        likeImageView.frame=rect;
    }
    

    
    rect=lineView.frame;
    rect.size.width=self.frame.size.width;
    if([Utils isIPad])
        rect.origin.y=IPAD_CELL_HEIGHT-rect.size.height;
    else
        rect.origin.y=CELL_HEIGHT-rect.size.height;
    lineView.frame=rect;
}

@end
