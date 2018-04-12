//
//  NetObject.m
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/3.
//  Copyright © 2017年 EdisonDu. All rights reserved.
//
#import "NetObject.h"
#import <AFNetworking/AFNetworking.h>
#import "GrainDepot-Swift.h"
/// 192.168.6.253:8888 x1Y2I3ng
static NSString *login = @"http://218.13.18.18:8000/grm/j_spring_security_check";

@implementation NetObject
- (void)postUserName:(NSString *)userName password:(NSString *)passWorld success:(void(^)(void))success error:(void(^)(void))err  {
    NSString *bundleIdUrlString = [NSString stringWithFormat:@"%@?username=%@&password=%@",login,userName,passWorld];
    NSURL *requestURL = [NSURL URLWithString:bundleIdUrlString];
    //可变的对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    //(1)设置请求方式
    [request setHTTPMethod:@"POST"];
    [request setValue:@"content-type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    //(2)超时时间
    [request setTimeoutInterval:120];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSession *sess = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    
    NSURLSessionDataTask *task = [sess dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
        
        NSDictionary *dic = httpResponse.allHeaderFields;
        NSString * cookie = [dic objectForKey:@"Set-Cookie"];
        [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:@"appCookie"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString *url = dic[@"Location"];
        if ([url containsString:@"/grm/page/index.html"]) {
            success();
        } else {
            err();
        }
    }];
    [task resume];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler{
    
    completionHandler(nil);
    
}
@end
