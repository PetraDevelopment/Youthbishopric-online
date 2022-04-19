//
//  ForgotPassWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 10/4/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ForgotPassWebServiceDelegate;

@interface ForgotPassWebService : NSObject {
    NSMutableData *receivedData;
    NSDictionary *returnMsg;
}

@property (nonatomic, retain) id <ForgotPassWebServiceDelegate> forgotPassWebServiceDelegate;

- (void)sendForgotPasswordForEmail:(NSString *)email;

@end

@protocol ForgotPassWebServiceDelegate <NSObject>
@optional
- (void)forgotPassWebService:(ForgotPassWebService *)forgotPassWebService errorMessage:(NSString *)errorMsg;
- (void)forgotPassWebService:(ForgotPassWebService *)forgotPassWebService returnMessage:(NSDictionary *)returnMsg;

@end


