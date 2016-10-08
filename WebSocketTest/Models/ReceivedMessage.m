//
//  ReceivedMessage.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "ReceivedMessage.h"

@implementation ReceivedMessage

- (void)dealloc {
    
    [_text release];
    [_date release];
    [_receivedDate release];
    [_formatData release];
    
    [super dealloc];
}

@end
