//
//  EngylakWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/4/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EngylakWsDelegate;

@interface EngylakWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *engylakMessages;
}

@property (nonatomic, retain) id <EngylakWsDelegate> engylakWsDelegate;

- (void)getEngylakMessagesForPresentAndFuture:(BOOL)isPresent;

@end

@protocol EngylakWsDelegate <NSObject>
@optional
- (void)engylakWebService:(EngylakWebService *)engylakWebService errorMessage:(NSString *)errorMsg;
- (void)engylakWebService:(EngylakWebService *)engylakWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


