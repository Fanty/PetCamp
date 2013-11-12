//
//  MessageParser.h
//  PetNews
//
//  Created by Grace Lai on 21/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "XmlParser.h"

@interface MessageParser : XmlParser

- (void)onParse: (GDataXMLElement*) rootElement;

@end
