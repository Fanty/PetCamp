//
//  User.h
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum _PetUserPetType{
    PetUserPetTypeDog=0,
    PetUserPetTypeCat=1,
    PetUserPetTypeOther
}PetUserPetType;


@interface PetUser : NSObject

@property(nonatomic,retain) NSString* uid;
@property(nonatomic,retain) NSString* account;
@property(nonatomic,retain) NSString* accountType;
@property(nonatomic,retain) NSString* nickname;
@property(nonatomic,retain) NSString* imageHeadUrl;

@property(nonatomic,retain) NSString* password;
@property(nonatomic,assign) int age;
@property(nonatomic,retain) NSString* bind_phone;
@property(nonatomic,retain) NSString* bind_email;
@property(nonatomic,retain) NSString* bind_weibo;
@property(nonatomic,assign) BOOL online;
@property(nonatomic,retain) NSString* province;
@property(nonatomic,retain) NSString* city;
@property(nonatomic,retain) NSString* area;
@property(nonatomic,retain) NSString* street;
@property(nonatomic,retain) NSString* property;


@property(nonatomic,retain) NSString* address;
@property(nonatomic,retain) NSString* person_desc;
@property(nonatomic,assign) BOOL sex;
@property(nonatomic,assign) PetUserPetType petType;
@property(nonatomic,assign) BOOL pet_sex;
@property(nonatomic,assign) BOOL whetherInContact;
@property(nonatomic,retain) NSString* dictance;

@property(nonatomic,retain) NSString* token;

@property(nonatomic,retain) NSString* key;

-(void)copyPet:(PetUser*)petUser;

@end

