//
//  AlipayTool.h
//  AllPayDemo
//
//  Created by JGPeng on 16/10/24.
//  Copyright © 2016年 彭金光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

#pragma mark - 支付宝支付的配置信息，也是主要修改的地方

/*====================================================================*/
/*=======================需要商户app申请的境内===========================*/
/*====================================================================*/

//商户ID
#define PARTNER @"208802182832"
//账号ID
#define SELLER @"cs@.com"
//私钥
#define RSA_ALIPAY_PRIVATE @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAOPrCXVVALT8fV5RtJxM433FBhKQxbrbvXdw7Dhsy6piA0ncZezwbV3N1lu+hpVa6h+aqPeKCl9WEmizOtmmkIC22Cl8bkMDxse4Wgmo+8bL65AvJc+lJ9d41JP23HUgtKM+JMHpGvev4KyKVCbgEGRseLFO5M/11N9O9sIbZrbrAgMBAZeSqsZrmLXrYhWtiqUREcaywTXm1IaKqiJQHQRJccz1jI9xttsCQQCjiWeroaG0ju9J0VF4X+Am6qOL64BtgkjpuNerBuD5TfBE2zE64E8bjmUlngcaG4xkDHGW7gePrKV7GbT8dRli"
//公钥
#define RSA_ALIPAY_PUBLIC @"MIGfMA0GCSqGSIb3DQEBAVWuofmqj3igpfVhJoszrZppCAttgpfG5DA8bHuFoJqPvGy+uQLyXPpSfXeNST9tx1ILSjPiTB6Rr3r+CsilQm4BBkbHixTuTP9dTfTvbCG2a26wIDAQAB"
//支付结果回调页面
#define NOTIFY_URL        @"http://101.230.8.68:8082/sgsb/servlet/doWxPayNotify"
//支付宝的appScheme
#define AppScheme         @"YH.CFSH"

/*====================================================================*/
/*=======================需要商户app申请的国际===========================*/
/*====================================================================*/

//商户ID
#define PARTNER_International    @"208125254"
//账号ID
#define SELLER_International     @"99bl@ily.com"
//私钥
#define RSA_ALIPAY_PRIVATE_International @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAK1UFKLf3A//sHf2tignGKhc6a830srwN6gWHarVYM18x/f9UifajxYSjpeyG8glpTK4nCejMRsJx2U/S7gcsi3kuRTqjW8FOtjsijDdnR6MJPNs+3gdo4BqmnKpn3YjMoZwUMzVwh6KiNOT+xdZRmRmiA25865nO2fPqv83UKZ5AgMBAAECgYBLU9lMF8IJ6fOFj2EG/kbHFOoyTi58J/3oPQRTtDxH0c0OR7emvmELrm44IYk84hA4VeAI6a9dISQJBANQ1LSjUj7Ls0AySKk01mleHnkkIWoVxmKNkLKFwHvPloJGernNzpJK2udqvtC1oqeWW4Lp6+2NI29LlsdjbTPgtbUpa+7tQZyp5XSznidA5itt/49BmTAkAZih/xRxjy8dKfcbVCwxQYEM6x+Dps6xQXrg+wAam45zt3M8MA1I2/33zrFIOwMt8T+hJptneIQxfAhQirOV4C"
//公钥
#define RSA_ALIPAY_PUBLIC_International @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDj6wl1VQC0/H1eUbScTON9xQYSkMW62713cOw4bMuqYgNJ3GXs8G1dzdZbvoaVWuofmqj3igpfVhJoszrZppCAttgpfG5DA8bHuFoJqPvGy+uQLyXPpSfXeNST9tx1ILSjPiTB6Rr3r+CsilQm4BBkbHixTuTP9dTfTvbCG2a26wIDAQAB"

/**
 *  支付宝支付成功回调
 */
typedef void (^AliPaySuccess)();

/**
 *  支付宝支付失败回调
 *
 *  @param desc 失败描述
 */
typedef void (^AliPayFailed)(NSString * desc);

@interface AlipayTool : NSObject

/**************************** 支付宝支付  ******************************/

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
                  FailedBlock:(AliPayFailed)Failed;

/**************************** 国际化支付  ******************************/

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
                     FailedBlock:(AliPayFailed)Failed;


@end
