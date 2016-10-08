//
//  DataConverter.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 05.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "DataConverter.h"

NSString * const DataConverterMessageKey    = @"DataConverterMessageKey";
NSString * const DataConverterOnOffKey      = @"DataConverterOnOffKey";
NSString * const DataConverterDateKey       = @"DataConverterDateKey";

@implementation DataConverter

+ (id) objectWithDataFormat: (DataConverterFormat) dataFormat andDictionary: (NSDictionary *) dict {
    
    id messageObject;
    
    switch (dataFormat) {
            
        case DataConverterFormatJSON:
            
            messageObject = [DataConverter toJSONFromDictionary:dict];
            break;
            
        case DataConverterFormatXML:
            
            messageObject = [DataConverter toXMLFromDictionary:dict];
            break;
            
        case DataConverterFormatBINARY:
            
            messageObject = [DataConverter toBINARYFromDictionary:dict];
            break;
            
        default:
            messageObject = nil;
            break;
    }
    
    return messageObject;
}

+ (NSDictionary *) toDictionaryFromObject: (id) object {
    
    NSDictionary *dict;
    
    DataConverterFormat dataFormat = [self getDataFormatInObject:object];
    
    switch (dataFormat) {
            
        case DataConverterFormatJSON:
            
            dict = [DataConverter toDictionaryFromJSON:object];
            break;
            
        case DataConverterFormatXML:
            
            dict = [DataConverter toDictionaryFromXML:object];
            break;
            
        case DataConverterFormatBINARY:
            
            dict = [DataConverter toDictionaryFromBINARY:object];
            break;
            
        default:
            dict = nil;
            break;
    }
    
    return dict;
}

+ (DataConverterFormat) getDataFormatInObject: (id) object {
    
    if ([object isKindOfClass:[NSData class]]) {
        
        return DataConverterFormatBINARY;
        
    } else if ([object isKindOfClass:[NSString class]]) {
        
        NSString *objectString = (NSString *) object;
        
        NSRange range = [objectString rangeOfString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
        
        if (range.length > 0) {
            
            return DataConverterFormatXML;
            
        } else {
            
            return DataConverterFormatJSON;
        }
    }
    
    return DataConverterFormatUNKNOWN;
}

+ (NSString *) getStringFormatInObject: (id) object {
    
    DataConverterFormat dataFormat = [DataConverter getDataFormatInObject:object];
    
    NSString *stringFormat = @"";
    
    switch (dataFormat) {
            
        case DataConverterFormatJSON:
            
            stringFormat = @"JSON";
            break;
            
        case DataConverterFormatXML:
            
            stringFormat = @"XML";
            break;
            
        case DataConverterFormatBINARY:
            
            stringFormat = @"BINARY";;
            break;
            
        default:
            stringFormat = nil;
            break;
    }
    
    return stringFormat;
}

+ (NSString *) toXMLFromDictionary: (NSDictionary *) dict {
    
    NSError *error;
    
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:dict
                                                                 format:NSPropertyListXMLFormat_v1_0
                                                                options:NSPropertyListMutableContainersAndLeaves
                                                                  error:&error];
    
    if (!xmlData) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        
        return nil;
        
    } else {
        
        NSString *xmlString =
        [[[NSString alloc] initWithData: xmlData encoding: NSUTF8StringEncoding] autorelease];
        
        return xmlString;
    }
}

+ (NSString *) toJSONFromDictionary: (NSDictionary *) dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        
        return nil;
        
    } else {
        
        NSString *jsonString =
        [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
        
        return jsonString;
    }
}

+ (NSData *) toBINARYFromDictionary: (NSDictionary *) dict {
        
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    if (!data) {
        
        return nil;
        
    } else {
        
        return data;
    }
}


+ (NSDictionary *) toDictionaryFromXML: (NSString *) XMLString {
    
    NSError *error;
    NSPropertyListFormat format;
    NSDictionary *dict;
    
    NSData* xmlData = [XMLString dataUsingEncoding:NSUTF8StringEncoding];
    
    dict = [NSPropertyListSerialization propertyListWithData:xmlData
                                                     options:NSPropertyListMutableContainersAndLeaves
                                                      format:&format
                                                       error:&error];
    if(!dict) {
        
        return nil;
        
    } else {
        
        return dict;
    }
}

+ (NSDictionary *) toDictionaryFromJSON: (NSString *) JSONString {
    
    NSError *error;
    
    NSData *jsonData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    if(!dict) {
        
        return nil;
        
    } else {
        
        return dict;
    }
}

+ (NSDictionary *) toDictionaryFromBINARY: (NSData *) binaryData {
    
    NSDictionary *dict = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:binaryData];
    
    if(!dict) {
        
        return nil;
        
    } else {
        
        return dict;
    }
}

@end
