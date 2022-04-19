//
//  PushTokenWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 3/1/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PushTokenWsDelegate;

@interface PushTokenWebService : NSObject {
    NSMutableData *receivedData;
    NSDictionary *returnMsg;
}

@property (nonatomic, retain) id <PushTokenWsDelegate> pushTokenWsDelegate;

- (void)updateDevicePushTokenWithToken:(NSString *)authToken andPushToken:(NSString *)devicePushToken;

@end

@protocol PushTokenWsDelegate <NSObject>
@optional
- (void)pushTokenWebService:(PushTokenWebService *)pushTokenWebService errorMessage:(NSString *)errorMsg;
- (void)pushTokenWebService:(PushTokenWebService *)pushTokenWebService returnMessage:(NSDictionary *)returnMsg;

@end


