//
//  Es2alWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/4/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Es2alWsDelegate;

@interface Es2alWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *es2alMessages;
}

@property (nonatomic, retain) id <Es2alWsDelegate> es2alWsDelegate;

- (void)getEs2alMessagesForPresentAndFuture:(BOOL)isPresent;

@end

@protocol Es2alWsDelegate <NSObject>
@optional
- (void)es2alWebService:(Es2alWebService *)es2alWebService errorMessage:(NSString *)errorMsg;
- (void)es2alWebService:(Es2alWebService *)es2alWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


