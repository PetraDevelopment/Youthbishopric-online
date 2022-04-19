//
//  NotesWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 7/9/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NotesWsDelegate;

@interface NotesWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableArray *notesMessages;
}

@property (nonatomic, retain) id <NotesWsDelegate> notesWsDelegate;

- (void)getNotesMessages;

@end

@protocol NotesWsDelegate <NSObject>
@optional
- (void)notesWebService:(NotesWebService *)notesWebService errorMessage:(NSString *)errorMsg;
- (void)notesWebService:(NotesWebService *)notesWebService returnMessages:(NSMutableArray *)returnMsgs;

@end


