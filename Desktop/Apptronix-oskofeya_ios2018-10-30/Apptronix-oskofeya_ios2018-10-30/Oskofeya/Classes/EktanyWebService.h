//
//  EktanyWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 10/29/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EktanyWsDelegate;

@interface EktanyWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *ektanyMessages;
}

@property (nonatomic, retain) id <EktanyWsDelegate> ektanyWsDelegate;

- (void)getEktanyMessagesForPresentAndFuture:(BOOL)isPresent;

@end

@protocol EktanyWsDelegate <NSObject>
@optional
- (void)ektanyWebService:(EktanyWebService *)ektanyWebService errorMessage:(NSString *)errorMsg;
- (void)ektanyWebService:(EktanyWebService *)ektanyWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


