//
//  SCMPParser.m
//  PetNews
//
//  Created by fanty on 13-2-16.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "XmlParser.h"
#import "ApiError.h"

@implementation XmlParser

- (void)dealloc{
    [result release];
    [error release];
    [super dealloc];
}

-(void)parse:(NSData*)data{
    
    [result release];
    result=nil;
    [error release];
    error=nil;
    

    if([data length]<1){
        if(error==nil)
            error=[[ApiError alloc] init];
        return;
    }
    
    NSString* xml=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil];
    
    [xml release];
    

    GDataXMLElement *rootElement = [xmlDoc rootElement];
    if(rootElement!=nil){
        [self onParse:rootElement];
        if(result==nil){
            if(error==nil)
                error=[[ApiError alloc] init];
            
            BOOL hasStatus=([[rootElement elementsForName:@"status"] count]>0);
            error.status=[[[rootElement elementsForName:@"status"] objectAtIndex:0] boolValue];
            error.errorCode=[[[rootElement elementsForName:@"code"] objectAtIndex:0] stringValue];

            error.errorMessage=[[[rootElement elementsForName:@"message"] objectAtIndex:0] stringValue];

            if(!hasStatus && [error.errorCode length]<1 && [[rootElement name] isEqualToString:@"result"]){
                
                error.status=YES;
            }

        }

    }
    [xmlDoc release];
    
    if(result==nil){
        if(error==nil)
            error=[[ApiError alloc] init];
    }

}

-(void) onParse:(GDataXMLElement *)rootElement{

}

-(id)getResult{
    return result;
}
-(ApiError*)getError{
    return error;
}

@end
