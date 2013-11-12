//
//  SignUpParser.m
//  PetNews
//
//  Created by Grace Lai on 21/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "SignUpParser.h"
#import "PetUser.h"

@implementation SignUpParser

@synthesize checkUserExists;

- (void)onParse: (GDataXMLElement*) rootElement{

    
    NSArray* array = [rootElement children];

    for(GDataXMLElement* element in array){
        if(self.checkUserExists){
            if([[element name] isEqualToString:@"userExists"]){
                [result release];
                result=[[NSNumber numberWithBool:[element boolValue]] retain];
            }
            continue;
        }
        
        if([[element name] isEqualToString:@"user"]){
            
            PetUser* userModel = [[PetUser alloc] init];
            NSArray* infoArray = [element children];
            for(GDataXMLElement* userElement in infoArray){
                
                if([[userElement name] isEqualToString:@"uid"]){
                    userModel.uid = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"nickname"]){
                    userModel.nickname = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"image"]){
                    userModel.imageHeadUrl = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"phone"]){
                    userModel.bind_phone = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"sex"]){
                    userModel.sex = [[userElement stringValue] isEqualToString:@"f"];
                }
                else if([[userElement name] isEqualToString:@"email"]){
                    userModel.bind_email = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"province"]){
                    userModel.province = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"city"]){
                    userModel.city = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"area"]){
                    userModel.area = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"street"]){
                    userModel.street = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"property"]){
                    userModel.property = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"address"]){
                    userModel.address = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"description"]){
                    userModel.person_desc = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"age"]){
                    userModel.property = [userElement stringValue];
                }
                else if([[userElement name] isEqualToString:@"pet_info"]){
                    int petInfo=[userElement intValue];
                    if(petInfo==1)
                        userModel.petType=PetUserPetTypeCat;
                    else if(petInfo==2)
                        userModel.petType=PetUserPetTypeDog;
                    else
                        userModel.petType=PetUserPetTypeOther;
                }
                else if([[userElement name] isEqualToString:@"pet_gender"]){
                    userModel.pet_sex = [userElement boolValue];
                }
                else if([[userElement name] isEqualToString:@"online"]){
                    userModel.online = [userElement boolValue];
                }
                else if([[userElement name] isEqualToString:@"bind_weibo"]){
                    userModel.bind_weibo = [userElement stringValue];
                }

            }
            [result release];
            result = [userModel retain];
            [userModel release];
        }
        
        else if([[element name] isEqualToString:@"token"]){
            if(result!=nil){
                PetUser* userModel=(PetUser*)result;
                userModel.token=[element stringValue];
            }
        }
        
    }


}

@end
