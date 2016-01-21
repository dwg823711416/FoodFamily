//
//  CollectDetailViewController.m
//  FoodFamily
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "CollectDetailViewController.h"
#import "VideoViewController.h"
@interface CollectDetailViewController ()
@property (nonatomic)UIImageView     *foodImageView;
@property (nonatomic)UILabel         *lable;
@property (nonatomic)NSArray         *lableTextArray;
@property (nonatomic)NSString        *videoUrl1;
@property (nonatomic)NSString        *videoUrl2;
@end

@implementation CollectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.foodImageView];
    [self creatLabel];
    [self creatButton];

}
- (UIImageView*)foodImageView{
    if (_foodImageView == nil) {
        _foodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
        [_foodImageView sd_setImageWithURL:[NSURL URLWithString:_model.imagePathLandscape]];
        //_ballView.layer.cornerRadius = 35;
        _foodImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _foodImageView;
}
- (void)creatLabel{
    _lableTextArray = @[_model.name,_model.englishName,_model.timeLength,_model.fittingCrowd,_model.taste,_model.cookingMethod,_model.effect];
    _videoUrl1 = _model.materialVideoPath;
    _videoUrl2 = _model.productionProcessPath;
    for (NSInteger index = 0; index < 7; index ++) {
        _lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5*(index + 1) + SCREEN_WIDTH/10 *index,SCREEN_WIDTH -30 , SCREEN_WIDTH/10)];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.text = _lableTextArray[index];
        _lable.textColor = [UIColor whiteColor];
        [self.foodImageView addSubview:_lable];
    }
}
- (void) creatButton{
    self.foodImageView.userInteractionEnabled = YES;
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(30, SCREEN_HEIGHT - 200, 100, 50);
    button1.tag = 1000;
    [button1 setTitle:@"原料视频" forState:UIControlStateNormal];
    button1.layer.cornerRadius = 5;
    button1.layer.masksToBounds = YES;
    [button1 addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor yellowColor];
    [self.foodImageView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(SCREEN_WIDTH - 130, SCREEN_HEIGHT - 200, 100, 50);
    button2.tag = 2000;
    [button2 setTitle:@"做法视频" forState:UIControlStateNormal];
    button2.layer.cornerRadius = 5;
    button2.layer.masksToBounds = YES;
    [button2 addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor = [UIColor yellowColor];
    [self.foodImageView addSubview:button2];
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
    }
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
