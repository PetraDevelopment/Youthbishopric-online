//
//  EttamenWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/13/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EttamenWebServiceDelegate;

@interface EttamenWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *ettamenMessages;
}

@property (nonatomic, retain) id <EttamenWebServiceDelegate> ettamenWebServiceDelegate;

- (void)getEttamenMessages;

@end

@protocol EttamenWebServiceDelegate <NSObject>
@optional
- (void)ettamenWebService:(EttamenWebService *)ettamenWebService errorMessage:(NSString *)errorMsg;
- (void)ettamenWebService:(EttamenWebService *)ettamenWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


