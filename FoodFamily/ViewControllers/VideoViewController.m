//
//  VideoViewController.m
//  meishiwu
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoViewController ()
@property (nonatomic)AVPlayer                       *player;
@property (weak, nonatomic) IBOutlet UIProgressView *vDownProgress;
@property (nonatomic,assign)BOOL                    bSliderDragging;
@property (weak, nonatomic) IBOutlet UILabel        *lblAllTime;
@property (weak, nonatomic) IBOutlet UILabel        *lblPlayTime;
@property (nonatomic,strong)NSTimer                 *avTimer;
@property (nonatomic)NSInteger                      index;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _activityView.hidden = YES;
    [self createSliderAndDownProgress];
    
   
}
- (void)createSliderAndDownProgress{
    self.slider.maximumValue = 1.0;
    self.slider.minimumValue = 0.0;
    self.slider.value        = 0.0;
    // _vDownProgress = [[UIView alloc] initWithFrame:CGRectMake(20, 500, 10, 20)];
    //滑块左侧颜色
    _slider.minimumTrackTintColor=[UIColor blueColor];
    //滑块右侧颜色
    _slider.maximumTrackTintColor=[UIColor whiteColor];
    //按钮颜色
    _slider.thumbTintColor=[UIColor grayColor];
    [_vDownProgress setProgress:0.00 animated:NO];
    _vDownProgress.tintColor=[UIColor grayColor];
    _vDownProgress.trackTintColor=[UIColor clearColor];
    _vDownProgress.layer.cornerRadius = 1;
    [self.view addSubview:_vDownProgress];
}

- (IBAction)back:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)play:(id)sender {
    //创建一个活动指示器
       //设置背景色
   // _activityView.backgroundColor = [UIColor purpleColor];
   // _activityView.hidden = NO;
//    //设置停止旋转时候自动隐藏
   // _activityView.hidesWhenStopped = NO;
    //启动动画
    [_activityView startAnimating];
    _activityView.hidden = NO;
    //停止动画
    //
    //设置指示器的样式
    //UIActivityIndicatorViewStyleWhiteLarge大白
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //是任务栏的活动指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    //首先需要判断有没有实例化player
    if (self.player) {
        //已经实例话，调用play播放，多次调用player不影响
        [self.player play];
        if(_avTimer)
        {
            [_avTimer invalidate];
            _avTimer = nil;
        }
        _avTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playing) userInfo:nil repeats:YES];
        [self playing];
        return;
    }
    //生成URL 代表播放的路径
    //本地资源使用fileURLWithPath
    //网络资源 URLWithString
    NSURL *url = [NSURL URLWithString:self.voidUrl];
    //AVURLAsset 代表一个播放的资产，音乐，影片，视频
    AVURLAsset *localAsset = [AVURLAsset assetWithURL:url];
    //对资产的整体描述，资产的状态信息，譬如视频的长度，以及视频是否可以播放
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithAsset:localAsset];
    //AVPlayer有他来播放资产，一旦使用playItem 来初始化AVPlayer，AVPlayer自动对视频进行预加载分析，分析的结果会在playItem 中status字段体现出来，当status成为ReadyToPlay影片才可以播放
    self.player = [AVPlayer playerWithPlayerItem:playItem];
    //为了让图像显示，设置player
    [self.playView setPlayer:self.player];
        //使用KVO监控playItem的状态信息
   
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听加载状态信息
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监控影片的结束,视频结束时会发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self playing];
}

- (void)playing{
    NSTimeInterval avDuration = [self playableDuration];
    NSTimeInterval avPlayTime = [self playableCurrentTime];
     NSLog(@"%f",avPlayTime);
    if (!_bSliderDragging && avPlayTime > 0)
    {
        _lblPlayTime.text = [self convertToMM:avPlayTime];
    }
    if (!_bSliderDragging && avPlayTime > 0 && avDuration > 0)
    {
        CGFloat percent = avPlayTime / avDuration;
        [_slider setValue:percent animated:YES];
    }
    if(_avTimer)
    {
        [_avTimer invalidate];
        _avTimer = nil;
    }
    _avTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playing) userInfo:nil repeats:YES];
    if (avDuration > 0)
    {
        _lblAllTime.text = [self convertToMM:avDuration];
        NSLog(@"%@",[self convertToMM:avDuration]);
    
        //获取缓冲区域获取缓冲进度
        NSArray *loadedTimeRanges=self.player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange=[loadedTimeRanges.firstObject CMTimeRangeValue];
        float  startSecond=CMTimeGetSeconds(timeRange.start);
        float  durationSecond=CMTimeGetSeconds(timeRange.duration);
        //缓冲的总长度
        NSTimeInterval result =startSecond+durationSecond;
        NSLog(@"%f",result);

        _vDownProgress.progress =  result / avDuration;
        //设置进度条颜色
        if (avPlayTime +1 > avDuration) {
            [_avTimer setFireDate:[NSDate distantFuture]];
            avPlayTime = 0;
        }
        // NSLog(@"%f",download);
        // NSLog(@"%f",avDuration);
    }
}

#pragma mark - get AVPlayerItem info
- (NSTimeInterval)playableDuration
{
    AVPlayerItem * item = _player.currentItem;
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        return CMTimeGetSeconds(_player.currentItem.duration);
    }
    else
    {
        return(CMTimeGetSeconds(kCMTimeInvalid));
    }
}

- (NSTimeInterval)playableCurrentTime
{
    AVPlayerItem * item = _player.currentItem;
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        return CMTimeGetSeconds(_player.currentItem.currentTime);
    }
    else
    {
        return(CMTimeGetSeconds(kCMTimeInvalid));
    }
}

- (NSString*)convertToMM:(NSTimeInterval)t {
    int m = t / 60;
    int s = (int)t % 60;
    NSString* mStr = [NSString stringWithFormat:(m < 10 ? @"0%d" : @"%d"),m];
    NSString* sStr = [NSString stringWithFormat:(s < 10 ? @"0%d" : @"%d"),s];
    return [NSString stringWithFormat:@"%@:%@",mStr,sStr];
}

- (void)playerEnd:(NSNotification*)notify
{
    _lblPlayTime.text = @"00:00";
    [self.player seekToTime:kCMTimeZero];
     [self.player pause];
    //[self.player play];
}

//停止播放
- (void)stopPlayer
{
    //1:把自己从KVO中删除
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    //2:从通知中心删除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //3:暂停播放器
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    //4:释放掉播放器
    self.player = nil;
}

- (IBAction)pause:(id)sender {
    [self.player pause];
}

- (IBAction)updateProgress:(id)sender {
    //得到进度百分比
    float progress = self.slider.value;
    CMTime totalTime = self.player.currentItem.duration;
    //CMTimeMultiplyByFloat64 :CMTime 乘以 float类型 得到以同样速率播放的时间
    CMTime seekTime = CMTimeMultiplyByFloat64(totalTime, progress);
    //定位到播放的时间位置
    [self.player seekToTime:seekTime];
}
//status状态变化后调用的代理方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"status"]){
        AVPlayerItem *item = (AVPlayerItem*)object;
//        if (item.status == AVPlayerItemStatusUnknown) {
//            
//        }
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            //播放影片
            [self.player play];
            //AVPlayer本身提供周期性调用的函数
            //参数1:时间间隔，使用的结构是CMTime
            //参数2:block 在哪个block上运行
            //参数3:提供周期性调用的block
            
            //CMTime 描述视频播放的时间的一个结构，考虑播放速率的问题
            //CMTimeMake(1, 1) =>1/1  1秒
            //CMTimeMake(2,2)  =>2/2  1秒
            //破除循环引用
            __weak typeof(self) weakSelf = self;
            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                [weakSelf.activityView stopAnimating];
                weakSelf.activityView.hidden = YES;
                //在主队列上调用block，block中的参数代表当前播放的时间
                NSLog(@"-----i = %ld",weakSelf.index++);
                //当前播放时间
                CMTime currentTime = time;
                //获取影片的总时间
                CMTime totalTime = weakSelf.player.currentItem.duration;
                //CMTimeGetSeconds 把一个CMTime结构的时间转成秒
                Float64 currentSecond = CMTimeGetSeconds(currentTime);
                Float64 totalSecond = CMTimeGetSeconds(totalTime);
                weakSelf.slider.value = currentSecond / totalSecond;
            }];
        }else{
            NSLog(@"影片不能播放");
        }
    }
}

#pragma mark -
#pragma mark 屏幕旋转
//是否支持屏幕旋转
- (BOOL)shouldAutorotate{
    return YES;
}

//支持哪个方向的屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidDisappear:(BOOL)animated{
    [_avTimer setFireDate:[NSDate distantFuture]];
    [self stopPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
