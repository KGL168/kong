//
//  TutorialSreenViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "WhatIsPanachzSreenViewController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface WhatIsPanachzSreenViewController ()
@property (nonatomic, strong) AVPlayerViewController *playerController;
/** 播放中断时的图片 */
@property (nonatomic , strong)UIImageView *pausePlayerImageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WhatIsPanachzSreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES
                                               animated:NO];
    // 设置界面
    [self setupView];
    //添加监听
    [self addNotification];
    //初始化视频
    [self prepareMovie];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerController.player pause];
    self.playerController = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerController.player pause];
    self.playerController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark -- 初始化视频
- (void)prepareMovie {
    
    AVPlayer * player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://www.ldenim.com/video/training_ipad.mp4"]];
    self.playerController = [[AVPlayerViewController alloc]init];
    self.playerController.player = player;
    
    [self addChildViewController:self.playerController];
    [self.view addSubview:self.playerController.view];
    self.playerController.view.frame = CGRectMake(0, 65, kScreenWidth, kScreenHeight-65);
    [self.playerController.player play];
    
}


#pragma mark -- 初始化视图逻辑
- (void)setupView {
    self.titleLabel.text = @"About L-Denim";
}


#pragma mark -- 进入应用和显示进入按钮
- (void)enterMainAction:(UIButton *)btn {
    //视频暂停
    [self.playerController.player pause];
    //获取当前暂停时的截图
    [self getoverPlayerImage];
}
- (void)getoverPlayerImage {
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self.playerController.player.currentItem.asset];
    gen.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CMTime actualTime;
    CMTime now = self.playerController.player.currentTime;
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
    if (!self.playerController.player) {
        [self prepareMovie];
    }
    //播放视频
    [self.playerController.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
