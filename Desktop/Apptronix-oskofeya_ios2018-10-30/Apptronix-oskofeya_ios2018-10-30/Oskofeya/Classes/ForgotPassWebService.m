//
//  ForgotPassWebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 10/4/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import "ForgotPassWebService.h"

@implementation ForgotPassWebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize returnMsg
    returnMsg = [[NSDictionary alloc] init];
    return self;
}

- (void)sendForgotPasswordForEmail:(NSString *)email {
    NSString *stringData = [NSString stringWithFormat:@"{\"email\":\"%@\"}", email];
    NSData *jsonData = [stringData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://107.170.130.87/api/users/password"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://oskofeya.com/api/user/password"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
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
    [self.forgotPassWebServiceDelegate forgotPassWebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    NSError *myError = nil;
    returnMsg = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    [self.forgotPassWebServiceDelegate forgotPassWebService:self returnMessage:returnMsg];
}

@end


