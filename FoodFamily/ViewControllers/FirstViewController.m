//
//  FirstViewController.m
//  FoodFamily
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FirstViewController.h"
#import "DBSphereView.h"
#import "FirstPageModel.h"
#import "VideoViewController.h"
#import "CollectFavoriteModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import "SecondTopView.h"
#import "DWGCirculateScrollView.h"
@interface FirstViewController ()<UMSocialUIDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic)DBSphereView               *sphereView;
@property (nonatomic)NSArray                    *dataSouce;
@property (nonatomic)UIImageView                *foodImageView;
@property (nonatomic)UILabel                    *lable;
@property (nonatomic)NSArray                    *lableTextArray;
@property (nonatomic)NSString                   *videoUrl1;
@property (nonatomic)NSString                   *videoUrl2;
@property (nonatomic)UIImageView                *oneImageView;
@property (nonatomic)NSInteger                   page;
@property (nonatomic)FirstPageModel             *firstPageModel;
@property (nonatomic)SecondTopView              *secondTopView;
@property (nonatomic)DWGCirculateScrollView     *scrollView;
@property (nonatomic)NSMutableArray             *imgUrlNames;
@property (nonatomic)NSInteger                   index;
@end

@implementation FirstViewController
@synthesize sphereView;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor grayColor];
   
    [self.view addSubview:self.oneImageView];
    [self creatButton3];
    [self.view addSubview:self.foodImageView];
     [self feachData];
    //[self createScrollView];
   // NSLog(@"%@",NSHomeDirectory());
}
- (void)createScrollView{

    _scrollView = [[DWGCirculateScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3-10)];
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _imgUrlNames=[[NSMutableArray alloc]init];
    
    for (int i = 0; i < _dataSouce.count; i++) {
        FirstPageModel *model = _dataSouce[i];
        NSString * imgName = model.imagePathLandscape;
        [_imgUrlNames addObject:imgName];
    }
    [self.view addSubview:_scrollView];
    [_scrollView obtainImageNameArray:nil imageUrlArray:_imgUrlNames];
    [self.view addSubview:self.secondTopView];
    __weak typeof (self) weakSelf = self;
    _scrollView.block = ^(NSInteger index){
        NSLog(@"=======%ld",index);
        _index = index;
        
        [weakSelf tapGestureAction:nil];
    };

}
- (SecondTopView*)secondTopView{
    if (_secondTopView == nil) {
        UINib *nib = [UINib nibWithNibName:@"SecondTopView" bundle:nil];
        //使用UINib 创建对应的xib上所有的顶级视图，
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        for (UIView *view in array) {
            
            //isMemberOfClass 一个对象的类型是否为指定的类
            //[view isMemberOfClass:[HomeTopView class]];
            
            //判断某个对象是否属于一个类以及他的子类
            if ([view isKindOfClass:[SecondTopView class]]) {
                _secondTopView = (SecondTopView*)view;
                //设置homeTopView的坐标
                _secondTopView.frame = CGRectMake(10, 0, 300, 60);
                _secondTopView.backgroundColor = [UIColor clearColor];
                break;
            }
        }
    }
    return _secondTopView;
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [sphereView timerStop];
}
- (void)feachData{
    
    [[NetDataEngine sharedInstance]requestFirstPageDataWithPage:_page withSuccess:^(id responsData) {
        self.dataSouce = [FirstPageModel parseRespondsData:responsData];
       // NSLog(@"%@",self.dataSouce);
        [_scrollView removeFromSuperview];
        [_scrollView.pageControl removeFromSuperview];

        [self createSphereView];

        [self createScrollView];

        
    } withFaileBlock:^(NSError *error) {
       
    }];
}

- (UIImageView *)oneImageView{
    if (_oneImageView == nil) {
        _oneImageView = [[UIImageView alloc]initWithFrame:SCREEN_RECT];
        _oneImageView.image = [UIImage imageNamed:@"one.png"];
        [self creatButton3];
        _oneImageView.alpha = 0.5;
    }
    return _oneImageView;
}

- (UIImageView*)foodImageView{
    if (_foodImageView == nil) {
        _foodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2,-300, 70, 70)];
        _foodImageView.layer.cornerRadius = 35;
        _foodImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _foodImageView;
}

- (void)createSphereView{
    sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(25, [UIScreen mainScreen].bounds.size.height/3 +10, [UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.width-60)];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < _dataSouce.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageView.layer.cornerRadius = 40;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        //设置使用手指的数量
        tapGR.numberOfTouchesRequired=1;
        //设置点击的次数
        tapGR.numberOfTapsRequired=1;
        //添加点击手势
        [imageView addGestureRecognizer:tapGR];
        imageView.tag = 1000+i;
        imageView.userInteractionEnabled = YES;
        FirstPageModel *model = self.dataSouce[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imagePathLandscape]];
       // imageView.backgroundColor = [UIColor redColor];
        [array addObject:imageView];
        [sphereView addSubview:imageView];
    }
    [sphereView setCloudTags:array];
    [self.view addSubview:sphereView];
    sphereView.backgroundColor = [UIColor clearColor];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    _scrollView.alpha = 0;
    _scrollView.pageControl.alpha = 0;
    _secondTopView.alpha = 0;
    self.navigationController.navigationBarHidden = NO;
    [sphereView timerStop];
    UIImageView *imageView =(UIImageView *)tap.view;
    NSLog(@"++++++++++%ld",tap.view.tag);
   
    if (imageView.tag > 999) {
       _firstPageModel = self.dataSouce[imageView.tag - 1000];
    }else{
        _firstPageModel = self.dataSouce[_index];
    }

    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:_firstPageModel.imagePathLandscape]];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [sphereView removeFromSuperview];
            [UIView animateWithDuration:0.5 animations:^{
                self.foodImageView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.width/2);
            } completion:^(BOOL finished) {
                //self.navigationController.navigationBarHidden = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    self.foodImageView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
                } completion:^(BOOL finished) {
                    if (_dataSouce != nil ) {
                        _lableTextArray = @[_firstPageModel.name,_firstPageModel.englishName,_firstPageModel.timeLength,_firstPageModel.fittingCrowd,_firstPageModel.taste,_firstPageModel.cookingMethod,_firstPageModel.effect];
                        _videoUrl1 = _firstPageModel.materialVideoPath;
                        _videoUrl2 = _firstPageModel.productionProcessPath;
                        [self creatLabel];
                    }
                    
                    [self createNavigationBar];
                    [self creatButton];
                }];
            }];
            //[sphereView timerStart];
        }];
    }];
}

- (void)createNavigationBar{
    self.title = @"美食佳肴";
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    NSArray *titleArray = @[@"收藏",@"分享"];
    
    for (int index = 0; index < titleArray.count;index++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,50, 40)];
        NSString *title = [titleArray objectAtIndex:index];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
       // button.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        button.tag = 5000 + index;
        [button addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
    }
    NSMutableArray *barButtonItemArray = [NSMutableArray array];
    for (UIView *view in buttonArray) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:view];
        [barButtonItemArray addObject:barItem];
    }
    self.navigationItem.rightBarButtonItems = barButtonItemArray;
}
- (void)navButtonAction:(UIButton*)button
{
    NSInteger tag = button.tag - 5000;
    switch (tag) {
        case 0:
            [self collectFavoriteFood];
            break;
        case 1:
            [self shareSns];
            break;
        default:
            break;
    }
}

- (void)collectFavoriteFood{
    CollectFavoriteModel *CFModel;
   // NSLog(@"%@",_firstPageModel.imagePathThumbnails);
    FirstPageModel *model = _firstPageModel;
    NSArray *array = [CollectFavoriteModel MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"vegetable_id=%@",model.vegetable_id]];
    if(array.count > 0){
        //提示已经收藏过
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经被收藏" preferredStyle:UIAlertControllerStyleAlert];
        [contoller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:contoller animated:YES completion:nil];
    }else{
        //先判断是否已经收藏过，如果有收藏给出提示，否则保存到数据库中
        //根据vegetable_id 查找数据库中是否已经包含了该记录
        CFModel = [CollectFavoriteModel MR_createEntity];
        [CFModel setUpWith:model];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        [contoller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:contoller animated:YES completion:nil];
    }
}
//简单的分享
//- (void)shareSns{
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMAPP_KEY
//                                      shareText:@""
//                                     shareImage:[UIImage imageNamed:@"icon"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
//                                       delegate:self];
//   
//}
//-(BOOL)isDirectShareInIconActionSheet
//{
//    return YES;
//}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"分享到的平台为%@",[[response.data allKeys] objectAtIndex:0]);
    }
}


- (void)shareSns{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAPP_KEY
                                      shareText:_firstPageModel.name
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSms,UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:self];

}
//短信分享
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if ([platformName isEqualToString:UMShareToSms]) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *smsVC = [[MFMessageComposeViewController alloc]init];
            smsVC.messageComposeDelegate = self;
        }
    }else if ([platformName isEqualToString:UMShareToEmail]){
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{


}


- (void)back{
    _scrollView.alpha = 1;
    _scrollView.pageControl.alpha = 1;
    _secondTopView.alpha = 1;
    for (UIView *view in [self.foodImageView subviews]) {
        NSLog(@"-----------------------%@",view);
        [view removeFromSuperview];
    }
    //[self.lable removeFromSuperview];
    self.navigationController.navigationBarHidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.foodImageView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.width/2);
        self.foodImageView.bounds = CGRectMake(0, 0, 60, 60);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.foodImageView.center = CGPointMake(self.view.bounds.size.width/2, 800);
           // [self feachData];
            [self createSphereView];
            
        } completion:^(BOOL finished) {
            self.foodImageView.center = CGPointMake(self.view.bounds.size.width/2, -70);
        }];
    }];
}

- (void)creatLabel{
    for (NSInteger index = 0; index < 7; index ++) {
        _lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5*(index + 1) + self.view.bounds.size.width/10 *index,self.view.bounds.size.width -30 , self.view.bounds.size.width/10)];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.text = _lableTextArray[index];
        _lable.textColor = [UIColor whiteColor];
        [self.foodImageView addSubview:_lable];
    }
}

- (void) creatButton{
    self.foodImageView.userInteractionEnabled = YES;
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(30, self.view.bounds.size.height - 200, 100, 50);
    button1.tag = 1000;
    [button1 setTitle:@"原料视频" forState:UIControlStateNormal];
    button1.layer.cornerRadius = 5;
    button1.layer.masksToBounds = YES;
    [button1 addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor yellowColor];
    [self.foodImageView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(self.view.bounds.size.width - 130, self.view.bounds.size.height - 200, 100, 50);
    button2.tag = 2000;
    [button2 setTitle:@"做法视频" forState:UIControlStateNormal];
    button2.layer.cornerRadius = 5;
    button2.layer.masksToBounds = YES;
    [button2 addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor = [UIColor yellowColor];
    [self.foodImageView addSubview:button2];
}

- (void)creatButton3{
    self.oneImageView.userInteractionEnabled = YES;
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(self.oneImageView.bounds.size.width - 130, self.oneImageView.bounds.size.height - 80, 100, 30);
    button3.alpha = 1;
    button3.tag = 3000;
    [button3 setTitle:@"小二上新菜" forState:UIControlStateNormal];
    button3.layer.cornerRadius = 5;
    button3.layer.masksToBounds = YES;
    [button3 addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    button3.backgroundColor = [UIColor grayColor];
    [self.oneImageView addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    button4.frame = CGRectMake(30, self.oneImageView.bounds.size.height - 80, 100, 30);
    button4.alpha = 1;
    button4.tag = 4000;
    [button4 setTitle:@"返回上一页" forState:UIControlStateNormal];
    button4.layer.cornerRadius = 5;
    button4.layer.masksToBounds = YES;
    [button4 addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    button4.backgroundColor = [UIColor grayColor];
    [self.oneImageView addSubview:button4];

}

- (void)touch:(UIButton *)button{
    // NSLog(@"视频按键%ld被点了",button.tag);
    VideoViewController *vid = [[VideoViewController alloc]init];
    if (button.tag == 1000) {
        vid.voidUrl = _videoUrl1;
         vid.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vid animated:YES completion:nil];
    }else if(button.tag == 2000){
        vid.voidUrl = _videoUrl2;
        vid.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vid animated:YES completion:nil];
    }else if(button.tag == 3000){
        if (_page == 0) {
            _page = 1;
        }
        _page++;
        NSLog(@"%ld",_page);
        [sphereView timerStop];
        [sphereView removeFromSuperview];
        [self feachData];
        //[self createSphereView];
        [sphereView timerStop];
    }else if (button.tag == 4000){
      
        if (_page == 1||_page == 0) {
            NSLog(@"已经是第一页了");
            //_page = 1;
            [self createAlertController];
            return;
        }
          _page--;
        NSLog(@"%ld",_page);
        [sphereView timerStop];
        [sphereView removeFromSuperview];
        [self feachData];
        [sphereView timerStop];
    }
    
}
- (void)createAlertController{
    UIAlertController * alearnController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经回到第一页了" preferredStyle: UIAlertControllerStyleAlert];
    [alearnController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];

    [self presentViewController:alearnController animated:YES completion:nil];

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
