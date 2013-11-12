//
//  ContactDetailHeader.m
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactDetailHeader.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
@implementation ContactDetailHeader

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        headerImage=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 50.0f, 50.0f)];
        [self addSubview:headerImage];
        [headerImage release];
        
        clickButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        clickButton.frame=CGRectMake(frame.size.width-90.0f-15.0f, 15.0f, 90.0f, 50.0f);
        [self addSubview:clickButton];
        
        
        float w=CGRectGetMinX(clickButton.frame)-CGRectGetMaxX(headerImage.frame)-20.0f;
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerImage.frame)+10.0f, 15.0f, w, 20.0f)];
        nameLabel.numberOfLines=1;
        [self addSubview:nameLabel];
        [nameLabel release];
        
        tipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerImage.frame)+10.0f, CGRectGetMaxY(nameLabel.frame)+10.0f, w, 20.0f)];
        tipLabel.numberOfLines=1;
        [self addSubview:tipLabel];
        [tipLabel release];
        
        sexImage=[[UIImageView alloc] init];
        [self addSubview:sexImage];
        [sexImage release];
        
        [nameLabel theme:@"contactdetail_name"];
        [tipLabel theme:@"contactdetail_tip"];
        
        frame.size.height=80.0f;
        self.frame=frame;
        
    }
    return self;
}

-(void)header:(NSString*)headerUrl name:(NSString*)name tip:(NSString*)tip sex:(BOOL)sex{
    [headerImage setUrl:headerUrl];
    nameLabel.text=name;
    tipLabel.text=tip;
    sexImage.image=[[GTGZThemeManager sharedInstance] imageByTheme:sex?@"sex_man.png":@"sex_woman.png"];
    
    [tipLabel sizeToFit];
    
    CGRect rect=sexImage.frame;
    rect.size=sexImage.image.size;
    rect.origin.x=CGRectGetMaxX(tipLabel.frame)+15.0f;
    rect.origin.y=CGRectGetMinY(tipLabel.frame);
    sexImage.frame=rect;

}

-(void)setIsFriend:(BOOL)value{
    [clickButton setTitle:lang(value?@"message":@"addFriend") forState:UIControlStateNormal];
}

@end
