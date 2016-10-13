//
//  CoreDataManager.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "CoreDataManager.h"
#import "NSDate+Additions.h"

NSString * const CoreDataManagerSaveMessageNotification     = @"CoreDataManagerSaveMessageNotification";
NSString * const CoreDataManagerUpdateMessageNotification   = @"CoreDataManagerUpdateMessageNotification";

NSString * const CoreDataManagerMessageUserInfoKey          = @"CoreDataManagerMessageUserInfoKey";
NSString * const CoreDataManagerOnOffUserInfoKey            = @"CoreDataManageronOffUserInfoKey";
NSString * const CoreDataManagerDateUserInfoKey             = @"CoreDataManagerDateUserInfoKey";

@implementation CoreDataManager

+ (void) saveMessage: (NSString *) text andOnOff: (BOOL) onOff {
    
    NSString *date = [[NSDate date] formattedDateString];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {

        Message *messageEntity = [Message MR_createEntityInContext:localContext];
        
        messageEntity.text = text;
        messageEntity.date = date;
        messageEntity.onOff = onOff;
                
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (contextDidSave) {
            
            NSDictionary *userInfo =
            @{CoreDataManagerMessageUserInfoKey: text,
              CoreDataManagerOnOffUserInfoKey: @(onOff),
              CoreDataManagerDateUserInfoKey: date};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataManagerSaveMessageNotification
                                                                object:nil
                                                              userInfo:userInfo];
        }
        
    }];
}

#pragma mark - find messages methods

+ (NSArray *) findAllMessages {
    
     return [Message MR_findAllSortedBy:@"date" ascending:NO];
}

+ (NSArray *) findNotSendedMessages {
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"isSended == %@", @(0)];

    return [Message MR_findAllSortedBy:@"date" ascending:YES withPredicate:predicate];
}

+ (void) findMessageWithText: (NSString *) text onOff: (BOOL) onOff date: (NSString *) date andChangeIsSendedOn: (BOOL) isSended {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"text == %@ && onOff == %@ && date == %@", text, @(onOff), date];
        
        Message *message = [Message MR_findFirstWithPredicate:predicate inContext:localContext];
        
        message.isSended = isSended;
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (contextDidSave) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataManagerUpdateMessageNotification
                                                                object:nil
                                                              userInfo:nil];
        }
    }];
}

@end
