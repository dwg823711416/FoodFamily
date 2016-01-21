//
//  PlayerView.m
//  CustomPlayerDemo
//
//  Created by lijinghua on 15/12/2.
//  Copyright © 2015年 lijinghua. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

//重新layerClass 改变view对应的layer类型
+(Class)layerClass{
    return [AVPlayerLayer class];
}


- (void)setPlayer:(AVPlayer*)player
{
    //自身对应layer对象并转成AVPlayerLayer
    AVPlayerLayer *layer =  (AVPlayerLayer*)self.layer;
    
    //设置视频的填充模式
    //AVLayerVideoGravityResize,
    //AVLayerVideoGravityResizeAspect
    //AVLayerVideoGravityResizeAspectFill.
    
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //把AVPlayer和渲染图像用的layer 关联起来，这样AVPlayer负责提供内容，layer负责渲染，图像就可以在view上显示出来了
    [layer setPlayer:player];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
