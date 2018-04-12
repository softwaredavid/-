//
//  NetObject.h
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/3.
//  Copyright © 2017年 EdisonDu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetObject : NSObject<NSURLSessionDelegate>
- (void)postUserName:(NSString *)userName password:(NSString *)passWorld success:(void(^)(void))success error:(void(^)(void))error;
- (NSURL *)configUrlCookie:(NSURL *)url;
@end
