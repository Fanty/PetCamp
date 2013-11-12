//
//  likeView.m
//  PetNews
//
//  Created by Fanty on 13-11-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "LikeView.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@implementation LikeView

- (id)init{
    self = [super init];
    if (self) {
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
        
        
        if([Utils isIPad]){
            likeLabel.frame=CGRectMake(0.0f, 0.0f, 50.0f, 0.0f);
            commentLabel.frame=CGRectMake(0.0f, 0.0f, 50.0f, 0.0f);
        }
        else{
            likeLabel.frame=CGRectMake(0.0f, 0.0f, 28.0f, 0.0f);
            commentLabel.frame=CGRectMake(0.0f, 0.0f, 28.0f, 0.0f);
        }

        CGRect rect=likeImageView.frame;
        
        float height=rect.size.height* 1.5f;
        
        rect.origin.y=(height-rect.size.height)*0.5f;
        likeImageView.frame=rect;
        
        rect=likeLabel.frame;
        rect.origin.y=0;
        rect.origin.x=CGRectGetMaxX(likeImageView.frame)+3.0f;
        rect.size.height=height;
        likeLabel.frame=rect;
        
        rect=commentImageView.frame;
        rect.origin.y=(height-rect.size.height)*0.5f;
        rect.origin.x=CGRectGetMaxX(likeLabel.frame)+3.0f;
        commentImageView.frame=rect;

        rect=commentLabel.frame;
        rect.origin.y=0;
        rect.origin.x=CGRectGetMaxX(commentImageView.frame)+3.0f;
        rect.size.height=height;
        commentLabel.frame=rect;
        
        self.frame=CGRectMake(0.0f, 0.0f, CGRectGetMaxX(commentLabel.frame), height);

    }
    return self;
}

-(void)like:(int)like comment:(int)comment{
    if(like>999)like=999;
    if(comment>999)comment=999;
    likeLabel.text=[NSString stringWithFormat:@"%d",like];
    commentLabel.text=[NSString stringWithFormat:@"%d",comment];
}



@end
