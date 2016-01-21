//
//  PlayerView.h
//  CustomPlayerDemo
//
//  Created by lijinghua on 15/12/2.
//  Copyright © 2015年 lijinghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//显示视频的内容的view，如果让该view能够显示视频
//layer必须为AVPlayerLayer
@interface PlayerView : UIView

//设置layer需要的AVPlayer
//由AVPlayer来提供一帧帧的画面内容，AVPlayerLayer来渲染
- (void)setPlayer:(AVPlayer*)player;

@end
