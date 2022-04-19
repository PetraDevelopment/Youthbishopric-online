//
//  Esma3WebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 10/28/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Esma3WsDelegate;

@interface Esma3WebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *esma3Messages;
}

@property (nonatomic, retain) id <Esma3WsDelegate> esma3WsDelegate;

- (void)getEsma3MessagesForPresentAndFuture:(BOOL)isPresent;

@end

@protocol Esma3WsDelegate <NSObject>
@optional
- (void)esma3WebService:(Esma3WebService *)esma3WebService errorMessage:(NSString *)errorMsg;
- (void)esma3WebService:(Esma3WebService *)esma3WebService returnMessages:(NSMutableArray *)returnMsgs;

@end


