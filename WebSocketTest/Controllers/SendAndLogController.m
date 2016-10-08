//
//  SendAndLogController.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 05.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "SendAndLogController.h"
#import "WebSocket.h"

@interface SendAndLogController ()

@property (retain, nonatomic) IBOutlet UILabel *infoConnectionLabel;
@property (retain, nonatomic) IBOutlet UITextView *connectionLogTextView;
@property (retain, nonatomic) IBOutlet UITextField *messageTextField;
@property (retain, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (retain, nonatomic) IBOutlet UISegmentedControl *formatDataSegmentControl;

@end

@implementation SendAndLogController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self addNotifications];
}

#pragma mark - Private methods

- (void) logFromUserInfo: (NSDictionary *) userInfo {
    
    NSMutableString *logString =
    [[[NSMutableString alloc] initWithFormat:@"%@", self.connectionLogTextView.text] autorelease];
    
    if ([userInfo objectForKey:WebSocketDateUserInfoKey]) {
        
        NSString *date =
        [NSString stringWithFormat:@"[%@] ", [userInfo objectForKey:WebSocketDateUserInfoKey]];
        
        [logString appendString:date];
    }
    
    if ([userInfo objectForKey:WebSocketDescriptionUserInfoKey]) {
        
        NSString *description =
        [NSString stringWithFormat:@"%@ ", [userInfo objectForKey:WebSocketDescriptionUserInfoKey]];
        
        [logString appendString:description];
    }
    
    if ([userInfo objectForKey:WebSocketMessageObjectUserInfoKey]) {
        
        NSString *messageObject =
        [NSString stringWithFormat:@"%@", [userInfo objectForKey:WebSocketMessageObjectUserInfoKey]];
        
        [logString appendString:messageObject];
    }

    [logString appendString:@"\n"];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.connectionLogTextView.text = logString;
    });
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    
    return YES;
}

#pragma mark -Actions

- (IBAction)sendMessageAction:(UIButton *)sender {
    
    [self.messageTextField endEditing:YES];
    
    DataConverterFormat format = (DataConverterFormat) self.formatDataSegmentControl.selectedSegmentIndex;
    
    [self.delegate sendAndLogController:self
                            sendMessage:self.messageTextField.text
                              andOnnOff:self.onOffSwitch.on
                           inDataFormat:format];
}

#pragma mark - Notifications

- (void) addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionStateNotification:)
                                                 name:WebSocketConnectionStateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendMessageNotification:)
                                                 name:WebSocketSendMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessageNotification:)
                                                 name:WebSocketReceiveMessageNotification
                                               object:nil];
}

- (void) connectionStateNotification: (NSNotification *) notification {
    
    if ([notification.userInfo objectForKey:WebSocketTitleUserInfoKey]) {
        
        self.infoConnectionLabel.text = [notification.userInfo objectForKey:WebSocketTitleUserInfoKey];
    }
    
    [self logFromUserInfo:notification.userInfo];
}

- (void) sendMessageNotification: (NSNotification *) notification {
    
    [self logFromUserInfo:notification.userInfo];
}

- (void) receiveMessageNotification: (NSNotification *) notification {
    
    [self logFromUserInfo:notification.userInfo];
}

- (void)dealloc {
    
    [_infoConnectionLabel release];
    [_connectionLogTextView release];
    [_messageTextField release];
    [_onOffSwitch release];
    [_formatDataSegmentControl release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
