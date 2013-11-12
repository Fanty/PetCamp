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

#define  PROFILE_HEIGHT  85.0f
#define  IPAD_PROFILE_HEIGHT 150

@interface UserProfileView()
-(void)btnAction:(UIButton*)button;
@end

@implementation UserProfileView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    frame.size.height=[Utils isIPad]?IPAD_PROFILE_HEIGHT:PROFILE_HEIGHT;
    
    self = [super initWithFrame:frame];
    if (self) {
        if (self) {
            CGRect rect = CGRectMake(20.0f, (frame.size.height-65.0f)*0.5f, 65.0f, 65.0f);
            if([Utils isIPad])
                rect = CGRectMake(50.0f, (frame.size.height-135.0f)*0.5f, 135, 135);
            
            headImageView=[[ImageDownloadedView alloc] initWithFrame:rect];
            [self addSubview:headImageView];
            [headImageView release];
            
            titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
            titleLabel.numberOfLines=1;
            [titleLabel theme:@"profile_title"];
            [self addSubview:titleLabel];
            [titleLabel release];
            
            descLabel=[[UILabel alloc] initWithFrame:CGRectZero];
            descLabel.numberOfLines=0;
            [descLabel theme:@"profile_desc"];
            [self addSubview:descLabel];
            [descLabel release];
            
            lovePet=[[UILabel alloc] initWithFrame:CGRectZero];
            lovePet.numberOfLines=1;
            [lovePet theme:@"profile_desc"];
            [self addSubview:lovePet];
            [lovePet release];

            
            sexImageView=[[UIImageView alloc] init];
            [self addSubview:sexImageView];
            [sexImageView release];
            

            UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"actButton.png"];

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

            
        }


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
    sexImageView.image=[[GTGZThemeManager sharedInstance] imageByTheme:sex?@"pet_man.png":@"pet_woman.png"];
    updateNeed=YES;
}

-(void)lovePetString:(NSString*)value{
    lovePet.text=value;
    updateNeed=YES;
}

-(void)allWhite{
    titleLabel.textColor=[UIColor whiteColor];
    descLabel.textColor=[UIColor whiteColor];
    lovePet.textColor=[UIColor whiteColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!updateNeed)return;
    updateNeed=NO;
    float offset=([Utils isIPad]?50.0f:15.0f);

    if([lovePet.text length]<1){
        
        titleLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+offset, ([Utils isIPad]?10.0f:7.0f), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f , 0.0f);
        
        [titleLabel sizeToFit];
        
        descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+offset, CGRectGetMaxY(titleLabel.frame), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f, 0.0f);
        
        [descLabel sizeToFit];
        
        
        CGRect rect=titleLabel.frame;
        if(rect.size.width>self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f){
            rect.size.width=self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f;
            titleLabel.frame=rect;
        }
        
        rect=descLabel.frame;
        if(rect.size.height>55.0f){
            rect.size.height=55.0f;
            descLabel.frame=rect;
        }
        
        float height=titleLabel.frame.size.height+3.0f+descLabel.frame.size.height;
        
        rect=titleLabel.frame;
        rect.origin.y=(self.frame.size.height-height)*0.5f;
        titleLabel.frame=rect;
        
        rect=descLabel.frame;
        rect.origin.y=CGRectGetMaxY(titleLabel.frame)+3.0f;
        descLabel.frame=rect;
        
        rect=sexImageView.frame;
        rect.origin.x=CGRectGetMaxX(titleLabel.frame)+10.0f;
        rect.origin.y=CGRectGetMinY(titleLabel.frame)+2.0f;
        rect.size=sexImageView.image.size;
        sexImageView.frame=rect;
    }
    else{
        titleLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+offset, ([Utils isIPad]?20.0f:10.0f), self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f , 0.0f);
        
        [titleLabel sizeToFit];
        
        descLabel.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+offset, CGRectGetMaxY(titleLabel.frame)+5.0f, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f, 0.0f);
        
        [descLabel sizeToFit];
        
        
        CGRect rect=titleLabel.frame;
        if(rect.size.width>self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f){
            rect.size.width=self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f;
            titleLabel.frame=rect;
        }
        
        rect=descLabel.frame;
        if(rect.size.height>55.0f){
            rect.size.height=55.0f;
            descLabel.frame=rect;
        }
        
        lovePet.frame=CGRectMake(CGRectGetMaxX(headImageView.frame)+offset, CGRectGetMaxY(descLabel.frame)+5.0f, self.frame.size.width-CGRectGetMaxX(headImageView.frame)-offset*2.0f, 0.0f);
        [lovePet sizeToFit];
        

        rect=sexImageView.frame;
        rect.origin.x=CGRectGetMaxX(lovePet.frame)+10.0f;
        rect.origin.y=CGRectGetMinY(lovePet.frame);
        rect.size=sexImageView.image.size;
        sexImageView.frame=rect;
    }
    

}

-(void)showAddFriend:(BOOL)value{
    addFriendButton.hidden=!value;
    if(value){
        CGRect rect=addFriendButton.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-5.0f;
        addFriendButton.frame=rect;
        
        rect=addPetNewButton.frame;
        rect.origin.x=CGRectGetMinX(addFriendButton.frame)-rect.size.width;
        addPetNewButton.frame=rect;
    }
    else{
        CGRect rect=addPetNewButton.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-5.0f;
        addPetNewButton.frame=rect;

    }
}

-(void)showAddPetNew:(BOOL)value{
    addPetNewButton.hidden=!value;
}

-(void)isContact:(BOOL)value{
    [addFriendButton setTitle:lang(value?@"message":@"adFriend") forState:UIControlStateNormal];
}

-(void)btnAction:(UIButton *)button{
    if(button.tag==0){
        if([self.delegate respondsToSelector:@selector(profileDidSendPetNews:)])
            [self.delegate profileDidSendPetNews:self];
    }
    else{
        if([self.delegate respondsToSelector:@selector(profileDidAddFriend:)])
            [self.delegate profileDidAddFriend:self];
    }
}



@end
