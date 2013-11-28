//
//  PetNewsParser.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsParser.h"
#import "PetNewsModel.h"
#import "PetUser.h"
@implementation PetNewsParser

- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* elements=[rootElement nodesForXPath:@"items/item" error:nil];
    if([elements count]<1)
        elements=[rootElement nodesForXPath:@"comment" error:nil];
    if([elements count]>0){
        NSMutableArray* list=[[NSMutableArray alloc] init];
        for(GDataXMLElement* element in elements){
            PetNewsModel* model=[[PetNewsModel alloc] init];
            PetUser* user=[[PetUser alloc] init];
            model.petUser=user;
            [user release];
            NSArray* _elements=[element children];
            for(GDataXMLElement* _element in _elements){
                if([[_element name] isEqualToString:@"id"]){
                    model.pid=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"uid"]){
                    model.petUser.uid=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"nickname"]){
                    model.petUser.nickname=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"user_image"]){
                    model.petUser.imageHeadUrl=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"content"]){
                    model.desc=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"images"]){
                    NSString* urls=[_element stringValue];
                    if([urls length]>3)
                        model.imageUrls=[urls componentsSeparatedByString:@","];
                }

                
                else if([[_element name] isEqualToString:@"like_count"]){
                    model.laudCount=[_element intValue];
                }
                else if([[_element name] isEqualToString:@"comment_count"]){
                    model.command_count=[_element intValue];

                }
                else if([[_element name] isEqualToString:@"createdate"]){
                    model.createdate=[_element dateValueFromNSTimeInterval];
                }
                else if([[_element name] isEqualToString:@"src_post"]){
                    NSArray* _elements=[_element children];
                    if([_elements count]>3){
                        PetNewsModel* scr_post=[[PetNewsModel alloc] init];
                        PetUser* petUser=[[PetUser alloc] init];
                        scr_post.petUser=petUser;
                        [petUser release];
                        model.scr_post=scr_post;
                        
                        for(GDataXMLElement* __element in _elements){
                            if([[__element name] isEqualToString:@"id"]){
                                scr_post.pid=[__element stringValue];
                            }
                            else if([[__element name] isEqualToString:@"uid"]){
                                scr_post.petUser.uid=[__element stringValue];
                            }
                            else if([[__element name] isEqualToString:@"nickname"]){
                                scr_post.petUser.nickname=[__element stringValue];
                            }
                            else if([[__element name] isEqualToString:@"user_image"]){
                                scr_post.petUser.imageHeadUrl=[__element stringValue];
                            }
                            else if([[__element name] isEqualToString:@"content"]){
                                scr_post.desc=[__element stringValue];
                            }
                            else if([[__element name] isEqualToString:@"images"]){
                                NSString* urls=[__element stringValue];
                                if([urls length]>3)
                                    scr_post.imageUrls=[urls componentsSeparatedByString:@","];
                            }
                            
                            
                            else if([[__element name] isEqualToString:@"like_count"]){
                                scr_post.laudCount=[__element intValue];
                            }
                            else if([[__element name] isEqualToString:@"comment_count"]){
                                scr_post.command_count=[__element intValue];
                                
                            }
                            else if([[__element name] isEqualToString:@"createdate"]){
                                scr_post.createdate=[__element dateValueFromNSTimeInterval];
                            }
                        }
                        [scr_post release];
                    }
                    
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
