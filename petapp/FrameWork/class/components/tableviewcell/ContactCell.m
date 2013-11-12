//
//  ContactCell.m
//  PetNews
//
//  Created by fanty on 13-8-8.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactCell.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZShadowView.h"
#import "Utils.h"

#define CELL_HEIGHT  85.0f

#define IPAD_CELL_HEIGHT  100.0f

@implementation ContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleGray;
        self.accessoryType=UITableViewCellAccessoryNone;

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
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.numberOfLines=1;
        [nameLabel theme:@"petcell_title"];
        [self addSubview:nameLabel];
        [nameLabel release];
        
        descLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        descLabel.numberOfLines=0;
        [descLabel theme:@"petcell_desc"];
        [self addSubview:descLabel];
        [descLabel release];
        
        sexImageView=[[UIImageView alloc] init];
        [self addSubview:sexImageView];
        [sexImageView release];
        
        smallTipLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        smallTipLabel.numberOfLines=1;
        smallTipLabel.textAlignment=NSTextAlignmentRight;
        [smallTipLabel theme:@"petcell_smalltip"];
        [self addSubview:smallTipLabel];
        [smallTipLabel release];

        
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

-(void)tip:(NSString*)tip{
    smallTipLabel.text=tip;
    updateNeed=YES;
    
}

-(void)sex:(BOOL)sex{
    sexImageView.image=[[GTGZThemeManager sharedInstance] imageByTheme:sex?@"sex_man.png":@"sex_woman.png"];
    updateNeed=YES;
}

+(float)height{
    return ([Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!updateNeed)return;
    updateNeed=NO;
    CGRect rect;
    if([Utils isIPad]){
        smallTipLabel.frame=CGRectMake(0.0f, 15.0f, self.frame.size.width, 0.0f);
        [smallTipLabel sizeToFit];
        
        rect=smallTipLabel.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-20.0f;
        smallTipLabel.frame=rect;
        
        float w=CGRectGetMinX(smallTipLabel.frame)-CGRectGetMaxX(headImageView.frame)-20.0f-sexImageView.frame.size.width-10.0f;
        
        
        nameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+20.0f, 15.0f, w , 0.0f);
        [nameLabel sizeToFit];
        
        rect=nameLabel.frame;
        if(rect.size.width>w){
            rect.size.width=w;
            nameLabel.frame=rect;
        }
        
        rect=sexImageView.frame;
        rect.size=sexImageView.image.size;
        rect.origin.y=15.0f;
        rect.origin.x=CGRectGetMaxX(nameLabel.frame)+10.0f;
        sexImageView.frame=rect;
        
        descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+20.0f, CGRectGetMaxY(nameLabel.frame), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-40.0f, 0.0f);
        
        [descLabel sizeToFit];
        
        rect=descLabel.frame;
        if(rect.size.height>40.0f){
            rect.size.height=40.0f;
            descLabel.frame=rect;
        }
    }
    else{
        smallTipLabel.frame=CGRectMake(0.0f, 10.0f, self.frame.size.width, 0.0f);
        [smallTipLabel sizeToFit];
        
        rect=smallTipLabel.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-15.0f;
        smallTipLabel.frame=rect;
        
        float w=CGRectGetMinX(smallTipLabel.frame)-CGRectGetMaxX(headImageView.frame)-15.0f-sexImageView.frame.size.width-5.0f;
        
        
        nameLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, 10.0f, w , 0.0f);
        [nameLabel sizeToFit];
        
        rect=nameLabel.frame;
        if(rect.size.width>w){
            rect.size.width=w;
            nameLabel.frame=rect;
        }
        
        rect=sexImageView.frame;
        rect.size=sexImageView.image.size;
        rect.origin.y=10.0f;
        rect.origin.x=CGRectGetMaxX(nameLabel.frame)+5.0f;
        sexImageView.frame=rect;
        
        descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, CGRectGetMaxY(nameLabel.frame), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f, 0.0f);
        
        [descLabel sizeToFit];
        
        rect=descLabel.frame;
        if(rect.size.height>33.0f){
            rect.size.height=33.0f;
            descLabel.frame=rect;
        }
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
