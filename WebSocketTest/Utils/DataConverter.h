//
//  DataConverter.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 05.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    DataConverterFormatJSON,
    DataConverterFormatXML,
    DataConverterFormatBINARY,
    DataConverterFormatUNKNOWN
    
} DataConverterFormat;

extern NSString * const DataConverterMessageKey;
extern NSString * const DataConverterOnOffKey;
extern NSString * const DataConverterDateKey;

@interface DataConverter : NSObject

+ (id) objectWithDataFormat: (DataConverterFormat) dataFormat andDictionary: (NSDictionary *) dict;
+ (NSDictionary *) toDictionaryFromObject: (id) object;

+ (DataConverterFormat) getDataFormatInObject: (id) object;
+ (NSString *) getStringFormatInObject: (id) object;

+ (NSString *) toXMLFromDictionary: (NSDictionary *) dict;
+ (NSString *) toJSONFromDictionary: (NSDictionary *) dict;
+ (NSData *) toBINARYFromDictionary: (NSDictionary *) dict;

+ (NSDictionary *) toDictionaryFromXML: (NSString *) XMLString;
+ (NSDictionary *) toDictionaryFromJSON: (NSString *) JSONString;
+ (NSDictionary *) toDictionaryFromBINARY: (NSData *) binaryData;






@end
