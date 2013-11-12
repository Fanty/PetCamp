//
//  MessageCell.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MessageCell.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZShadowView.h"
#import "Utils.h"
#define CELL_HEIGHT  85.0f
#define IPAD_CELL_HEIGHT  100.0f

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
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
                
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.numberOfLines=1;
        [titleLabel theme:@"petcell_title"];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        descLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        descLabel.numberOfLines=0;
        [descLabel theme:@"petcell_desc"];
        [self addSubview:descLabel];
        [descLabel release];
        
        dateLabel=[[UILabel alloc] init];
        dateLabel.numberOfLines=1;
        [dateLabel theme:@"command_date"];
        [self addSubview:dateLabel];
        [dateLabel release];

        
        lineView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"]];
        [self addSubview:lineView];
        [lineView release];
        
    }
    return self;
}

-(void)headUrl:(NSString*)headUrl{
    [headImageView setUrl:headUrl];
}

-(void)title:(NSString*)title{
    titleLabel.text=title;
    updateNeed=YES;
}

-(void)content:(NSString*)desc{
    descLabel.text=desc;
    updateNeed=YES;
}

-(void)date:(NSDate*)date{
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    dateLabel.text=[formatter stringFromDate:date];
    [formatter release];

}

+(float)height{
    return ([Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT);
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if(!updateNeed)return;
    updateNeed=NO;
    if([Utils isIPad]){
        titleLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+25.0f, 10.0f, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-50.0f , 0.0f);
        
        dateLabel.frame=CGRectMake(0.0f, 15.0f, 200.0f, 0.0f);
        [dateLabel sizeToFit];
        
        CGRect rect=dateLabel.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-20.0f;
        dateLabel.frame=rect;
        
        [titleLabel sizeToFit];
        
        rect=titleLabel.frame;
        if(rect.size.width>CGRectGetMinX(dateLabel.frame)-CGRectGetMaxX(headImageView.frame)-25.0f){
            rect.size.width=CGRectGetMinX(dateLabel.frame)-CGRectGetMaxX(headImageView.frame)-25.0f;
            titleLabel.frame=rect;
        }
        
        descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+25.0f, CGRectGetMaxY(titleLabel.frame), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-50.0f, 0.0f);
        
        [descLabel sizeToFit];
        
        rect=descLabel.frame;
        if(rect.size.height>50.0f){
            rect.size.height=50.0f;
            descLabel.frame=rect;
        }
        
        rect=lineView.frame;
        rect.size.width=self.frame.size.width;
        rect.origin.y=IPAD_CELL_HEIGHT-rect.size.height;
        lineView.frame=rect;
    }
    else{
        titleLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, 10.0f, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f , 0.0f);
        
        dateLabel.frame=CGRectMake(0.0f, 10.0f, 200.0f, 0.0f);
        [dateLabel sizeToFit];
        
        CGRect rect=dateLabel.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-10.0f;
        dateLabel.frame=rect;
        
        [titleLabel sizeToFit];
        
        rect=titleLabel.frame;
        if(rect.size.width>CGRectGetMinX(dateLabel.frame)-CGRectGetMaxX(headImageView.frame)-15.0f){
            rect.size.width=CGRectGetMinX(dateLabel.frame)-CGRectGetMaxX(headImageView.frame)-15.0f;
            titleLabel.frame=rect;
        }
        
        descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, CGRectGetMaxY(titleLabel.frame), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f, 0.0f);
        
        [descLabel sizeToFit];
        
        rect=descLabel.frame;
        if(rect.size.height>33.0f){
            rect.size.height=33.0f;
            descLabel.frame=rect;
        }
        
        rect=lineView.frame;
        rect.size.width=self.frame.size.width;
        rect.origin.y=CELL_HEIGHT-rect.size.height;
        lineView.frame=rect;
    }
    
}

@end
