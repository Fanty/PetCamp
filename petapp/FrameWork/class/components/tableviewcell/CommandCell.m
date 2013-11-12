//
//  CommandCell.m
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "CommandCell.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZUtils.h"
#import "Utils.h"
#define OFFSET   25.0f
#define CELL_HEIGHT  100.0f

#define IPAD_OFFSET  50.0f
#define IPAD_CELL_HEIGHT 160.0f

@implementation CommandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        bgView=[[UIView alloc] init];
       // if([Utils isIPad])
            bgView.backgroundColor=[GTGZUtils colorConvertFromString:@"#BCBCBC"];
      //  else
      //      bgView.backgroundColor=[GTGZUtils colorConvertFromString:@"#282828"];
        [self addSubview:bgView];
        [bgView release];
        
        if([Utils isIPad])
            headerImage=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(IPAD_OFFSET, 16.0f, 60.0f, 60.0f)];
        else
            headerImage=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(OFFSET, 10.0f, 40.0f, 40.0f)];
        
        [self addSubview:headerImage];
        [headerImage release];
        
        nameLabel=[[UILabel alloc] init];
        nameLabel.numberOfLines=1;
        [self addSubview:nameLabel];
        [nameLabel release];
        
        
        
        dateLabel=[[UILabel alloc] init];
        dateLabel.numberOfLines=1;
        [self addSubview:dateLabel];
        [dateLabel release];
                
        
        contentLabel=[[UILabel alloc] init];
        contentLabel.numberOfLines=0;
        [self addSubview:contentLabel];
        [contentLabel release];
        
        
        [nameLabel theme:@"command_name"];
        [contentLabel theme:@"command_content"];
        [dateLabel theme:@"command_date"];
        
        lineView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"]];
        
        [self addSubview:lineView];
        [lineView release];
    }
    return self;
}

-(void)nickname:(NSString*)nickname headerImageUrl:(NSString*)headerImageUrl content:(NSString*)content date:(NSDate*)date{
    nameLabel.text=nickname;
    [headerImage setUrl:headerImageUrl];
    contentLabel.text=[GTGZUtils trim:content];

    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    dateLabel.text=[formatter stringFromDate:date];
    [formatter release];

    isLayoutUpdate=YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!isLayoutUpdate)return;
    isLayoutUpdate=NO;
    
    ;
    if([Utils isIPad]){
        CGRect rect=bgView.frame;
        rect.origin.x=30.0f;
        rect.size.width=self.frame.size.width-60.0f;
        rect.size.height=self.frame.size.height;
        bgView.frame=rect;
        
        float left=CGRectGetMaxX(headerImage.frame)+30.0f;
        
        rect=nameLabel.frame;
        rect.size.height=20.0f;
        rect.origin.x=left;
        rect.origin.y=15.0f;
        rect.size.width=self.frame.size.width-rect.origin.x-IPAD_OFFSET-70.0f;
        nameLabel.frame=rect;
        
        
        
        contentLabel.frame=CGRectMake(left, CGRectGetMaxY(rect)+10.0f, self.frame.size.width-left-IPAD_OFFSET, 0.0f);
        [contentLabel sizeToFit];
        
        rect=contentLabel.frame;
        if(rect.size.height>60.0f){
            rect.size.height=60.0f;
            contentLabel.frame=rect;
        }
        
        rect.size.width=200.0f;
        rect.size.height=23.0f;
        rect.origin.x=CGRectGetMinX(contentLabel.frame);
        rect.origin.y=CGRectGetMaxY(contentLabel.frame)+5.0f;
        if(rect.origin.y>IPAD_CELL_HEIGHT-rect.size.height){
            rect.origin.y=IPAD_CELL_HEIGHT-rect.size.height;
        }
        dateLabel.frame=rect;
        
        
        rect=lineView.frame;
        rect.origin.x=30.0f;
        rect.origin.y=self.frame.size.height-rect.size.height;
        rect.size.width=self.frame.size.width-60.0f;
        lineView.frame=rect;
    }
    else{
        CGRect rect=bgView.frame;
        rect.origin.x=10.0f;
        rect.size.width=self.frame.size.width-20.0f;
        rect.size.height=self.frame.size.height;
        bgView.frame=rect;
        
        float left=CGRectGetMaxX(headerImage.frame)+10.0f;
        
        rect=nameLabel.frame;
        rect.size.height=12.0f;
        rect.origin.x=left;
        rect.origin.y=10.0f;
        rect.size.width=self.frame.size.width-rect.origin.x-OFFSET-50.0f;
        nameLabel.frame=rect;
        
        
        
        contentLabel.frame=CGRectMake(left, CGRectGetMaxY(rect)+5.0f, self.frame.size.width-left-OFFSET, 0.0f);
        [contentLabel sizeToFit];
        
        rect=contentLabel.frame;
        if(rect.size.height>45.0f){
            rect.size.height=45.0f;
            contentLabel.frame=rect;
        }
        
        rect.size.width=200.0f;
        rect.size.height=15.0f;
        rect.origin.x=CGRectGetMinX(contentLabel.frame);
        rect.origin.y=CGRectGetMaxY(contentLabel.frame)+5.0f;
        if(rect.origin.y>CELL_HEIGHT-rect.size.height){
            rect.origin.y=CELL_HEIGHT-rect.size.height;
        }
        dateLabel.frame=rect;
        
        
        rect=lineView.frame;
        rect.origin.x=10.0f;
        rect.origin.y=self.frame.size.height-rect.size.height;
        rect.size.width=self.frame.size.width-20.0f;
        lineView.frame=rect;
    }

}

+(float)cellHeight{
    return [Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT;
}

@end
