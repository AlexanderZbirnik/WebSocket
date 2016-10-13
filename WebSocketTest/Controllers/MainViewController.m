//
//  MainViewController.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 04.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "MainViewController.h"
#import "SendAndLogController.h"

#import "WebSocket.h"

#import "DataConverter.h"
#import "NSDate+Additions.h"

#import "CoreDataManager.h"
#import "Message+CoreDataClass.h"
#import "Message+CoreDataProperties.h"

@interface MainViewController () < SendAndLogControllerDelegate >

@property (retain, nonatomic) WebSocket *webSocket;
@property (assign, nonatomic) DataConverterFormat dataFormat;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *URL = [[[NSURL alloc] initWithString:@"wss://echo.websocket.org"] autorelease];
    self.webSocket = [[[WebSocket alloc] initWithURL:URL] autorelease];
    
    [self addNotifications];
    [self manageChildViewControllers];
}

#pragma mark - Private methods

- (void) manageChildViewControllers {
    
    for (id object in self.childViewControllers) {
        
        if ([object isKindOfClass: [SendAndLogController class]]) {
            
            SendAndLogController *sendAndLogController = (SendAndLogController *) object;
            
            sendAndLogController.delegate = self;
        }
    }
}

#pragma mark - SendAndLogControllerDelegate

- (void) sendAndLogController: (SendAndLogController *) sendAndLogController sendMessage: (NSString *) message andOnnOff: (BOOL) onOff inDataFormat:(DataConverterFormat) dataFormat{
    
    self.dataFormat = dataFormat;
    
    [CoreDataManager saveMessage:message andOnOff:onOff];
}

#pragma mark - Notifications

- (void) addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMessageNotification:)
                                                 name:CoreDataManagerSaveMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionStateNotification:)
                                                 name:WebSocketConnectionStateNotification
                                               object:nil];
}

- (void) connectionStateNotification: (NSNotification *) notification {
    
    NSString *title = [notification.userInfo objectForKey:WebSocketTitleUserInfoKey];
    
    if ([title isEqualToString:WebSocketTitleConnected]) {
        
        NSArray *messages = [CoreDataManager findNotSendedMessages];
        
        if (messages.count > 0) {
            
            for (Message *message in messages) {
                
                [self sendMessage:message.text
                            onOff:@(message.onOff)
                          andDate:message.date];
            }
        }
    }
}

- (void) saveMessageNotification: (NSNotification *) notification {
    
    NSString *message = [notification.userInfo objectForKey:CoreDataManagerMessageUserInfoKey];
    NSNumber *onOff = [notification.userInfo objectForKey:CoreDataManagerOnOffUserInfoKey];
    NSString *date = [notification.userInfo objectForKey:CoreDataManagerDateUserInfoKey];
    
    [self sendMessage:message
                onOff:onOff
              andDate:date];
}

- (void) sendMessage: (NSString *) message onOff: (NSNumber *) onOff andDate: (NSString *) date {
    
    NSDictionary *dict = @{DataConverterMessageKey: message,
                           DataConverterOnOffKey: onOff,
                           DataConverterDateKey: date};
    
    id messageObject = [DataConverter objectWithDataFormat:self.dataFormat andDictionary:dict];
    
    [self.webSocket sendMessage:messageObject];
}

- (void)dealloc {
    
    [_webSocket release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}


@end
