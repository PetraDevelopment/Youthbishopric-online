//
//  MailBoxWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/9/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MailBoxWsDelegate;

@interface MailBoxWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *mailBoxMessages;
}

@property (nonatomic, retain) id <MailBoxWsDelegate> mailBoxWsDelegate;

- (void)getMailBoxMessages;

@end

@protocol MailBoxWsDelegate <NSObject>
@optional
- (void)mailBoxWebService:(MailBoxWebService *)mailBoxWebService errorMessage:(NSString *)errorMsg;
- (void)mailBoxWebService:(MailBoxWebService *)mailBoxWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


