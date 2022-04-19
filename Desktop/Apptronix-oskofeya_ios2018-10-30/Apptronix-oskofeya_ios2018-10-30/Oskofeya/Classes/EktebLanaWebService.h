//
//  EktebLanaWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 7/3/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EktebLanaWsDelegate;

@interface EktebLanaWebService : NSObject {
    NSMutableData *receivedData;
    NSDictionary *returnMsg;
}

@property (nonatomic, retain) id <EktebLanaWsDelegate> ektebLanaWsDelegate;

- (void)postQuestionWithTitle:(NSString *)title andBody:(NSString *)body;

@end

@protocol EktebLanaWsDelegate <NSObject>
@optional
- (void)ektebLanaWebService:(EktebLanaWebService *)ektebLanaWebService errorMessage:(NSString *)errorMsg;
- (void)ektebLanaWebService:(EktebLanaWebService *)ektebLanaWebService returnMessage:(NSDictionary *)returnMsg;

@end


