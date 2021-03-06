//
//  APIResult.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "APIResult.h"

@implementation APIResult
+ (instancetype)sharedClient {
    static APIResult *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIResult alloc] init];
    });
    return _sharedClient;
}

-(void)getUserInfo
{
    NSString *newId = [CCUserModel sharedUserModel].userId;
    NSDictionary *dic = @{@"id":newId?:@""};
    [[AFNetAPIClient sharedClient] requestUrl:GETUserInfo cParameters:dic success:^(NSDictionary * _Nonnull requset) {
        if ([[requset objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [requset objectForKey:@"data"];
            NSArray *userphoto = [NSArray new];
            userphoto = [data objectForKey:@"photos"];
            [[NSUserDefaults standardUserDefaults] setObject:userphoto forKey:@"userphoto"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            CCUserModel *model = [CCUserModel sharedUserModel];
            model.name = [data objectForKey:@"name"];
            model.sex = [data objectForKey:@"sex"];
            model.signature = [data objectForKey:@"signature"];
            model.age = [NSString stringWithFormat:@"%@",[data objectForKey:@"age"]];
            model.userphotos = userphoto;
            NSLog(@"name----%@",model.name);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


-(void)replyImgfrom:(UIImage *)img
{
    [CCLoadingHUD show];
    NSInteger num = [[CCUserModel sharedUserModel].userId integerValue];
    NSNumber * nums = @(num);
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@(1)];
    NSDictionary *newdic = @{@"id":nums,@"photoid":arr};
    NSString *defaultApi = [ServerIP stringByAppendingString:UPLoadphoto];
    NSDictionary *para = @{@"data":newdic};
    NSDictionary *dic = [XYNetworkTools handleParameter:para];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[CCUserModel sharedUserModel].token ? [CCUserModel sharedUserModel].token:@""] forHTTPHeaderField:@"Authorization"];
    
    [manager POST:defaultApi parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = img;
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData
                                    name:@"photo"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 需要先转十六进制的data
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [XYNetworkTools stringToHexData:responseString];
        // 解密需要时Base64的字符串
        NSString *base64Str = [data base64EncodedStringWithOptions:0];
        // 使用秘钥进行解密,得到的是结果字符串
        NSString *resultStr = [base64Str xy_blowFishDecodingWithKey:xy_BlowFishKey];
        // 解密完成后转成Data以便之后进行序列化
        NSData *data_dec = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        if (data_dec) {
            NSError* serializeError;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data_dec options:0 error:&serializeError];
            NSLog(@"%@",responseDict)
            if (!serializeError) {
                NSLog(@"序列化成功");
                if ([[responseDict objectForKey:@"code"] intValue]==1) {
                    //[SVProgressHUD showInfoWithStatus:@"Success!"];
                    [self newgetUserInfo];
                }
            }else{
                NSLog(@"序列化失败");
            }
        }else{
            NSError* error_dec = [NSError errorWithDomain:NSCocoaErrorDomain code:-999 userInfo:@{@"reason":@"Decrypt Failed"}];
            NSLog(@"ERROR-----%@",error_dec);
            NSLog(@"解密失败")
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


-(void)newgetUserInfo
{
    NSString *newId = [CCUserModel sharedUserModel].userId;
    NSDictionary *dic = @{@"id":newId?:@""};
    [[AFNetAPIClient sharedClient] requestUrl:GETUserInfo cParameters:dic success:^(NSDictionary * _Nonnull requset) {
        if ([[requset objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [requset objectForKey:@"data"];
            NSArray *userphoto = [NSArray new];
            userphoto = [data objectForKey:@"photos"];
            [[NSUserDefaults standardUserDefaults] setObject:userphoto forKey:@"userphoto"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [SVProgressHUD showInfoWithStatus:@"Success!"];
            [CCLoadingHUD dismiss];
        }
        [CCLoadingHUD dismiss];
    } failure:^(NSError * _Nonnull error) {
        [CCLoadingHUD dismiss];
    }];
}

@end
