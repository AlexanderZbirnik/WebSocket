//
//  MessagesController.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "MessagesController.h"
#import "SendMessageCell.h"

#import "DataConverter.h"
#import "CoreDataManager.h"
#import "WebSocket.h"

#import "NSDate+Additions.h"

#import "Message+CoreDataClass.h"
#import "Message+CoreDataProperties.h"

@interface MessagesController ()

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;

@end

@implementation MessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView =
    [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    
    [self updateTableView];
    [self addNotifications];
}

#pragma mark - Private Methods

- (void) updateTableView {
    
    self.messages = [CoreDataManager findAllMessages];
    [self.tableView reloadData];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"sendMessageCell";
    
    SendMessageCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell =
        [[[SendMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    Message *message = [self.messages objectAtIndex:indexPath.row];
    
    cell.messageLabel.text = message.text;
    cell.onOffLabel.text = message.onOff ? @"On" : @"Off";
    cell.dateLabel.text = [message.date substringWithRange: NSMakeRange(0, message.date.length - 4)];
    cell.stateMessageLabel.text = message.isSended ? @"Sent" : @"Wait";
    
    return cell;
}


#pragma mark - Notifications

- (void) addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMessageNotification:)
                                                 name:CoreDataManagerSaveMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMessageNotification:)
                                                 name:CoreDataManagerUpdateMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessageNotification:)
                                                 name:WebSocketReceiveMessageNotification
                                               object:nil];

}

- (void) saveMessageNotification: (NSNotification *) notification {
    
    [self updateTableView];
}

- (void) updateMessageNotification: (NSNotification *) notification {
    
    [self updateTableView];
}

- (void) receiveMessageNotification: (NSNotification *) notification {
    
    if ([notification.userInfo objectForKey:WebSocketMessageObjectUserInfoKey]) {
        
        id object = [notification.userInfo objectForKey:WebSocketMessageObjectUserInfoKey];
        
        NSDictionary *dict = [DataConverter toDictionaryFromObject:object];

        [CoreDataManager findMessageWithText:[dict objectForKey: DataConverterMessageKey]
                                       onOff:[[dict objectForKey: DataConverterOnOffKey] boolValue]
                                        date:[dict objectForKey: DataConverterDateKey]
                         andChangeIsSendedOn:YES];
    }
}

- (void)dealloc {
    
    [_messages release];
    [_tableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
