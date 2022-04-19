//
//  KenystakWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/4/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KenystakWsDelegate;

@interface KenystakWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *kenystakMessages;
}

@property (nonatomic, retain) id <KenystakWsDelegate> kenystakWsDelegate;

- (void)getKenystakMessagesForPresentAndFuture:(BOOL)isPresent;

@end

@protocol KenystakWsDelegate <NSObject>
@optional
- (void)kenystakWebService:(KenystakWebService *)kenystakWebService errorMessage:(NSString *)errorMsg;
- (void)kenystakWebService:(KenystakWebService *)kenystakWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


