//
//  Message+CoreDataProperties.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "Message+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date;
@property (nonatomic) BOOL isSended;
@property (nonatomic) BOOL onOff;
@property (nullable, nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
