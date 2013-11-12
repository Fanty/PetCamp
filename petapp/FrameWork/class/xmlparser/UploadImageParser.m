//
//  UploadImageParser.m
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "UploadImageParser.h"

@implementation UploadImageParser
- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* elements=[rootElement elementsForName:@"link"];
    if([elements count]>0){
        [result release];
        result=[[[elements objectAtIndex:0] stringValue] retain];
    }
}
@end
