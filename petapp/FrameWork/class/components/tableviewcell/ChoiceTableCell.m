//
//  ChoiceTableCell.m
//  PetNews
//
//  Created by Grace Lai on 6/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "ChoiceTableCell.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZShadowView.h"

#define CELL_HEIGHT  85.0f

@implementation ChoiceTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle=UITableViewCellSelectionStyleGray;

        GTGZShadowView* shadowView=[[GTGZShadowView alloc] initWithFrame:CGRectMake(5.0f, (CELL_HEIGHT-50.0f)*0.5f-10.0f, 70.0f, 70.0f)];
        shadowView.shadowOpacity=0.9f;
        [self addSubview:shadowView];
        [shadowView release];
        
        
        iconImageView = [[ImageDownloadedView alloc] initWithFrame:CGRectMake(15.0f, (CELL_HEIGHT-50.0f)*0.5f, 50.0f, 50.0f)];
        [self addSubview:iconImageView];
        [iconImageView release];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.numberOfLines = 0;
        [titleLabel theme:@"choiceTitle"];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        /*
        shopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+15, CGRectGetMaxY(titleLabel.frame)+5, 100, 20)];
        [shopTitleLabel theme:@"choiceShopTitle"];
        [self addSubview:shopTitleLabel];
        [shopTitleLabel release];
        */
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+15, CGRectGetMaxY(titleLabel.frame)+5, 80, 30)];
        [priceLabel theme:@"choicePirceTitle"];
        [self addSubview:priceLabel];
        [priceLabel release];
        
        UIImage* img = [[GTGZThemeManager sharedInstance] imageByTheme:@"arrow_right.png"];
        UIImageView* arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - img.size.width*4, (CELL_HEIGHT - img.size.height)*0.5f, img.size.width, img.size.height)];
        arrow.image = img;
        [self addSubview:arrow];
        [arrow release];
        
        UIImageView* lineView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"]];
        lineView.frame=CGRectMake(0, CELL_HEIGHT-2, self.bounds.size.width, 2);
        [self addSubview:lineView];
        [lineView release];

        
        updateNeed=YES;
    }
    return self;
}


+(float)height{
    return CELL_HEIGHT;
}



-(void)headUrl:(NSString*)headUrl{
    [iconImageView setUrl:headUrl];

}


-(void)title:(NSString*)title{

    titleLabel.text = title;
    
    updateNeed=YES;
    
}



-(void)shopTitle:(NSString*)title{

    shopTitleLabel.text = title;
    updateNeed=YES;
}


-(void)setPriceLabel:(float)price{
    
    priceLabel.text = [NSString stringWithFormat:@"¥ %0.1f",price];
    updateNeed=YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(!updateNeed)return;
    updateNeed=NO;
    titleLabel.frame=CGRectMake(CGRectGetMaxX(iconImageView.frame)+15, (CELL_HEIGHT-50.0f)*0.5f, 205, 35);
    
    [titleLabel sizeToFit];
    
    CGRect rect = titleLabel.frame;
    if(rect.size.height>36.0f){
        rect.size.height=36.0f;
        titleLabel.frame=rect;
    }
    
    
    
    shopTitleLabel.frame=CGRectMake(CGRectGetMaxX(iconImageView.frame)+15, CGRectGetMaxY(titleLabel.frame)+5, 90, 20);
    
    priceLabel.frame=CGRectMake(CGRectGetMaxX(iconImageView.frame)+15, CGRectGetMaxY(titleLabel.frame), 80, 30);

}

@end
