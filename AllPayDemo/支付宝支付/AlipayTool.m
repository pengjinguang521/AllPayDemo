//
//  AlipayTool.m
//  AllPayDemo
//
//  Created by JGPeng on 16/10/24.
//  Copyright © 2016年 彭金光. All rights reserved.
//

#import "AlipayTool.h"
#import "Order.h"
#import "DataSigner.h"

@implementation AlipayTool

/**
 *  单类方法
 */
+ (instancetype)shareTool{
    
    static AlipayTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[AlipayTool alloc]init];
    });
    return _tool;
}

#pragma mark - 调起支付宝支付
/**
 *  掉起支付宝支付
 *
 *  @param orderSn          订单号
 *  @param orderName        订单名称
 *  @param orderDescription 订单描述
 *  @param OrderPrice       订单价格 //于微信不同的是 0.01是1分
 *  @param success          成功回调
 *  @param Failed           失败回调
 */
+ (void)sendAlipayWithOrderSn:(NSString *)orderSn
                    orderName:(NSString *)orderName
             orderDescription:(NSString *)orderDescription
                   orderPrice:(NSString *)OrderPrice
                 SuccessBlock:(AliPaySuccess)success
                  FailedBlock:(AliPayFailed)Failed{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */

    NSString *partner        = PARTNER;
    NSString *seller         = SELLER;
    NSString *privateKey     = RSA_ALIPAY_PRIVATE;
    //生成商品订单信息
    Order *order             = [[Order alloc] init];
    order.partner            = partner;
    order.seller             = seller;

    order.tradeNO            = orderSn;//订单ID（由商家自行制定）
    order.productName        = orderName;//商品标题
    order.productDescription = orderDescription;//商品描述
    order.amount             = [NSString stringWithFormat:@"%.2f",[OrderPrice floatValue]];//商品价格
    order.notifyURL          = NOTIFY_URL;//回调URL
    order.service            = @"mobile.securitypay.pay";
    order.paymentType        = @"1";
    order.inputCharset       = @"utf-8";
    order.itBPay             = @"30m";
    order.showUrl            = @"m.alipay.com";

    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme      = AppScheme;

    //将商品信息拼接成字符串
    NSString *orderSpec      = [order description];
    NSLog(@"orderSpec        = %@",orderSpec);

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer    = CreateRSADataSigner(privateKey);
    NSString *signedString   = [signer signString:orderSpec];

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString    = nil;
    if (signedString != nil) {
    orderString              = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
    NSDictionary *aliDict    = resultDic;
            if ([aliDict[@"resultStatus"] isEqualToString:@"9000"]){
                if (success) {
                    success();
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"8000"]) {
                if (Failed) {
                    Failed(@"正在处理中，请稍候查看结果！");
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"4000"]) {
                 if (Failed) {
                Failed(@"订单支付失败！");
                 }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6001"]) {
                 if (Failed) {
                Failed(@"用户中途取消付款！");
                 }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6002"]) {
                 if (Failed) {
                Failed(@"网络连接出错！");
                 }
            }
        }];
    }
}

/**
 *  掉起支付宝支付
 *
 *  @param orderSn          订单号
 *  @param orderName        订单名称
 *  @param orderDescription 订单描述
 *  @param OrderPrice       订单价格 //于微信不同的是 0.01是1分
 *  @param success          成功回调
 *  @param Failed           失败回调
 */
+ (void)OutsideAlipayWithOrderSn:(NSString *)orderSn
                       orderName:(NSString *)orderName
                orderDescription:(NSString *)orderDescription
                      orderPrice:(NSString *)OrderPrice
                    SuccessBlock:(AliPaySuccess)success
                     FailedBlock:(AliPayFailed)Failed{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    NSString *privateKey     = RSA_ALIPAY_PRIVATE_International;
    NSString *partner        = PARTNER_International;
    NSString *seller         = SELLER_International;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order             = [[Order alloc] init];
    order.isInternet         = @"1";
    order.partner            = partner;
    order.seller             = seller;
    /** 境外分账信息 */
    order.splitFoundInfo     = [NSString stringWithFormat:@"[{\"transIn\":\"%@\",\"amount\":\"%.2f\",\"currency\":\"CNY\",\"desc\":\"分账\"}]",PARTNER,OrderPrice.floatValue];
    order.tradeNO            = orderSn;//订单ID（由商家自行制定）
    order.productName        = orderName;//商品标题
    order.productDescription = orderDescription;//商品描述
    order.amount             = [NSString stringWithFormat:@"%.2f",OrderPrice.floatValue];//商品价格
    //order.amount=@"0.01";
    order.notifyURL          = NOTIFY_URL;//回调URL
    order.product_code       = @"NEW_WAP_OVERSEAS_SELLER";
    order.service            = @"mobile.securitypay.pay";
    order.paymentType        = @"1";
    order.inputCharset       = @"utf-8";
    order.itBPay             = @"30m";
    order.showUrl            = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme      = AppScheme;
    //将商品信息拼接成字符串
    NSString *orderSpec      = [order description];
    NSLog(@"orderSpec        = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer    = CreateRSADataSigner(privateKey);
    NSString *signedString   = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString    = nil;
    if (signedString != nil)
    {
        orderString              = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                    orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSDictionary *aliDict    = resultDic;
            if ([aliDict[@"resultStatus"] isEqualToString:@"9000"]){
                if (success) {
                    success();
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"8000"]) {
                if (Failed) {
                    Failed(@"正在处理中，请稍候查看结果！");
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"4000"]) {
                if (Failed) {
                    Failed(@"订单支付失败！");
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6001"]) {
                if (Failed) {
                    Failed(@"用户中途取消付款！");
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6002"]) {
                if (Failed) {
                    Failed(@"网络连接出错！");
                }
            }
        }];
    }
}



@end
