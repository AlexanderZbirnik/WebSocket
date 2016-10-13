//
//  WebSocket.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 05.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "WebSocket.h"
#import <SocketRocket/SocketRocket.h>
#import "NSDate+Additions.h"

NSString * const WebSocketConnectionStateNotification    = @"WebSocketConnectionStateNotification";
NSString * const WebSocketSendMessageNotification        = @"WebSocketSendMessageNotification";
NSString * const WebSocketReceiveMessageNotification     = @"WebSocketReceiveMessageNotification";

NSString * const WebSocketTitleUserInfoKey               = @"WebSocketTitleUserInfoKey";
NSString * const WebSocketDescriptionUserInfoKey         = @"WebSocketDescriptionUserInfoKey";
NSString * const WebSocketMessageObjectUserInfoKey       = @"WebSocketMessageObjectUserInfoKey";
NSString * const WebSocketDateUserInfoKey                = @"WebSocketDateUserInfoKey";

NSString * const WebSocketTitleOpenConnection            = @"Open connection...";
NSString * const WebSocketTitleConnected                 = @"Connected";
NSString * const WebSocketTitleSendMessage               = @"Send message";
NSString * const WebSocketTitleDisconnected              = @"Disconnected";
NSString * const WebSocketTitleCloseConnection           = @"Close connection";
NSString * const WebSocketTitleReceivedMessage           = @"Received message";

@interface WebSocket() <SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
}

@property (retain, nonatomic) NSURL *URL;

@end

@implementation WebSocket

- (instancetype)initWithURL: (NSURL *) URL {
    
    self = [super init];
    if (self) {
        
        self.URL = URL;
        
        [self openConnection];
    }
    return self;
}


#pragma mark - Notification method

- (void) postNotification: (NSString *) notification withTitle: (NSString *) title description: (id) description date: (NSString *) date andMessageObject: (id) messageObject {
    
    NSDictionary *defaultDict = @{WebSocketTitleUserInfoKey: title,
                                  WebSocketDescriptionUserInfoKey: description,
                                  WebSocketDateUserInfoKey: date};
    
    NSMutableDictionary *userInfo =
    [[[NSMutableDictionary alloc] initWithDictionary:defaultDict] autorelease];
    
    if (messageObject != nil) {
        
        [userInfo setObject:messageObject forKey:WebSocketMessageObjectUserInfoKey];
    }

    
    [[NSNotificationCenter defaultCenter] postNotificationName:notification
                                                        object:nil
                                                      userInfo:userInfo];
}

#pragma mark - WebSocket methods

- (void) openConnection {
    
    _webSocket.delegate = nil;
    [_webSocket close];
    [_webSocket release];

    _webSocket = [[SRWebSocket alloc] initWithURL:self.URL];
    _webSocket.delegate = self;
    
    NSString *title = WebSocketTitleOpenConnection;
    NSString *description = [NSString stringWithFormat:@"Openned connection to %@", self.URL.absoluteString];
    NSString *date = [[NSDate date] formattedDateString];

    [self postNotification:WebSocketConnectionStateNotification withTitle:title description:description date:date andMessageObject:nil];
    
    [_webSocket open];
}

- (void) closeConnection {
    
    NSString *title = WebSocketTitleCloseConnection;
    NSString *description = [NSString stringWithFormat:@"User close connection to %@", self.URL.absoluteString];
    NSString *date = [[NSDate date] formattedDateString];
    
    [self postNotification:WebSocketConnectionStateNotification withTitle:title description:description date:date andMessageObject:nil];
    
    NSString *reasonString = [NSString stringWithFormat:@"Reason: user closed connection to %@", self.URL];
    
    [_webSocket closeWithCode:SR_CLOSED reason:reasonString];
}

- (void) sendMessage: (id) messageObject {
    
    NSString *title = WebSocketTitleSendMessage;
    NSString *description = @"Send";
    NSString *date = [[NSDate date] formattedDateString];
    
    [self postNotification:WebSocketSendMessageNotification withTitle:title description:description date:date andMessageObject:messageObject];
    
    if (_webSocket.readyState == SR_OPEN) {
        
        [_webSocket send:messageObject];
    } 
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
    NSString *title = WebSocketTitleConnected;
    NSString *description = [NSString stringWithFormat:@"Connected to %@", self.URL.absoluteString];
    NSString *date = [[NSDate date] formattedDateString];
    
    [self postNotification:WebSocketConnectionStateNotification withTitle:title description:description date:date andMessageObject:nil];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
        
    NSString *title = WebSocketTitleDisconnected;
    NSString *description =
    [NSString stringWithFormat:@"Connection failed to %@. Error: %@", self.URL.absoluteString, [error localizedDescription]];
    NSString *date = [[NSDate date] formattedDateString];
    
    [self postNotification:WebSocketConnectionStateNotification withTitle:title description:description date:date andMessageObject:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self openConnection];
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    NSString *title = WebSocketTitleCloseConnection;
    NSString *description =
    [NSString stringWithFormat:@"Connection to %@ closed. %@", self.URL.absoluteString, reason];
    NSString *date = [[NSDate date] formattedDateString];
    
    [self postNotification:WebSocketConnectionStateNotification withTitle:title description:description date:date andMessageObject:nil];
    
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
        
    NSString *title = WebSocketTitleReceivedMessage;
    NSString *description = @"Received";
    NSString *date = [[NSDate date] formattedDateString];
    
    [self postNotification:WebSocketReceiveMessageNotification withTitle:title description:description date:date andMessageObject:message];
}

- (void)dealloc
{
    [_URL release];
    
    [super dealloc];
}



@end
