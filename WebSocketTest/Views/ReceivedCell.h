//
//  ReceivedCell.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *formatLabel;
@property (retain, nonatomic) IBOutlet UILabel *onOffLabel;
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *receivedDateLabel;

@end
