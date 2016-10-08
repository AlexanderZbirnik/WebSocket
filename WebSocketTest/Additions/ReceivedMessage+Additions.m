//
//  ReceivedMessage+Additions.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 08.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "ReceivedMessage+Additions.h"
#import "DataConverter.h"
#import "WebSocket.h"

@implementation ReceivedMessage (Additions)

- (void) parseDictionary: (NSDictionary *) dict {
    
    self.text = [dict objectForKey:DataConverterMessageKey];
    self.onOff = [[dict objectForKey:DataConverterOnOffKey] boolValue];
    self.date = [dict objectForKey:DataConverterDateKey];
}

- (void) parseUserInfo: (NSDictionary *) userInfo {
    
    id object = [userInfo objectForKey:WebSocketMessageObjectUserInfoKey];
    
    self.formatData     = [DataConverter getStringFormatInObject:object];
    self.receivedDate   = [userInfo objectForKey: WebSocketDateUserInfoKey];
    
    NSDictionary *dict  = [DataConverter toDictionaryFromObject:object];
    
    self.text   = [dict objectForKey:DataConverterMessageKey];
    self.onOff  = [[dict objectForKey:DataConverterOnOffKey] boolValue];
    self.date   = [dict objectForKey:DataConverterDateKey];
}

@end
