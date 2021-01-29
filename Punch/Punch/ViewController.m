//
//  ViewController.m
//  Punch
//
//  Created by 夏忠胜 on 2021/1/28.
//  Copyright © 2021 MrXia. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // Do any additional setup after loading the view.
}


- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.backgroundColor = UIColor.lightGrayColor;
    [_button setTitle:@"打卡" forState:UIControlStateNormal];
    [_button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
    }];
}

- (void)buttonClicked:(UIButton *)sender {
    [self request];
}

- (void)requestPunch {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
    
    [manager.requestSerializer setValue:@"v3.9.0" forHTTPHeaderField:@"X-HRX-Version"];
    [manager.requestSerializer setValue:@"HRX" forHTTPHeaderField:@"X-AUTH-CHANNEL"];
    [manager.requestSerializer setValue:@"6fcaf97fdd42a9e8f8cd7d65055e89d7" forHTTPHeaderField:@"X-HRX-Emplid"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"X-HRX-App-Type"];
    [manager.requestSerializer setValue:@"hrxapp" forHTTPHeaderField:@"X-APP-TYPE"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"X-HRX-User-Type"];
    [manager.requestSerializer setValue:[self session] forHTTPHeaderField:@"X-HRX-SESSION"];
//    [manager.requestSerializer setValue:[self cookie] forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    
    
    NSString *url=@"https://z.pa18.com/mobile-abs/absPunchRecordT/addpunchrecordV3.do";
    NSDictionary *parameters=@{@"absPunchRecordTDTO": [self record],
                               @"absPunchRecordLogTDTO": [self recordLog]};

    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"responseObject-->%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"error-->%@",error);
    }];
    

}

- (void)request {
    NSString *url = @"https://z.pa18.com/mobile-abs/absPunchRecordT/addpunchrecordV3.do";
    NSDictionary *parameters=@{@"absPunchRecordTDTO": [self record],
                               @"absPunchRecordLogTDTO": [self recordLog]};
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:30.f];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setValue:@"v3.9.0" forHTTPHeaderField:@"X-HRX-Version"];
    [request setValue:@"HRX" forHTTPHeaderField:@"X-AUTH-CHANNEL"];
    [request setValue:@"6fcaf97fdd42a9e8f8cd7d65055e89d7" forHTTPHeaderField:@"X-HRX-Emplid"];
    [request setValue:@"iOS" forHTTPHeaderField:@"X-HRX-App-Type"];
    [request setValue:@"hrxapp" forHTTPHeaderField:@"X-APP-TYPE"];
    [request setValue:@"1" forHTTPHeaderField:@"X-HRX-User-Type"];
    [request setValue:[self session] forHTTPHeaderField:@"X-HRX-SESSION"];
//    [manager.requestSerializer setValue:[self cookie] forHTTPHeaderField:@"Cookie"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            NSError *err;
            id responseObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            NSLog(@"responseObj: %@", responseObj);
        }
        
    }];
    
    [task resume];
}


- (NSDictionary *)record {
    return @{@"source": @"HRX",
             @"equipmentId": @"iPhone XS Max__hcf2fbfe65f4dbc9e56b9e9096dbf6aa4",
             @"longitude": @"dCkeuBY7GIF5R8OAvmdFCg==",
             @"latitude": @"aU9eS//mNHyoHclBiRxzaQ==",
             @"equipmentIdData": @"8839b5e8b4f005c73725758f7fcd0b2d",
             @"employeeId": @"ZHOUCHENCHEN352",
             @"secretData": @"438f1f723680720c1ccaf614664a3945",
             @"encryptCode": @"02",
             @"punchAddress": @""
    };
}

- (NSDictionary *)recordLog {
    return @{@"device": @"iPhone XS Max",
             @"altitude": @"0.00",
             @"fourG": @"3",
             @"city": @"",
             @"osVersion": @"14.2",
             @"punchAddressTencent": @"广东省深圳市龙华区民康路1号",
             @"latitudeTencent": @"PPQVgy7KsMqygBnVW95Saw==",
             @"longitudeTencent": @"dCkeuBY7GIF5R8OAvmdFCg==",
             @"gps": @"2",
             @"networkType": @"WIFI",
             @"satellitesNumber": @"0"
    };
}

- (NSString *)session {
    return @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6ImFwcF9wYV9ocm1fMTAwMDA1IiwidHlwZSI6IjEiLCJleHAiOjE2MTE5MzM0MTcsImlhdCI6MTYxMTg0MzQxNywic2lkIjoiUzJiOTg3MWZmNzcyNGRjODQwMTc3NDk1YWI0Zjg3MzhiMCJ9.GLqqyeLrk0x43FjTrxuvG-NZiTzm-nitPNhP7Td7UYU";
}

- (NSString *)cookie {
    return @"BIGipServerPOOL_PACLOUD_PRDR2016121405289=502405548.29814.0000;route=901a1075b7e3b52eaf33380fd3c98303";
}

@end
