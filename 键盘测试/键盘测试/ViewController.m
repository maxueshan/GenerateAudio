//
//  ViewController.m
//  键盘测试
//
//  Created by Gopay_y on 20/07/2017.
//  Copyright © 2017 Gopay_y. All rights reserved.
//

#import "ViewController.h"
#import "keyBoardVC.h"
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import "iflyMSC/IFlyMSC.h"
#import "pcmToWav.h"

@interface ViewController () <UIAlertViewDelegate,IFlySpeechSynthesizerDelegate>
{
    UITextField *_tf;
}

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(50, 120, 300, 50)];
    _tf.backgroundColor = [UIColor orangeColor];
    _tf.textColor = [UIColor blackColor];
    _tf.borderStyle = UITextBorderStyleRoundedRect;
    _tf.placeholder = @"输入要发送的通知内容";
    _tf.text = [NSString stringWithFormat:@"国付宝收款%.2f元",arc4random()%100 + (float)(arc4random()%100)/100];
    [self.view addSubview:_tf];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitle:@"10S后发送本地通知" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 250, 150, 50);
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 setTitle:@"播放本地语音" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(100, 350, 150, 50);
    [btn1 addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundColor:[UIColor redColor]];
    [btn2 setTitle:@"设置音频" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 450, 150, 50);
    [btn2 addTarget:self action:@selector(setupVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setBackgroundColor:[UIColor yellowColor]];
    [btn3 setTitle:@"AlertView" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(100, 550, 150, 50);
    [btn3 addTarget:self action:@selector(btnAction3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}

//MARK: 发送通知
-(void)btnAction:(UIButton *)btn {
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.body = _tf.text;
    
    content.sound = [UNNotificationSound soundNamed:@"6414.mp3"];
    
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10
                                                                                                    repeats:NO];
    NSString* requestIdentifer = @"Request";
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:requestIdentifer
                                                                          content:content
                                                                          trigger:trigger];
    
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                           withCompletionHandler:^(NSError * _Nullable error) {
                                                               NSLog(@"Error%@", error);
                                                           }];
    
 
    

}

// 播放本地音频
-(void)btnAction1:(UIButton *)btn {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    NSString *soundPath = [NSString stringWithFormat:@"%@%@%@",libPath,@"/Sounds/",@"localVoice1.pcm"];
    NSString *wavPath = [NSString stringWithFormat:@"%@%@%@",libPath,@"/Sounds/",@"localVoice1.wav"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:wavPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:wavPath error:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:wavPath contents:nil attributes:nil];
    }
    
//    NSURL *audioURL=[[NSBundle mainBundle] URLForResource:@"6414" withExtension:@"mp3"];
    
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:soundPath];

    convertPcm2Wav(soundPath.UTF8String, wavPath.UTF8String, 1, 8000);
    
    NSURL *audioURL = [NSURL fileURLWithPath:wavPath];
    SystemSoundID soundID = 0;
    //Creates a system sound object.
    OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(audioURL), &soundID);
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        NSLog(@"开启扬声器发生错误:%@",setCategoryError.localizedDescription);
    }

    if (status == noErr) {
        
        AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
            
        });
        
    }else{
        NSLog(@"播放本地音频失败 error = %d",status);
    }
    
    //Registers a callback function that is invoked when a specified system sound finishes playing.
//    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, &playCallback, (__bridge void * _Nullable)(self));
    //    AudioServicesPlayAlertSound(soundID);
    
}

-(void)setupVoice{
    
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
    [_iFlySpeechSynthesizer setParameter:@"hechengVoice_02.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
//    [_iFlySpeechSynthesizer startSpeaking: @"播放并合成"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    NSString *soundPath = [NSString stringWithFormat:@"%@%@%@",libPath,@"/Sounds/",@"localVoice1.pcm"];
    
    // 开始合成(不播放) 不能喝播放并合成同时调用。。。
//    [_iFlySpeechSynthesizer synthesize:@"只合成不播放" toUri:soundPath];
    
    [_iFlySpeechSynthesizer startSpeaking:@"只合成不播放"];

    NSLog(@"path1 = %@",soundPath);

    NSLog(@"path = %@",[IFlySpeechConstant TTS_AUDIO_PATH]);
}

//合成结束
- (void) onCompleted:(IFlySpeechError *) error {

    NSLog(@"合成完毕 -------- onCompleted error = %@",error);
}
//合成开始
- (void) onSpeakBegin {

    NSLog(@"合成开始 -------- onSpeakBegin");
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {} //合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {}

-(void)btnAction3:(UIButton *)btn {
    
    UIView *lastV = [[UIApplication sharedApplication].delegate.window viewWithTag:10001];
    if (lastV) {
        [lastV removeFromSuperview];
        
        return;
    }
    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"测试" message:@"测试。。。" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alertV show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
        view.backgroundColor = [UIColor blueColor];
        view.tag = 10001;
        [[UIApplication sharedApplication].delegate.window addSubview:view];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
