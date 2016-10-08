//
//  ReceivedMessage+Additions.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 08.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "ReceivedMessage.h"

@interface ReceivedMessage (Additions)

- (void) parseDictionary: (NSDictionary *) dict;
- (void) parseUserInfo: (NSDictionary *) userInfo;

@end
