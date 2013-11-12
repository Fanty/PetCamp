//
//  ChoiceBigView.m
//  PetNews
//
//  Created by 肖昶 on 13-10-13.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ChoiceBigView.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@implementation ChoiceBigView
@synthesize index;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        iconImageView = [[ImageDownloadedView alloc] init];
        [self addSubview:iconImageView];
        [iconImageView release];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.numberOfLines = 1;
        [titleLabel theme:@"choiceTitle"];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        
       
        redBgView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"redBg.png"]];
        redBgView.backgroundColor=[UIColor redColor];
        [self addSubview:redBgView];
        [redBgView release];
        
        priceLabel = [[UILabel alloc] init];
        priceLabel.numberOfLines=1;
        [priceLabel theme:@"choicePirceTitle"];
        [self addSubview:priceLabel];
        [priceLabel release];
        
        shopTitleLabel = [[UILabel alloc] init];
        shopTitleLabel.textAlignment=NSTextAlignmentRight;
        shopTitleLabel.numberOfLines=1;
        [shopTitleLabel theme:@"choiceShopTitle"];
        [self addSubview:shopTitleLabel];
        [shopTitleLabel release];
        
        
        lineView=[[UIView alloc] init];
        lineView.backgroundColor=[UIColor grayColor];
        [self addSubview:lineView];
        [lineView release];
    }
    return self;
}


+(float)height{
    return [[UIScreen mainScreen] applicationFrame].size.height/2.5f;
}



-(void)headUrl:(NSString*)headUrl{
    [iconImageView setUrl:headUrl];
    
}


-(void)title:(NSString*)title{
    titleLabel.text = title;
}

-(void)shopTitle:(NSString*)title{
    shopTitleLabel.text=[NSString stringWithFormat:lang(@"self_format"),title];
}

-(void)setPriceLabel:(float)price{
    priceLabel.text = [NSString stringWithFormat:@"¥ %0.1f",price];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if([Utils isIPad]){
        titleLabel.frame=CGRectMake(15.0f, 0.0f, self.frame.size.width-30.0f, 50.0f);
        redBgView.frame=CGRectMake(0.0f, self.frame.size.height-50.0f, self.frame.size.width, 50.0f);
        priceLabel.frame=CGRectMake(15.0f, self.frame.size.height-50.0f, self.frame.size.width-30.0f, 50.0f);
        shopTitleLabel.frame=CGRectMake(15.0f, self.frame.size.height-50.0f, self.frame.size.width-30.0f, 50.0f);
        iconImageView.frame=CGRectMake(0.0f, CGRectGetMaxY(titleLabel.frame), self.frame.size.width, CGRectGetMinY(redBgView.frame)-titleLabel.frame.size.height);
        
        lineView.frame=CGRectMake(self.frame.size.width-1.0f, 0.0f, 1, self.frame.size.height);

    }
    else{
        titleLabel.frame=CGRectMake(10.0f, 0.0f, self.frame.size.width-20.0f, 30.0f);
        redBgView.frame=CGRectMake(0.0f, self.frame.size.height-30.0f, self.frame.size.width, 30.0f);
        priceLabel.frame=CGRectMake(10.0f, self.frame.size.height-30.0f, self.frame.size.width-20.0f, 30.0f);
        shopTitleLabel.frame=CGRectMake(10.0f, self.frame.size.height-30.0f, self.frame.size.width-20.0f, 30.0f);
        iconImageView.frame=CGRectMake(0.0f, CGRectGetMaxY(titleLabel.frame), self.frame.size.width, CGRectGetMinY(redBgView.frame)-titleLabel.frame.size.height);
        
        lineView.frame=CGRectMake(self.frame.size.width-1.0f, 0.0f, 1, self.frame.size.height);
        
    }
    
}

@end
