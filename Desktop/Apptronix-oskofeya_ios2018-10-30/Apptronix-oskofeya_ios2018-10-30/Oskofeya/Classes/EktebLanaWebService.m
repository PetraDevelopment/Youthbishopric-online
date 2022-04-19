//
//  EktebLanaWebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 7/3/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import "EktebLanaWebService.h"

@implementation EktebLanaWebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize returnMsg
    returnMsg = [[NSDictionary alloc] init];
    return self;
}

- (void)postQuestionWithTitle:(NSString *)category andBody:(NSString *)title {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *stringData = [NSString stringWithFormat:@"{\"access_token\":\"%@\", \"title\":\"%@\", \"body\": \"\", \"category\": \"%@\"}", [defaults objectForKey:@"authToken"], title, category];
    NSData *jsonData = [stringData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.130.87/api/mail_boxes?access_token=%@",[defaults objectForKey:@"authToken"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/api/users_message_questions"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d",[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
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
    [self.ektebLanaWsDelegate ektebLanaWebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    NSError *myError = nil;
    returnMsg = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    [self.ektebLanaWsDelegate ektebLanaWebService:self returnMessage:returnMsg];
}

@end


