//
//  SCMPParser.h
//  PetNews
//
//  Created by fanty on 13-2-16.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode+New.h"
#import "GDataXMLElement+New.h"
#import "GDataXMLNode.h"

#import "InterfaceUtils.h"


@class ApiError;

@interface XmlParser : NSObject<ParserInterface>{
    id result;
    ApiError* error;
}

- (void)onParse: (GDataXMLElement*) rootElement;


@end
