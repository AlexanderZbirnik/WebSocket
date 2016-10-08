//
//  SendAndLogController.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 05.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataConverter.h"

@protocol SendAndLogControllerDelegate;

@interface SendAndLogController : UIViewController

@property (assign, nonatomic) id < SendAndLogControllerDelegate > delegate;

@end

@protocol SendAndLogControllerDelegate

@required

- (void) sendAndLogController: (SendAndLogController *) sendAndLogController sendMessage: (NSString *) message andOnnOff: (BOOL) onOff inDataFormat: (DataConverterFormat) dataFormat;

@end
