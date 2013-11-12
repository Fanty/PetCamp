//
//  AreaParser.h
//  PetNews
//
//  Created by Grace Lai on 14/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "XmlParser.h"

@interface AreaParser : XmlParser


- (void)onParse: (GDataXMLElement*) rootElement;

@end
