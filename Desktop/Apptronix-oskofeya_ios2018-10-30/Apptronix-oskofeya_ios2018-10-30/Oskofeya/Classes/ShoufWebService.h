//
//  ShoufWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 10/29/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShoufWsDelegate;

@interface ShoufWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *shoufMessages;
}

@property (nonatomic, retain) id <ShoufWsDelegate> shoufWsDelegate;

- (void)getShoufMessagesForPresentAndFuture:(BOOL)isPresent;

@end

@protocol ShoufWsDelegate <NSObject>
@optional
- (void)shoufWebService:(ShoufWebService *)shoufWebService errorMessage:(NSString *)errorMsg;
- (void)shoufWebService:(ShoufWebService *)shoufWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


