//
//  ReceivedController.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "ReceivedController.h"
#import "WebSocket.h"
#import "DataConverter.h"
#import "NSDate+Additions.h"
#import "ReceivedCell.h"
#import "ReceivedMessage.h"
#import "ReceivedMessage+Additions.h"

@interface ReceivedController ()

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *receivedMessages;

@end

@implementation ReceivedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotifications];
    
    self.receivedMessages =
    [[[NSMutableArray alloc] init] autorelease];
    
    self.tableView.tableFooterView =
    [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.receivedMessages.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"receivedCell";
    
    ReceivedCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[[ReceivedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    ReceivedMessage *received = [self.receivedMessages objectAtIndex:indexPath.row];
    
    cell.formatLabel.text = received.formatData;
    cell.onOffLabel.text = received.onOff ? @"ON" : @"OFF";
    cell.messageLabel.text = received.text;
    cell.dateLabel.text = received.date;
    cell.receivedDateLabel.text = received.receivedDate;
    
    return cell;
}

#pragma mark - Notifications

- (void) addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessageNotification:)
                                                 name:WebSocketReceiveMessageNotification
                                               object:nil];
    
}

- (void) receiveMessageNotification: (NSNotification *) notification {
    
    if ([notification.userInfo objectForKey:WebSocketMessageObjectUserInfoKey]) {
        
        ReceivedMessage *received = [[ReceivedMessage alloc] init];
        
        [received parseUserInfo:notification.userInfo];
        
        [self.receivedMessages insertObject:received atIndex:0];
        
        [received release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    }
}

- (void)dealloc {
    
    [_tableView release];
    [_receivedMessages release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
