//
//  SendMessageCell.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "SendMessageCell.h"

@implementation SendMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    [_messageLabel release];
    [_onOffLabel release];
    [_dateLabel release];
    [_stateMessageLabel release];
    
    [super dealloc];
    
}

@end
