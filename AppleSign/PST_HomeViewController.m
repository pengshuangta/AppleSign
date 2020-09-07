//
//  PST_HomeViewController.m
//  AppleSign
//
//  Created by 彭双塔 on 2020/9/7.
//  Copyright © 2020 pst. All rights reserved.
//

#import "PST_HomeViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "LQAppleLogin.h"
@interface PST_HomeViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation PST_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Sign in with Apple";
    
    if (@available(iOS 13.0, *)) {
        // 创建苹果id按钮
        ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:(ASAuthorizationAppleIDButtonTypeSignIn) style:(ASAuthorizationAppleIDButtonStyleWhite)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        button.frame = CGRectMake(0, 0, 60, 60);
        button.center = self.view.center;
        button.layer.cornerRadius = 30;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 1.0;
        button.layer.masksToBounds = YES;
        [self.view addSubview:button];
        
        // 自定义的按钮
        /*
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 60, 60);
        btn.center = self.view.center;
        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
         */
        
    } else {
        // Fallback on earlier versions
    }
    
}
#pragma mark - 自定义按钮，发起授权
-(void)btnClicked:(UIButton *)button{
    //主要作用是用创建相应的请求，查询用户授权状态
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest *req = [provider createRequest];
    //主要作用是用创建相应的请求，查询用户授权状态
    req.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    // 发送请求控制器，可以设置相应的协议
    ASAuthorizationController *controller = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[req]];
    // 接收请求成功或者失败的回调
    controller.delegate = self;
    // 用于返回弹出请求框的window，一般返回当前视图window即可
    controller.presentationContextProvider = self;
    [controller performRequests];
}
#pragma mark - 点击appid 发起授权
-(void)buttonAction:(ASAuthorizationAppleIDButton *)button{
    //主要作用是用创建相应的请求，查询用户授权状态
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest *req = [provider createRequest];
    //主要作用是用创建相应的请求，查询用户授权状态
    req.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    // 发送请求控制器，可以设置相应的协议
    ASAuthorizationController *controller = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[req]];
    // 接收请求成功或者失败的回调
    controller.delegate = self;
    // 用于返回弹出请求框的window，一般返回当前视图window即可
    controller.presentationContextProvider = self;
    [controller performRequests];
}
#pragma mark - ASAuthorizationControllerDelegate
#pragma mark - 成功的回调
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization{
    NSLog(@"成功回调");
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            ASAuthorizationAppleIDCredential *credential = authorization.credential;
        // 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的,开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来
            NSString *user = credential.user;
            NSString *familyName = credential.fullName.familyName;
            NSString * givenName = credential.fullName.givenName;
            NSString *email = credential.email;
        // 获取验证信息
        // 验证数据，用于传给开发者后台服务器，
        // 然后开发者服务器再向苹果的身份验证服务端验证本次授权登录请求数据的有效性和真实性，
        // 如果验证成功，可以根据 userIdentifier 判断账号是否已存在，
        // 若存在，则返回自己账号系统的登录态，若不存在，则创建一个新的账号，并返回对应的登录态给 App。
            NSData *identityToken = credential.identityToken;
            NSData *code = credential.authorizationCode;
            
        } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
            // 使用现有的密码凭证登录
            ASPasswordCredential *credential = authorization.credential;
            
            // 用户唯一标识符
            NSString *user = credential.user;
            NSString *password = credential.password;
            
        }
}
#pragma mark - 失败的回调
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error{
    NSLog(@"失败回调");
    
    NSString *msg = @"未知";
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            msg = @"用户取消";
            break;
        case ASAuthorizationErrorFailed:
            msg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            msg = @"授权请求无响应";
            break;
        case ASAuthorizationErrorNotHandled:
            msg = @"授权请求未处理";
            break;
        case ASAuthorizationErrorUnknown:
            msg = @"授权失败，原因未知";
            break;
            
        default:
            break;
    }
}
#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller{
    return [UIApplication sharedApplication].windows.firstObject;
}

@end
