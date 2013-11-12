//
//  CheckBoxView.m
//  PetNews
//
//  Created by Grace Lai on 15/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "CheckBoxView.h"
#import "GTGZThemeManager.h"

@implementation CheckBoxView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        clickBoxButtonViewArray = [[NSMutableArray alloc] init];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 30)*0.5f, 80, 30)];
        [titleLabel theme:@"checkBox_title"];
        [self addSubview:titleLabel];
        [titleLabel release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc{

    [clickBoxButtonViewArray release];
    [super dealloc];
}

-(void)setTitle:(NSString*)title{
    titleLabel.text = title;

}


-(void)setCheckBoxButton:(NSArray*)array{

    
    for(UIButton* button in clickBoxButtonViewArray){
    
        [button removeFromSuperview];
    }
    
    [clickBoxButtonViewArray removeAllObjects];
    
    
    float x = CGRectGetMaxX(titleLabel.frame)+10;
    
    for(int i=0;i<array.count;i++){
    
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 50, 50)];
        [button setImage:[[GTGZThemeManager sharedInstance] imageByTheme:[array objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[[GTGZThemeManager sharedInstance] imageByTheme:[NSString stringWithFormat:@"select_%@",[array objectAtIndex:i]]]  forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [clickBoxButtonViewArray addObject:button];
        [self addSubview:button];
        
        x = CGRectGetMaxX(button.frame)+10;
        [button release];
    }
}

-(void)clickButton:(id)sender{

    UIButton* button = (UIButton*)sender;
    
    for(UIButton* item in clickBoxButtonViewArray){
        item.selected = (item.tag == button.tag ? YES : NO);
    }
    
    
    if(self.delegate != nil){
        
        [self.delegate clickCheckBoxView:self clickIndex:button.tag];
    }

}

@end
