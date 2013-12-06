//
//  ContactParser.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactParser.h"
#import "PetUser.h"
#import "PetNewsModel.h"
@implementation ContactParser
- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* elements=[rootElement nodesForXPath:@"contacts/contact" error:nil];
    if([elements count]<1)
        elements=[rootElement elementsForName:@"contact"];
    if([elements count]>0){
        NSMutableArray* list=[[NSMutableArray alloc] init];
        for(GDataXMLElement* element in elements){
            PetUser* model=[[PetUser alloc] init];
            NSArray* _elements=[element children];
            for(GDataXMLElement* _element in _elements){
                if([[_element name] isEqualToString:@"uid"]){
                    model.uid=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"nickname"]){
                    model.nickname=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"user_image"]){
                    model.imageHeadUrl=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"phone"]){
                    model.bind_phone=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"email"]){
                    model.bind_email=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"province"]){
                    model.province=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"city"]){
                    model.city=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"area"]){
                    model.area=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"street"]){
                    model.street=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"property"]){
                    model.property=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"address"]){
                    model.address=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"sex"]){
                    model.sex=[_element boolValue];
                }
                else if([[_element name] isEqualToString:@"user_description"]){
                    model.person_desc=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"age"]){
                    model.age=[_element intValue];
                }
                else if([[_element name] isEqualToString:@"pet"]){
                    model.petType=(PetUserPetType)[_element intValue];
                }
                else if([[_element name] isEqualToString:@"pet_sex"]){
                    model.pet_sex=[_element boolValue];
                }
                else if([[_element name] isEqualToString:@"whetherInContact"]){
                    model.whetherInContact=[_element boolValue];
                }
                else if([[_element name] isEqualToString:@"dictance"]){
                    model.dictance=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"last_post"]){
                    
                    NSArray* __array=[_element children];
                    PetNewsModel* petNewsModel=[[PetNewsModel alloc] init];
                    for(GDataXMLElement* __element in __array){
                        if([[__element name] isEqualToString:@"content"]){
                            petNewsModel.desc=[__element stringValue];
                        }
                        else if([[__element name] isEqualToString:@"images"]){
                            NSString* urls=[_element stringValue];
                            if([urls length]>3)
                                petNewsModel.imageUrls=[urls componentsSeparatedByString:@","];

                        }
                        else if([[__element name] isEqualToString:@"createtime"]){
                            petNewsModel.createdate=[__element dateValueFromNSTimeInterval];
                        }
                    }
                    
                    model.petNewsModel=petNewsModel;
                    [petNewsModel release];

                }
            }
            
            [list addObject:model];
            [model release];
        }
        [result release];
        result=[list retain];
        [list release];
    }
}
@end
