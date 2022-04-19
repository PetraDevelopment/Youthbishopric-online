//
//  E3rafWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/4/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol E3rafWsDelegate;

@interface E3rafWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *e3rafMessages;
}

@property (nonatomic, retain) id <E3rafWsDelegate> e3rafWsDelegate;

- (void)getE3rafMessagesForPresentAndFuture:(BOOL)isPresent;

@end

@protocol E3rafWsDelegate <NSObject>
@optional
- (void)e3rafWebService:(E3rafWebService *)e3rafWebService errorMessage:(NSString *)errorMsg;
- (void)e3rafWebService:(E3rafWebService *)e3rafWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


