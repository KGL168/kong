//
//  LDLauchMovieViewController.m
//  Panachz
//
//  Created by sanlimikaifa on 2017/2/7.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import "LDLauchMovieViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kIsFirstLauchApp @"kIsFirstLauchApp"

@interface LDLauchMovieViewController ()
/** 播放开始之前的图片 */
//@property (nonatomic , strong)UIImageView *startPlayerImageView;
/** 播放中断时的图片 */
@property (nonatomic , strong)UIImageView *pausePlayerImageView;
/** 结束按钮 */
@property (nonatomic , strong)UIButton *enterMainButton;


@end

@implementation LDLauchMovieViewController

- (BOOL)shouldAutorotate {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置界面
    [self setupView];
    //添加监听
    [self addNotification];
    //初始化视频
    [self prepareMovie];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark -- 初始化视频
- (void)prepareMovie {
    //首次运行
    NSString *filePath = nil;
    if (![self isFirstLauchApp]) {
        //第一次安装
        filePath = [[NSBundle mainBundle] pathForResource:@"L-denim.mp4" ofType:nil];
        [self setIsFirstLauchApp:YES];
    }else {
        filePath = [[NSBundle mainBundle] pathForResource:@"L-denim.mp4" ofType:nil];
    }
    //初始化player
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
    self.showsPlaybackControls = NO;
    //播放视频
    [self.player play];
    
    
}


#pragma mark -- 初始化视图逻辑
- (void)setupView {


    //是否是第一次进入视频
    if (![self isFirstLauchApp]) {
        //第一次安装
        
    }
    //设置进入主界面的按钮
    [self setupEnterMainButton];
}

- (void)setupEnterMainButton {
    self.enterMainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _enterMainButton.frame = CGRectMake(kScreenWidth - 54 - 24, 32, 54, 34);
    _enterMainButton.layer.borderWidth =1;
    _enterMainButton.layer.cornerRadius = 8;
    _enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_enterMainButton setTitle:@"Skip" forState:UIControlStateNormal];
    [self.view addSubview:_enterMainButton];
    [_enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置定时器当视频播放到第三秒时 展示进入应用

}


#pragma mark -- 进入应用和显示进入按钮
- (void)enterMainAction:(UIButton *)btn {
    //视频暂停
    [self.player pause];
    self.pausePlayerImageView = [[UIImageView alloc] init];
    _pausePlayerImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.contentOverlayView addSubview:_pausePlayerImageView];
    self.pausePlayerImageView.contentMode = UIViewContentModeScaleAspectFit;
    //获取当前暂停时的截图
    [self getoverPlayerImage];
}
- (void)getoverPlayerImage {
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self.player.currentItem.asset];
    gen.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CMTime actualTime;
    CMTime now = self.player.currentTime;
    [gen setRequestedTimeToleranceAfter:kCMTimeZero];
    [gen setRequestedTimeToleranceBefore:kCMTimeZero];
    CGImageRef image = [gen copyCGImageAtTime:now actualTime:&actualTime error:&error];
    if (!error) {
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        self.pausePlayerImageView.image = thumb;
    }
    NSLog(@"%f , %f",CMTimeGetSeconds(now),CMTimeGetSeconds(actualTime));
    NSLog(@"%@",error);
    //视频播放结束
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self moviePlaybackComplete];
    });
    
}

//进入主界面
- (void)enterMain {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate resetRootViewController];
}

#pragma mark -- 监听以及实现方法
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];//进入前台
    
    //第二次进入app视频需要直接结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];//视频播放结束
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStart) name:AVPlayerItemTimeJumpedNotification object:nil];//播放开始
}

//开始播放
- (void)moviePlaybackStart {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.startPlayerImageView removeFromSuperview];
//        self.startPlayerImageView = nil;
    });
}
//视频播放完成
- (void)moviePlaybackComplete {
    //发送推送之后就删除  否则 界面显示有问题
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    
//    [self.startPlayerImageView removeFromSuperview];
//    self.startPlayerImageView = nil;
    
    [self.pausePlayerImageView removeFromSuperview];
    self.pausePlayerImageView = nil;
    
    //进入主界面
    [self enterMain];
}
- (void)viewWillEnterForeground
{
    NSLog(@"app enter foreground");
    if (!self.player) {
        [self prepareMovie];
    }
    //播放视频
    [self.player play];
}

#pragma mark -- 是否第一次进入app
- (BOOL)isFirstLauchApp {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstLauchApp];
}

- (void)setIsFirstLauchApp:(BOOL)isFirstLauchApp
{
    [[NSUserDefaults standardUserDefaults] setBool:isFirstLauchApp forKey:kIsFirstLauchApp];
}

@end
