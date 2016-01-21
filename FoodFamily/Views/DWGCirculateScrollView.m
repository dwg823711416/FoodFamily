//
//  DWGCirculateScrollView.m
//  DWGScrollView
//
//  Created by qianfeng on 16/1/9.
//  Copyright © 2016年 DuWeiGuo. All rights reserved.
//

#import "DWGCirculateScrollView.h"
#define UISCREENWIDTH   self.bounds.size.width  //滚动视图的宽度
#define UISCREENHEIGHT  self.bounds.size.height //滚动视图的高度
#define HIGHT           self.bounds.origin.y    //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标
static CGFloat const chageImageTime = 3.0;
@interface DWGCirculateScrollView ()
{
    //计数当前页
    NSInteger           _currentPage;
    //三个imageView
    UIImageView       * _leftImageView;
    UIImageView       * _centerImageView;
    UIImageView       * _rightImageView;
    NSTimer           * _timer;
    NSInteger           _imageTag;
    NSInteger           _imagePage;
}


@end
@implementation DWGCirculateScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self customScrollView];
    }
    return self;
}
- (void) obtainImageNameArray:(NSArray *)imageNameArray imageUrlArray:(NSArray *)imageUrlArray{
    if (imageNameArray != nil) {
        self.imageNameArray = imageNameArray;
        _imagePage = imageNameArray.count;
    }
    if (imageUrlArray != nil) {
        self.imageUrlNameArray = imageUrlArray;
        _imagePage = imageUrlArray.count;
    }
    [self createImageView];
    [self createPageControl];


    _timer = [NSTimer timerWithTimeInterval:chageImageTime target:self selector:@selector(addPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}
//定制ScrollView
- (void) customScrollView{
    
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
    self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
    self.delegate = self;
}
//创建ImageView
- (void) createImageView{
    
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    [self addSubview:_leftImageView];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    [self addSubview:_centerImageView];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    [self addSubview:_rightImageView];
}
//创建PageControl
- (void)createPageControl{
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imagePage;
    _pageControl.frame = CGRectMake( UISCREENWIDTH - 20*_pageControl.numberOfPages, UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
   
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    _pageControl.pageIndicatorTintColor=[UIColor greenColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    _pageControl.userInteractionEnabled = NO;
     [[self superview] addSubview:_pageControl];
   // NSLog(@"%@",[self superview]);
    
}

- (void)addPage{
    [self setContentOffset:CGPointMake(UISCREENWIDTH, 0) animated:YES];
    if (_currentPage == _imagePage) {
        _currentPage = 0;
    }
    [self refreshCurrentPage];
    [self adjustStateToPage:_currentPage];
    //NSLog(@"---%ld",_currentPage);
    _currentPage ++;

}

//刷新当前应该显示哪一页
- (void)refreshCurrentPage{
    
    NSInteger index = self.contentOffset.x/UISCREENWIDTH;
    if (index == 0) {
        _currentPage--;
        if (_currentPage == -1) {
            _currentPage = _imagePage - 1;
        }
        [self adjustStateToPage:_currentPage];
    }
    if (index == 2) {
        _currentPage++;
        if (_currentPage == _imagePage) {
            _currentPage = 0;
        }
        [self adjustStateToPage:_currentPage];
    }
}

-(void)adjustStateToPage:(NSInteger)currentPage{
    _pageControl.currentPage = _currentPage;
    _imageTag = currentPage;
    NSInteger leftPage;
    NSInteger middlePage;
    NSInteger rightPage;
    //确定左中右，分别应该是哪一页的索引
    middlePage = currentPage;
    leftPage=currentPage - 1;
    if (leftPage == -1) {
        leftPage = _imagePage-1;
    }
    rightPage=currentPage+1;
    if (rightPage == _imagePage) {
        rightPage = 0;
    }
    //加载图片
    if (_imageNameArray != nil) {
        _centerImageView.image = [UIImage imageNamed:_imageNameArray[middlePage]];
        _leftImageView.image = [UIImage imageNamed:_imageNameArray[leftPage]];
        _rightImageView.image = [UIImage imageNamed:_imageNameArray[rightPage]];
    }
    if (_imageUrlNameArray != nil) {
        [_centerImageView sd_setImageWithURL:_imageUrlNameArray[middlePage] placeholderImage:nil];
        [_leftImageView sd_setImageWithURL:_imageUrlNameArray[leftPage] placeholderImage:nil];
        [_rightImageView sd_setImageWithURL:_imageUrlNameArray[rightPage] placeholderImage:nil];
    }
    
    //偏移到中间那一张。
    [self setContentOffset:CGPointMake(UISCREENWIDTH, 0) animated:NO];
    _centerImageView.tag = 1000 + currentPage;
    _centerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap:)];
    
    [_centerImageView addGestureRecognizer:tap];
}

- (void)touchTap:(UITapGestureRecognizer *)tap{

    NSLog(@"第%ld页被点了",tap.view.tag - 1000);
    if (self.block) {
      self.block(tap.view.tag - 1000);
    }
}
#pragma mark - scroll代理方法 -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // NSLog(@"拖动中");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
   // NSLog(@"手拖动了");
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
   // NSLog(@"松手了");
    if (!decelerate) {
        [self refreshCurrentPage];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
   // NSLog(@"已经结束减速");
    _currentPage --;
    [self refreshCurrentPage];
    [_timer setFireDate:[NSDate distantPast]];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
