//
//  Ma3refaWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 5/30/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Ma3refaWsDelegate;

@interface Ma3refaWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *ma3refaMessages;
}

@property (nonatomic, retain) id <Ma3refaWsDelegate> ma3refaWsDelegate;

- (void)getMa3refaMessagesForPresentAndFuture:(BOOL)isPresent;

@end

@protocol Ma3refaWsDelegate <NSObject>
@optional
- (void)ma3refaWebService:(Ma3refaWebService *)ma3refaWebService errorMessage:(NSString *)errorMsg;
- (void)ma3refaWebService:(Ma3refaWebService *)ma3refaWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


