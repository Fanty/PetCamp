//
//  ChatCell.m
//  WeChat
//
//  Created by apple2310 on 13-9-5.
//  Copyright (c) 2013年 apple2310. All rights reserved.
//

#import "ChatCell.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "Utils.h"

static UIImage*  __bubbleSomeoneImg=nil;
static UIImage* __bubbleMineImg=nil;

@interface ChatCell()

@end

@implementation ChatCell

+(UIImage*)bubbleSomeoneImg{
    if(__bubbleSomeoneImg==nil){
        UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"bubbleSomeone.png"];
        __bubbleSomeoneImg=[[img stretchableImageWithLeftCapWidth:img.size.width*0.5f topCapHeight:img.size.height*0.5f] retain];
    }
    return __bubbleSomeoneImg;
}

+(UIImage*)bubbleMineImg{
    if(__bubbleMineImg==nil){
        UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"bubbleMine.png"];
        __bubbleMineImg=[[img stretchableImageWithLeftCapWidth:img.size.width*0.5f topCapHeight:img.size.height*0.5f] retain];

    }
    return __bubbleMineImg;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType=UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;

        float size=([Utils isIPad]?75.0f:35.0f);
        imageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size, size)];
        [self addSubview:imageView];
        [imageView release];
        
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.numberOfLines=1;
        [nameLabel theme:@"chatcell_name"];
        [self addSubview:nameLabel];
        [nameLabel release];
        
        bubbleView=[[UIImageView alloc] init];
        [self addSubview:bubbleView];
        [bubbleView release];
        
        contentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.numberOfLines=0;
        [contentLabel theme:@"chatcell_content"];
        [bubbleView addSubview:contentLabel];
        [contentLabel release];
        
    }
    return self;
}

-(void)dealloc{
    [super dealloc];

}


-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name content:(NSString*)content  bubbleType:(NSBubbleType)_bubbleType{
    
    [imageView setUrl:headerUrl];
    nameLabel.text=name;
    
    contentLabel.text=content;
    
    bubbleType=_bubbleType;

}


+(float)cellHeight:(NSString*)content{
    float height=0.0f;
    if(![Utils isIPad]){
        height=8+15.0f;
        UILabel* contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 0.0f)];
        contentLabel.numberOfLines=0;
        [contentLabel theme:@"chatcell_content"];
        contentLabel.text=content;
        [contentLabel sizeToFit];
        height+=5.0f+10.0f+contentLabel.frame.size.height+20.0f;
        [contentLabel release];
        height+=8.0f;
        
        if(height<10.0f+35.0f+10.0f)
            height=10.0f+35.0f+10.0f;

    }
    else{
        height=16.0f+30.0f;
        UILabel* contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 450.0f, 0.0f)];
        contentLabel.numberOfLines=0;
        [contentLabel theme:@"chatcell_content"];
        contentLabel.text=content;
        [contentLabel sizeToFit];
        height+=15.0f+25.0f+contentLabel.frame.size.height+25.0f;
        [contentLabel release];
        height+=16.0f;
        
        if(height<20.0f+75.0f+20.0f)
            height=20.0f+75.0f+20.0f;
    }
    return height;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(![Utils isIPad]){
        if(bubbleType==BubbleTypeSomeoneElse){
            CGRect rect=imageView.frame;
            rect.origin.x=20.0f;
            rect.origin.y=10.0f;
            imageView.frame=rect;
            
            nameLabel.textAlignment=NSTextAlignmentLeft;
            nameLabel.frame=CGRectMake(CGRectGetMaxX(imageView.frame)+15.0f, 8.0f, 200.0f, 15.0f);
            
            contentLabel.frame=CGRectMake(0.0f, 0.0f, 200.0f, 0.0f);
            [contentLabel sizeToFit];
            
            bubbleView.image=[ChatCell bubbleSomeoneImg];
            
            
            rect.size.width=20.0f+contentLabel.frame.size.width+15.0f;
            if(rect.size.width<150)
                rect.size.width=150.0f;

            rect.size.height=10.0f+contentLabel.frame.size.height+10.0f;
            rect.origin.x=CGRectGetMaxX(imageView.frame)+5.0f;
            rect.origin.y=CGRectGetMaxY(nameLabel.frame)+5.0f;

            
            bubbleView.frame=rect;
            
            rect=contentLabel.frame;
            rect.origin.x=20.0f;
            rect.origin.y=10.0f;
            contentLabel.frame=rect;
        }
        else{
            
            CGRect rect=imageView.frame;
            rect.origin.x=self.frame.size.width-rect.size.width-20.0f;
            rect.origin.y=10.0f;
            imageView.frame=rect;
            
            nameLabel.textAlignment=NSTextAlignmentRight;

            nameLabel.frame=CGRectMake(CGRectGetMinX(imageView.frame)-200.0f-15.0f, 8.0f, 200.0f, 15.0f);
            
            contentLabel.frame=CGRectMake(0.0f, 0.0f, 200.0f, 0.0f);
            [contentLabel sizeToFit];
            
            bubbleView.image=[ChatCell bubbleMineImg];
            
            rect.size.width=15.0f+contentLabel.frame.size.width+20.0f;
            if(rect.size.width<150)
                rect.size.width=150.0f;

            rect.size.height=10.0f+contentLabel.frame.size.height+20.0f;
            rect.origin.x=CGRectGetMinX(imageView.frame)-rect.size.width-5.0f;
            rect.origin.y=CGRectGetMaxY(nameLabel.frame)+5.0f;
            
            bubbleView.frame=rect;
            
            rect=contentLabel.frame;
            rect.origin.x=bubbleView.frame.size.width-rect.size.width-20.0f;
            rect.origin.y=10.0f;
            contentLabel.frame=rect;

        }
    }
    else{
        if(bubbleType==BubbleTypeSomeoneElse){
            CGRect rect=imageView.frame;
            rect.origin.x=40.0f;
            rect.origin.y=20.0f;
            imageView.frame=rect;
            
            nameLabel.textAlignment=NSTextAlignmentLeft;

            nameLabel.frame=CGRectMake(CGRectGetMaxX(imageView.frame)+30.0f, 16.0f, 450.0f, 30.0f);
            
            contentLabel.frame=CGRectMake(0.0f, 0.0f, 450.0f, 0.0f);
            [contentLabel sizeToFit];
            
            bubbleView.image=[ChatCell bubbleSomeoneImg];
            
            
            rect.size.width=40.0f+contentLabel.frame.size.width+25.0f;
            if(rect.size.width<350.0f)
                rect.size.width=350.0f;

            
            rect.size.height=25.0f+contentLabel.frame.size.height+25.0f;
            rect.origin.x=CGRectGetMaxX(imageView.frame)+20.0f;
            rect.origin.y=CGRectGetMaxY(nameLabel.frame)+15.0f;
            
            
            bubbleView.frame=rect;
            
            rect=contentLabel.frame;
            rect.origin.x=40.0f;
            rect.origin.y=25.0f;
            contentLabel.frame=rect;
        }
        else{
            
            CGRect rect=imageView.frame;
            rect.origin.x=self.frame.size.width-rect.size.width-40.0f;
            rect.origin.y=20.0f;
            imageView.frame=rect;
            
            nameLabel.textAlignment=NSTextAlignmentRight;

            nameLabel.frame=CGRectMake(CGRectGetMinX(imageView.frame)-450.0f-30.0f, 16.0f, 450.0f, 30.0f);
            
            contentLabel.frame=CGRectMake(0.0f, 0.0f, 450.0f, 0.0f);
            [contentLabel sizeToFit];
            
            bubbleView.image=[ChatCell bubbleMineImg];
            
            rect.size.width=25.0f+contentLabel.frame.size.width+40.0f;
            
            if(rect.size.width<350.0f)
                rect.size.width=350.0f;

            
            rect.size.height=25.0f+contentLabel.frame.size.height+25.0f;
            rect.origin.x=CGRectGetMinX(imageView.frame)-rect.size.width-20.0f;
            rect.origin.y=CGRectGetMaxY(nameLabel.frame)+15.0f;
            

            
            bubbleView.frame=rect;
            
            rect=contentLabel.frame;
            rect.origin.x=bubbleView.frame.size.width-rect.size.width-40.0f;
            rect.origin.y=15.0f;
            contentLabel.frame=rect;
            
        }
    }
}




@end
