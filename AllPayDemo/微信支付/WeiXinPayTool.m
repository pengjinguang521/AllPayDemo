//
//  WeiXinPayTool.m
//  AllPayDemo
//
//  Created by JGPeng on 16/10/24.
//  Copyright © 2016年 彭金光. All rights reserved.
//

#import "WeiXinPayTool.h"
#import "WXApi.h"
#import "payRequsestHandler.h"


@interface WeiXinPayTool ()<WXApiDelegate>

@property (nonatomic,copy)WeiXinPaySuccess success;
@property (nonatomic,copy)WeiXinPayFailed  failed;

@end


@implementation WeiXinPayTool


#pragma mark - 下面代码写在appDelegate中
/**
 *  单类方法
 */
+ (instancetype)shareTool{

    static WeiXinPayTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[WeiXinPayTool alloc]init];
    });
    return _tool;
}

/**
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 写在application:(UIApplication *)application didFinishLaun                   ｜
 chingWithOptions:(NSDictionary *)launchOptions 方法                          ｜
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 */
+ (void)RegistApp{

    [WXApi registerApp:APP_ID];
}

/**
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 写在application:(UIApplication *)application handleOpenURL:(NSURL *)url       ｜
 application:(UIApplication *)app openURL:(NSURL *)url options: 方法           ｜
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 */
- (BOOL)handleOpenURL:(NSURL *)url{

    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - 下面是掉起支付的核心代码，在需要掉起支付的页面使用

/**
 *  掉起微信支付的方法 本地掉起二次签名等
 *
 *  @param goodsName   支付现实的名称
 *  @param orderId     订单id
 *  @param goodPrice   商品价格
 *  @param success     成功回调
 *  @param failed      失败回调
 */
- (void)PayWithGoodname:(NSString *)goodsName
                OrderId:(NSString *)orderId
              GoodPrice:(NSString *)goodPrice
       WeiXinPaySuccess:(WeiXinPaySuccess)success
        WeiXinPayFailed:(WeiXinPayFailed)failed{
    
    self.success                   = success;
    self.failed                    = failed;
    //创建支付签名对象
    payRequsestHandler *req        = [[payRequsestHandler alloc]init];
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary * programs = [req sendPay_demoWith:goodsName withOrderId:orderId withPrise:@"1"];
    if(programs) {
        PayReq* req                = [[PayReq alloc] init];
        req.openID                 = [programs objectForKey:@"appid"];
        req.partnerId              = [programs objectForKey:@"partnerid"];
        req.prepayId               = [programs objectForKey:@"prepayid"];
        req.nonceStr               = [programs objectForKey:@"noncestr"];
        req.timeStamp              = [programs[@"timestamp"] intValue];
        req.package                = [programs objectForKey:@"package"];
        req.sign                   = [programs objectForKey:@"sign"];
        if (![WXApi isWXAppInstalled]) {
            self.failed(ErrorCodeWXAppNotInstalled);
        }
        [WXApi sendReq:req];
    }
}


/**
 *  后台传参数掉起微信支付
 *
 *  @param programs 后台返回的字典
 *  @param success  成功回调
 *  @param failed   失败回调
 */
- (void)PayWithPrograms:(NSDictionary *)programs
       WeiXinPaySuccess:(WeiXinPaySuccess)success
        WeiXinPayFailed:(WeiXinPayFailed)failed{

    self.success           = success;
    self.failed            = failed;
    NSMutableString *stamp = [programs objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req            = [[PayReq alloc] init];
    req.partnerId          = [programs objectForKey:@"partnerid"];
    req.prepayId           = [programs objectForKey:@"prepayid"];
    req.nonceStr           = [programs objectForKey:@"noncestr"];
    req.timeStamp          = [stamp intValue];
    req.package            = [programs objectForKey:@"package"];
    req.sign               = [programs objectForKey:@"sign"];

    if (![WXApi isWXAppInstalled]) {
        self.failed(ErrorCodeWXAppNotInstalled);
    }
    [WXApi sendReq:req];

}

/**
 *  微信支付结果回调的方法
 *
 *  @param resp
 */
- (void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:{
                if (self.success) {
                    self.success();
                }
            }
                break;
                
            case WXErrCodeCommon:{
                self.failed(ErrorCodeWxPayError);
            }
                break;
                
            case WXErrCodeUserCancel:{
                self.failed(ErrorCodeWxPayCancle);
            }
                break;
                
            default:
                break;
        }
    }
}


@end
