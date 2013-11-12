//
//  ActivatyCell.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ActivatyCell.h"

#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZShadowView.h"
#import "Utils.h"
#define CELL_HEIGHT  85.0f
#define IPAD_CELL_HEIGHT  100.0f

@interface ActivatyCell()
-(void)btnClick;
@end

@implementation ActivatyCell
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

-(void)title:(NSString*)title{
    titleLabel.text=title;
    updateNeed=YES;
}

-(void)desc:(NSString*)desc{
    descLabel.text=desc;
    updateNeed=YES;
}

-(void)laud:(int)laud{
    smallTipLabel.text=[NSString stringWithFormat:lang(@"activaty_count"),laud];
    updateNeed=YES;
}

-(void)tip:(NSString*)tip{
    smallTipLabel.text=tip;
    updateNeed=YES;
    
}

+(float)height{
    return ([Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT);
}

-(void)btnClick{
    if([self.delegate respondsToSelector:@selector(activatyCellDelegate:)])
        [self.delegate activatyCellDelegate:self];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if(!updateNeed)return;
    updateNeed=NO;
    titleLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, 10.0f, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f , 0.0f);
    
    [titleLabel sizeToFit];
    
    CGRect rect=titleLabel.frame;
    if(rect.size.width>self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f){
        rect.size.width=self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f;
        titleLabel.frame=rect;
    }
    
        
    if([Utils isIPad])
        smallTipLabel.frame=CGRectMake(15.0f, IPAD_CELL_HEIGHT-40.0f, self.frame.size.width-30.0f, 30.0f);
    else
        smallTipLabel.frame=CGRectMake(15.0f, CELL_HEIGHT-25.0f, self.frame.size.width-30.0f, 15.0f);
    
    
    descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+15.0f, CGRectGetMaxY(titleLabel.frame), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-30.0f, 0.0f);
    
    [descLabel sizeToFit];
    
    rect=descLabel.frame;
    if(rect.size.height>33.0f){
        rect.size.height=33.0f;
        descLabel.frame=rect;
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

