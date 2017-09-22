//
//  AppDelegate.m
//  键盘测试
//
//  Created by Gopay_y on 20/07/2017.
//  Copyright © 2017 Gopay_y. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import <AVFoundation/AVFoundation.h>
#import <iflyMSC/iflyMSC.h>
#import "pcmToWav.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate,IFlySpeechSynthesizerDelegate>
{
    void(^_notiCompletionHandler)(UNNotificationPresentationOptions options);
}

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    
    [self setUpNoti:application];
    
    // test voice
    
    [self initIFlyVoice];

    return YES;
}

-(void)initIFlyVoice {
    
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    NSString *soundPath = [NSString stringWithFormat:@"%@%@",libPath,@"/Sounds"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:soundPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:soundPath withIntermediateDirectories:YES attributes:nil error:nil];
    };
    
    [IFlySetting setLogFilePath:soundPath];
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5992b279"];
    [IFlySpeechUtility createUtility:initString];

}

-(void)setUpNoti:(UIApplication *)application {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
    
}

// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    
//    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:request.content.body];
//    utterance.voice = _voice;
//    utterance.rate = 0.5;
//    [_synthesizer speakUtterance:utterance];
    _notiCompletionHandler = completionHandler;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    NSString *soundPath = [NSString stringWithFormat:@"%@%@%@",libPath,@"/Sounds/",@"localVoice1.pcm"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:soundPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:soundPath error:nil];
    }
    
    [self synthetizeNotiSounds:request.content.body];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler{

    NSLog(@"didReceiveRemoteNotification userInfo = %@",userInfo);
    
}


// 获得Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
}
// 获得Device Token失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

/*** 科大讯飞 语音合成方法 ***/

-(void)synthetizeNotiSounds:(NSString *)text {
    
    NSLog(@"synthetizeNotiSounds = %@",text);
    
    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"80"forKey: [IFlySpeechConstant VOLUME]];
    
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@"xiaoyan"forKey: [IFlySpeechConstant VOICE_NAME]];
    
    // 设置采样率
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant SAMPLE_RATE_8K] forKey: [IFlySpeechConstant SAMPLE_RATE]];
    
    //保存合成文件名，如不再需要，设置为 nil 或者为空表示取消，默认目录位于 library/cache下
//    [_iFlySpeechSynthesizer setParameter:@"hechengVoice_02.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
    //    [_iFlySpeechSynthesizer startSpeaking: @"播放并合成"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    NSString *soundPath = [NSString stringWithFormat:@"%@%@%@",libPath,@"/Sounds/",@"localVoice1.pcm"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:soundPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:soundPath error:nil];
    }
    
    // 开始合成(不播放) 不能和播放并合成同时调用。。。
    [_iFlySpeechSynthesizer synthesize:text toUri:soundPath];
    
}

/***  IFlySpeechSynthesizerDelegate  ***/
//合成结束
- (void) onCompleted:(IFlySpeechError *) error {
    
    NSLog(@"Appdelegate: 合成完毕 -------- onCompleted errorCode = %d",error.errorCode);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    NSString *soundPath = [NSString stringWithFormat:@"%@%@%@",libPath,@"/Sounds/",@"localVoice1.pcm"];
    NSString *wavPath = [NSString stringWithFormat:@"%@%@%@",libPath,@"/Sounds/",@"localVoice1.wav"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:wavPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:wavPath error:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:wavPath contents:nil attributes:nil];
    }
    
    convertPcm2Wav(soundPath.UTF8String, wavPath.UTF8String, 1, 8000);
    
    _notiCompletionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//合成开始
- (void) onSpeakBegin {
    
    NSLog(@"合成开始 -------- onSpeakBegin");
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {} //合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
