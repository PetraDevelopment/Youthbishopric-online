//
//  NotesWebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 7/9/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import "NotesWebService.h"

@implementation NotesWebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize notesMessages
    notesMessages = [[NSMutableArray alloc] init];
    return self;
}

- (void)getNotesMessages {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/agpeya/api/user/notes?access_token=%@",[defaults objectForKey:@"authToken"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        receivedData = [NSMutableData data];
    } else {
        NSLog(@"NSURLConnection initWithRequest: Failed to return a connection.");
    }
}

#pragma mark - Connection Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"connection didFailWithError: %@ %@", error.localizedDescription, [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self.notesWsDelegate notesWebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    // NSArray *receivedMessages;
    NSError *myError = nil;
    notesMessages = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    /*
    for (NSDictionary *tempDict in receivedMessages) {
        NSMutableDictionary *tempMutableDict;
        tempMutableDict = [tempDict mutableCopy];
        [tempMutableDict setObject:@"unread" forKey:@"status"];
        [tempMutableDict setObject:@"visible" forKey:@"visibility"];
        [tempMutableDict setObject:@"local" forKey:@"user"];
        [mailBoxMessages addObject:tempMutableDict];
    }
    */
    // NSLog(@"notesMessages = %@",notesMessages);
    [self.notesWsDelegate notesWebService:self returnMessages:notesMessages];
}

@end


