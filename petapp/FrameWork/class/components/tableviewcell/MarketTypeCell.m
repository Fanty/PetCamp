//
//  MarketTypeCell.m
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MarketTypeCell.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZShadowView.h"
#import "Utils.h"
#define CELL_HEIGHT  70.0f
#define IPAD_CELL_HEIGHT  165.0f

@implementation MarketTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle=UITableViewCellSelectionStyleGray;
        
        float height=([Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT);

        if([Utils isIPad])
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(25.0f, (height-137.0f)*0.5f, 137.0f, 137.0f)];
        else
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(10.0f, (height-58.0f)*0.5f, 58.0f, 58.0f)];

        [self addSubview:headImageView];
        [headImageView release];
        
        if([Utils isIPad])
            titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+10.0f, 0.0f, 500.0f, 90.0f)];
        else
            titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+5.0f, 0.0f, 200.0f, 35.0f)];

        titleLabel.numberOfLines=1;
        [titleLabel theme:@"type_title"];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        if([Utils isIPad])
            descLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+10.0f, CGRectGetMaxY(titleLabel.frame), 500.0f, height-10.0f-CGRectGetMaxY(titleLabel.frame))];
        else
            descLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+5.0f, CGRectGetMaxY(titleLabel.frame), 200.0f, height-5.0f-CGRectGetMaxY(titleLabel.frame))];
        descLabel.numberOfLines=1;
        [descLabel theme:@"type_desc"];
        [self addSubview:descLabel];
        [descLabel release];
        
        lineView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"]];
            
        
        [self addSubview:lineView];
        [lineView release];
        
    }
    return self;
}

+(float)height{
    return ([Utils isIPad]?IPAD_CELL_HEIGHT:CELL_HEIGHT);
}

-(void)headerUrl:(NSString*)headerUrl title:(NSString*)title desc:(NSString*)desc{
    [headImageView setUrl:headerUrl];
    titleLabel.text=title;
    descLabel.text=desc;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect=lineView.frame;
    rect.origin.y=self.frame.size.height-rect.size.height;
    rect.size.width=self.frame.size.width;
    lineView.frame=rect;

}

@end
