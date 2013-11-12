//
//  AreaParser.m
//  PetNews
//
//  Created by Grace Lai on 14/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "AreaParser.h"
#import "AreaModel.h"

@implementation AreaParser

- (void)onParse: (GDataXMLElement*) rootElement{

    NSMutableArray* list = [[NSMutableArray alloc] init];

    NSArray *domArr=[rootElement children];
    for (int i=0; i<[domArr count]; i++){
        
        GDataXMLElement  *parentElement=[domArr objectAtIndex:i];
        if([[parentElement name] isEqualToString:@"province"]){
            
            AreaModel* model = [[AreaModel alloc] init];
        
            model.areaId = [[parentElement attributeForName:@"id"] intValue];
            model.name = [[parentElement attributeForName:@"name"] stringValue];
            NSArray* cityArr = [parentElement children];
            NSMutableArray* cityArray = [[NSMutableArray alloc] init];
            for(int j=0;j<[cityArr count];j++){
            
                AreaModel* cityModel = [[AreaModel alloc] init];
                GDataXMLElement  *cityElement=[cityArr objectAtIndex:j];
                if([[cityElement name] isEqualToString:@"city"]){
                    
                    cityModel.areaId = [[cityElement attributeForName:@"id"] intValue];
                    cityModel.name = [[cityElement attributeForName:@"name"] stringValue];
                    
                    NSArray* areaArr = [cityElement children];
                    NSMutableArray* areaArray = [[NSMutableArray alloc] init];
                    for(int z=0;z<[areaArr count];z++){
                    
                        AreaModel* areaModel = [[AreaModel alloc] init];
                        GDataXMLElement  *areaElement=[areaArr objectAtIndex:z];
                        if([[areaElement name] isEqualToString:@"area"]){
                            areaModel.areaId = [[areaElement attributeForName:@"id"] intValue];
                            areaModel.name = [[areaElement attributeForName:@"name"] stringValue];
                        }
                        [areaArray addObject:areaModel];
                        [areaModel release];
                    
                    }
                    cityModel.list = areaArray;
                    [areaArray release];

                }
                [cityArray addObject:cityModel];
                [cityModel release];
            
            }
            model.list = cityArray;
            [cityArray release];
            [list addObject:model];
            [model release];
        
        }
    }
    [result release];
    result = [list retain];
    [list release];
 
    
    



}

@end
