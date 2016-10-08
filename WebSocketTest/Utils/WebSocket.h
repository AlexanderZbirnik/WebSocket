//
//  WebSocket.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 05.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const WebSocketConnectionStateNotification;
extern NSString * const WebSocketSendMessageNotification;
extern NSString * const WebSocketReceiveMessageNotification;

extern NSString * const WebSocketTitleUserInfoKey;
extern NSString * const WebSocketDescriptionUserInfoKey;
extern NSString * const WebSocketMessageObjectUserInfoKey;
extern NSString * const WebSocketDateUserInfoKey;

@interface WebSocket : NSObject

- (instancetype)initWithURL: (NSURL *) URL;

- (void) openConnection;
- (void) closeConnection;

- (void) sendMessage: (id) messageObject;

@end
