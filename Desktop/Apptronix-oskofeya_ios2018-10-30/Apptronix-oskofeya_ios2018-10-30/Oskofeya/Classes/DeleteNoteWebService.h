//
//  DeleteNoteWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 7/22/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DeleteNoteWsDelegate;

@interface DeleteNoteWebService : NSObject {
    NSMutableData *receivedData;
    NSDictionary *returnMsg;
}

@property (nonatomic, retain) id <DeleteNoteWsDelegate> deleteNoteWsDelegate;

- (void)deleteNote:(NSString *)noteID;

@end

@protocol DeleteNoteWsDelegate <NSObject>
@optional
- (void)deleteNoteWebService:(DeleteNoteWebService *)deleteNoteWebService errorMessage:(NSString *)errorMsg;
- (void)deleteNoteWebService:(DeleteNoteWebService *)deleteNoteWebService returnMessage:(NSDictionary *)returnMsg;

@end


