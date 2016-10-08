//
//  CoreDataManager.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MagicalRecord/MagicalRecord.h>
#import "Message+CoreDataClass.h"
#import "Message+CoreDataProperties.h"

extern NSString * const CoreDataManagerSaveMessageNotification;
extern NSString * const CoreDataManagerUpdateMessageNotification;

extern NSString * const CoreDataManagerMessageUserInfoKey;
extern NSString * const CoreDataManagerOnOffUserInfoKey;
extern NSString * const CoreDataManagerDateUserInfoKey;

@interface CoreDataManager : NSObject

+ (void) saveMessage: (NSString *) text andOnOff: (BOOL) onOff;

+ (NSArray *) findAllMessages;
+ (void) findMessageWithText: (NSString *) text onOff: (BOOL) onOff date: (NSString *) date andChangeIsSendedOn: (BOOL) isSended;

@end
