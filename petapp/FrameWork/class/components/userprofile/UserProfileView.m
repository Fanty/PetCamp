//
//  UserProfileView.m
//  PetNews
//
//  Created by fanty on 13-8-23.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "UserProfileView.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "GTGZShadowView.h"
#import "Utils.h"

@interface UserProfileView()
-(void)btnAction:(UIButton*)button;
@end

@implementation UserProfileView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    
    UIImage* bgImg=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"default_myprofile.png"];
    frame.size.height=bgImg.size.height;
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.image=bgImg;
        button=[UIButton buttonWithType:UIButtonTypeCustom];

        if([Utils isIPad]){
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(69.0f, 312.0f, 108.0f, 108.0f)];
            titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(192.0f, 347.0f, 500.0f, 40.0f)];
            descLabel=[[UILabel alloc] initWithFrame:CGRectMake(71.0f, 428.0f, 560.0f, 25.0f)];

            button.frame=CGRectMake(645.0f, 410.0f, 90.0f,40.0f);
        }
        else{
            headImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(22.0f,123.0f, 60.0f, 60.0f)];
            titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(88.0f, 146.0f, 200.0f, 20.0f)];
            descLabel=[[UILabel alloc] initWithFrame:CGRectMake(23.0f, 189.0f, 220.0f, 15.0f)];

            button.frame=CGRectMake(246.0f, 176.0f, 58.0f,25.0f);

        }

        [self addSubview:headImageView];
        [headImageView release];
            
        titleLabel.numberOfLines=0;
        [titleLabel theme:@"profile_title"];
        [self addSubview:titleLabel];
        [titleLabel release];
            
        descLabel.numberOfLines=1;
        [descLabel theme:@"profile_desc"];
        [self addSubview:descLabel];
        [descLabel release];
        
        sexImageView=[[UIImageView alloc] init];
        [self addSubview:sexImageView];
        [sexImageView release];
            

        
        UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"actButton.png"];
        
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button theme:@"activaty_join"];
        
        [self addSubview:button];
        button.hidden=YES;
        /*
            addPetNewButton=[UIButton buttonWithType:UIButtonTypeCustom];
            addPetNewButton.tag=0;
            [addPetNewButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [addPetNewButton setBackgroundImage:img forState:UIControlStateNormal];
            [addPetNewButton setTitle:lang(@"sendPet") forState:UIControlStateNormal];
            [addPetNewButton theme:@"activaty_join"];
            
            addFriendButton=[UIButton buttonWithType:UIButtonTypeCustom];
            addFriendButton.tag=1;
            [addFriendButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [addFriendButton setBackgroundImage:img forState:UIControlStateNormal];
            [addFriendButton setTitle:lang(@"adFriend") forState:UIControlStateNormal];
            [addFriendButton theme:@"activaty_join"];


            [self addSubview:addPetNewButton];
            [self addSubview:addFriendButton];

            addFriendButton.frame=CGRectMake(frame.size.width-img.size.width-5.0f, frame.size.height-img.size.height, img.size.width, img.size.height);

            addPetNewButton.frame=CGRectMake(CGRectGetMinX(addFriendButton.frame)-img.size.width, frame.size.height-img.size.height, img.size.width, img.size.height);

         */

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

-(void)sex:(BOOL)sex{
    sexImageView.image=[[GTGZThemeManager sharedInstance] imageByTheme:sex?@"sex_man.png":@"sex_woman.png"];
    
    updateNeed=YES;
}

-(void)lovePetString:(NSString*)value{
    //lovePet.text=value;
    updateNeed=YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!updateNeed)return;
    updateNeed=NO;
    
    
    if([Utils isIPad]){
        titleLabel.frame=CGRectMake(192.0f, 347.0f, 500.0f, 40.0f);
    }
    else{
        titleLabel.frame=CGRectMake(88.0f, 146.0f, 200.0f, 20.0f);
    }
    
    
    [titleLabel sizeToFit];
    
    CGRect rect=sexImageView.frame;
    rect.size=sexImageView.image.size;
    rect.origin.x=CGRectGetMaxX(titleLabel.frame)+([Utils isIPad]?6.0f:3.0f);
    rect.origin.y=titleLabel.frame.origin.y+(titleLabel.frame.size.height-rect.size.height)*0.5f;
    sexImageView.frame=rect;
    
}

-(void)showAddFriend{
    button.hidden=NO;

    if(buttonType==0)
        buttonType=1;
    [button setTitle:lang((buttonType==2)?@"message":@"adFriend") forState:UIControlStateNormal];

}

-(void)showAddPetNew{
    button.hidden=NO;
    buttonType=0;
    [button setTitle:lang(@"sendPet") forState:UIControlStateNormal];
}

-(void)isContact:(BOOL)value{
    button.hidden=NO;

    buttonType=(value?2:1);
    [button setTitle:lang((buttonType==2)?@"message":@"adFriend") forState:UIControlStateNormal];
}

-(void)btnAction:(UIButton *)button{
    if(buttonType==0){
        if([self.delegate respondsToSelector:@selector(profileDidSendPetNews:)])
            [self.delegate profileDidSendPetNews:self];
    }
    else{
        if([self.delegate respondsToSelector:@selector(profileDidAddFriend:)])
            [self.delegate profileDidAddFriend:self];
    }
}



@end
