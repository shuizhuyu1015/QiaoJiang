//
//  NetworkHelper.m
//  iappfree
//
//  Created by Honey on 15/9/29.
//  Copyright (c) 2015年 Honey. All rights reserved.
//

#import "NetworkHelper.h"
#import "AFNetworking.h"

@implementation NetworkHelper

+ (id)shareInstance //获取网络请求单例
{
    static NetworkHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (helper == nil)
        {
            helper = [[NetworkHelper alloc] init];
        }
    });
    return helper;
}

- (void)Get:(NSString *)url
  parameter:(NSDictionary *)parameter
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    
    NSAssert(url != nil, @"URL 不能为空");
    
    //使用AFN请求网络
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //看服务器返回的数据是不是application/json格式的数据
    //如果不是,需要以NSData的方式接收,然后自行解析
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //通过block 将数据回传给用户
        NSLog(@"url = %@ \n response = %@", url, responseObject);
        if (success)
        {
            success(responseObject/*json的解析完成后,数据的操作交由用户自行决定*/);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //通过block,将错误信息回传给用户
        if (failure)
        {
            failure(error);
        }
        
    }];
}

- (void)Post:(NSString *)url parameter:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    

    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)Post:(NSString *)url parameter:(NSDictionary *)parameter data:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];
}

@end






