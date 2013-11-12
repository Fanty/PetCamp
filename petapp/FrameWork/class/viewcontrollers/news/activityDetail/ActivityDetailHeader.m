//
//  ActivityDetailHeader.m
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ActivityDetailHeader.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"

#import "Utils.h"

#define HEADER_IMAGE_SIZE  55.0f
#define IPAD_HEADER_IMAGE_SIZE 90.0f

#define OFFSET   15.0f
#define IPAD_OFFSET 30.0f

@interface ActivityDetailHeader()
-(void)joinClick:(UIButton*)button;
@end

@implementation ActivityDetailHeader
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        if([Utils isIPad])
            headerImage=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(IPAD_OFFSET, IPAD_OFFSET, IPAD_HEADER_IMAGE_SIZE, IPAD_HEADER_IMAGE_SIZE)];
        else
            headerImage=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(OFFSET, OFFSET, HEADER_IMAGE_SIZE, HEADER_IMAGE_SIZE)];
        
        
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerImage.frame)+10.0f, CGRectGetMaxY(headerImage.frame)+15.0f, 150.0f, 0.0f)];
        nameLabel.numberOfLines=1;
        [nameLabel theme:@"petnewsdetail_title"];
        
        commentImage=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"comment.png"]];
        
        commentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.numberOfLines=1;
        [commentLabel theme:@"petcell_smalltip"];
        
        
        favImage=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"add.png"]];
        
        favLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        favLabel.numberOfLines=1;
        [favLabel theme:@"petcell_smalltip"];
        
        
        
        dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerImage.frame)+10.0f, 0.0f, 150.0f, 0.0f)];
        dateLabel.numberOfLines=1;
        [dateLabel theme:@"petcell_smalltip"];
        
        UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"actButton.png"];
        joinButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [joinButton addTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
        [joinButton setBackgroundImage:img forState:UIControlStateNormal];
        [joinButton setTitle:lang(@"i_join") forState:UIControlStateNormal];
        joinButton.frame=CGRectMake(0.0f, 0.0f, img.size.width, img.size.height);
        [joinButton theme:@"activaty_join"];
        
        if([Utils isIPad])
            titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(IPAD_OFFSET, CGRectGetMaxY(headerImage.frame)+15.0f, frame.size.width-joinButton.frame.size.width-IPAD_OFFSET*6.0f, 0.0f)];
        else
            titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(OFFSET, CGRectGetMaxY(headerImage.frame)+15.0f, frame.size.width-joinButton.frame.size.width-OFFSET*6.0f, 0.0f)];
        titleLabel.numberOfLines=1;
        [titleLabel theme:@"petnewsdetail_title"];

        if([Utils isIPad])
            contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(IPAD_OFFSET, CGRectGetMaxY(headerImage.frame)+15.0f, frame.size.width-IPAD_OFFSET*2.0f, 0.0f)];
        else
            contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(OFFSET, CGRectGetMaxY(headerImage.frame)+15.0f, frame.size.width-OFFSET*2.0f, 0.0f)];
        contentLabel.numberOfLines=0;
        [contentLabel theme:@"petnewsdetail_content"];

        
        lineView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"]];
        

        
        
        
        [self addSubview:headerImage];
        [self addSubview:nameLabel];
        [self addSubview:dateLabel];
        [self addSubview:commentImage];
        [self addSubview:commentLabel];
        [self addSubview:favImage];
        [self addSubview:favLabel];
        [self addSubview:lineView];
        [self addSubview:titleLabel];
        [self addSubview:joinButton];
        [self addSubview:contentLabel];
        
        [headerImage release];
        [nameLabel release];
        [dateLabel release];
        [commentImage release];
        [commentLabel release];
        [favImage release];
        [favLabel release];
        [lineView release];
        [titleLabel release];
        [contentLabel release];
        
    }
    return self;
}

-(void)nickname:(NSString*)nickname headerImageUrl:(NSString*)headerImageUrl title:(NSString*)title content:(NSString*)content date:(NSDate*)date comment:(int)comment join:(int)join{
    nameLabel.text=nickname;
    [headerImage setUrl:headerImageUrl];
    titleLabel.text=title;
    contentLabel.text=content;
    
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    dateLabel.text=[NSString stringWithFormat:lang(@"pet_date"),[formatter stringFromDate:date]];
    [formatter release];
    
    commentLabel.text=[NSString stringWithFormat:@"%d",comment];
    favLabel.text=[NSString stringWithFormat:@"%d",join];

    [dateLabel sizeToFit];
    [nameLabel sizeToFit];
    [titleLabel sizeToFit];
    [contentLabel sizeToFit];
    [dateLabel sizeToFit];
    
    if([Utils isIPad]){
        float h=nameLabel.frame.size.height+15.0f+dateLabel.frame.size.height;
        
        CGRect rect=nameLabel.frame;
        rect.origin.y=CGRectGetMinY(headerImage.frame)+(headerImage.frame.size.height-h)*0.5f;
        nameLabel.frame=rect;
        
        rect=dateLabel.frame;
        rect.origin.y=CGRectGetMaxY(nameLabel.frame)+10.0f;
        dateLabel.frame=rect;
        
        
        commentLabel.frame=CGRectMake(0.0f, 0.0f, 150.0f, 0.0f);
        favLabel.frame=CGRectMake(0.0f, 0.0f, 150.0f, 0.0f);
        
        [commentLabel sizeToFit];
        [favLabel sizeToFit];
        
        
        float y=CGRectGetMinY(nameLabel.frame);
        
        rect=favLabel.frame;
        rect.origin.x=(self.frame.size.width-rect.size.width)-20.0f;
        rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
        favLabel.frame=rect;
        
        
        rect=favImage.frame;
        rect.origin.x=CGRectGetMinX(favLabel.frame)-rect.size.width-10.0f;
        rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
        favImage.frame=rect;
        
        rect=commentLabel.frame;
        rect.origin.x=CGRectGetMinX(favImage.frame)-rect.size.width-10.0f;
        rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
        commentLabel.frame=rect;
        
        
        rect=commentImage.frame;
        rect.origin.x=CGRectGetMinX(commentLabel.frame)-rect.size.width-10.0f;
        rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
        commentImage.frame=rect;
        
        
        rect=lineView.frame;
        rect.size.width=self.frame.size.width;
        rect.origin.y=CGRectGetMaxY(headerImage.frame)+16.0f;
        lineView.frame=rect;
        
        rect=titleLabel.frame;
        rect.size.width=self.frame.size.width-joinButton.frame.size.width-OFFSET*2.0f;
        rect.origin.y=CGRectGetMaxY(lineView.frame)+12.0f;
        titleLabel.frame=rect;
        
        rect=joinButton.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-OFFSET;
        rect.origin.y=CGRectGetMinY(titleLabel.frame)-5.0f;
        joinButton.frame=rect;
        
        rect=contentLabel.frame;
        rect.origin.y=CGRectGetMaxY(titleLabel.frame)+10.0f;
        contentLabel.frame=rect;
    }
    else{
        float h=nameLabel.frame.size.height+10.0f+dateLabel.frame.size.height;
        
        CGRect rect=nameLabel.frame;
        rect.origin.y=CGRectGetMinY(headerImage.frame)+(headerImage.frame.size.height-h)*0.5f;
        nameLabel.frame=rect;
        
        rect=dateLabel.frame;
        rect.origin.y=CGRectGetMaxY(nameLabel.frame)+5.0f;
        dateLabel.frame=rect;
        
        
        commentLabel.frame=CGRectMake(0.0f, 0.0f, 100.0f, 0.0f);
        favLabel.frame=CGRectMake(0.0f, 0.0f, 100.0f, 0.0f);
        
        [commentLabel sizeToFit];
        [favLabel sizeToFit];
        
        
        float y=CGRectGetMinY(nameLabel.frame);
        
        rect=favLabel.frame;
        rect.origin.x=(self.frame.size.width-rect.size.width)-15.0f;
        rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
        favLabel.frame=rect;
        
        
        rect=favImage.frame;
        rect.origin.x=CGRectGetMinX(favLabel.frame)-rect.size.width-5.0f;
        rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
        favImage.frame=rect;
        
        rect=commentLabel.frame;
        rect.origin.x=CGRectGetMinX(favImage.frame)-rect.size.width-5.0f;
        rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
        commentLabel.frame=rect;
        
        
        rect=commentImage.frame;
        rect.origin.x=CGRectGetMinX(commentLabel.frame)-rect.size.width-5.0f;
        rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
        commentImage.frame=rect;
        
        
        rect=lineView.frame;
        rect.size.width=self.frame.size.width;
        rect.origin.y=CGRectGetMaxY(headerImage.frame)+8.0f;
        lineView.frame=rect;
        
        rect=titleLabel.frame;
        rect.size.width=self.frame.size.width-joinButton.frame.size.width-OFFSET*2.0f;
        rect.origin.y=CGRectGetMaxY(lineView.frame)+8.0f;
        titleLabel.frame=rect;
        
        rect=joinButton.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-OFFSET;
        rect.origin.y=CGRectGetMinY(titleLabel.frame)-2.0f;
        joinButton.frame=rect;
        
        rect=contentLabel.frame;
        rect.origin.y=CGRectGetMaxY(titleLabel.frame)+5.0f;
        contentLabel.frame=rect;
    }
    
    
    
    CGRect rect=self.frame;
    rect.size.height=CGRectGetMaxY(contentLabel.frame)+20.0f;
    self.frame=rect;
}

-(void)joinClick:(UIButton*)button{
    if([self.delegate respondsToSelector:@selector(joinClick:)])
        [self.delegate joinClick:self];
}

-(void)comment:(int)comment{
    commentLabel.text=[NSString stringWithFormat:@"%d",comment];
}

-(void)showJoinButton:(BOOL)show{
    joinButton.hidden=!show;
}

@end

