//
//  ReceivedMessage.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceivedMessage : NSObject

@property (retain, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL onOff;
@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *receivedDate;

@property (retain, nonatomic) NSString *formatData;


@end
