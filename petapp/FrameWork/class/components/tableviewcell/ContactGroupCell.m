//
//  GroupCell.m
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactGroupCell.h"

#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZShadowView.h"
#import "Utils.h"
#define CELL_HEIGHT  60.0f
#define IPAD_CELL_HEIGHT 90.0f

@implementation ContactGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleGray;
        
        if([Utils isIPad])
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(25.0f, (IPAD_CELL_HEIGHT-60.0f)*0.5f, 60.0f, 60.0f)];
        else
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(15.0f, (CELL_HEIGHT-40.0f)*0.5f, 40.0f, 40.0f)];
        [self addSubview:headImageView];
        [headImageView release];
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.numberOfLines=1;
        [nameLabel theme:@"petcell_title"];
        [self addSubview:nameLabel];
        [nameLabel release];
        
        descLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        descLabel.numberOfLines=1;
        [descLabel theme:@"petcell_desc"];
        [self addSubview:descLabel];
        [descLabel release];
        
        lineView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"]];
        [self addSubview:lineView];
        [lineView release];
        
    }
    return self;
}

-(void)headUrl:(NSString*)headUrl{
    [headImageView setUrl:headUrl];
}

-(void)name:(NSString *)name{
    nameLabel.text=name;
    updateNeed=YES;
}

-(void)desc:(NSString*)desc{
    descLabel.text=desc;
    updateNeed=YES;
}

+(float)height{
    return ([Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!updateNeed)return;
    updateNeed=NO;
    
    if([Utils isIPad]){
        float w=self.frame.size.width-CGRectGetMaxX(headImageView.frame)-50.0f;
        
        if([descLabel.text length]>0){
            nameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+25.0f, 15.0f, w , 0.0f);
            [nameLabel sizeToFit];
        }
        else{
            nameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+25.0f, 0.0f, w , self.frame.size.height);
        }
        
        
        descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+25.0f, CGRectGetMaxY(nameLabel.frame), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-50.0f, 0.0f);
        
        [descLabel sizeToFit];
        
        CGRect rect=descLabel.frame;
        if(rect.size.height>50.0f){
            rect.size.height=50.0f;
            descLabel.frame=rect;
        }
        
        rect=lineView.frame;
        rect.origin.y=IPAD_CELL_HEIGHT-rect.size.height;
        rect.size.width=self.frame.size.width;
        lineView.frame=rect;
    }
    else{
        float w=self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f;
        
        if([descLabel.text length]>0){
            nameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, 10.0f, w , 0.0f);
            [nameLabel sizeToFit];
        }
        else{
            nameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, 0.0f, w , self.frame.size.height);
        }
        
        
        descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, CGRectGetMaxY(nameLabel.frame), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f, 0.0f);
        
        [descLabel sizeToFit];
        
        CGRect rect=descLabel.frame;
        if(rect.size.height>33.0f){
            rect.size.height=33.0f;
            descLabel.frame=rect;
        }
        
        rect=lineView.frame;
        rect.origin.y=CELL_HEIGHT-rect.size.height;
        lineView.frame=rect;
    }
    
}

@end
