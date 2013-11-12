//
//  BannerParser.m
//  PetNews
//
//  Created by Grace Lai on 21/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "BannerParser.h"
#import "BannerModel.h"

@implementation BannerParser

- (void)onParse: (GDataXMLElement*) rootElement{
        
    NSArray* array = [rootElement nodesForXPath:@"banners/banner" error:nil];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for(GDataXMLElement* element in array){
        
        if([[element name] isEqualToString:@"banner"]){
            
            BannerModel* bannerModel = [[BannerModel alloc] init];
            NSArray* infoArray = [element children];
            for(GDataXMLElement* bannerElement in infoArray){
                if([[bannerElement name] isEqualToString:@"id"]){
                    bannerModel.bid = [bannerElement stringValue];
                }
                else if([[bannerElement name] isEqualToString:@"image"]){
                    bannerModel.imageUrl = [bannerElement stringValue];
                }
                else if([[bannerElement name] isEqualToString:@"link"]){
                    bannerModel.link = [bannerElement stringValue];
                }
                else if([[bannerElement name] isEqualToString:@"target_id"]){
                    bannerModel.target_id = [bannerElement stringValue];
                }
            }
            [list addObject:bannerModel];
            [bannerModel release];
        }
    }
    [result release];
    result = [list retain];
    [list release];

}






@end
