//
//  Esma3WebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 10/28/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import "Esma3WebService.h"

@implementation Esma3WebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize esma3Messages
    esma3Messages = [[NSMutableArray alloc] init];
    return self;
}

- (void)getEsma3MessagesForPresentAndFuture:(BOOL)isPresent {
    int apiFilter = (isPresent ? 1 : 2);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.130.87/api/listens?access_token=%@",[defaults objectForKey:@"authToken"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/api/listens?access_token=%@&filter=%d",[defaults objectForKey:@"authToken"], apiFilter]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
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
    [self.esma3WsDelegate esma3WebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    NSError *myError = nil;
    esma3Messages = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    // NSLog(@"esma3Messages = %@",esma3Messages);
    [self.esma3WsDelegate esma3WebService:self returnMessages:esma3Messages];
}

@end


