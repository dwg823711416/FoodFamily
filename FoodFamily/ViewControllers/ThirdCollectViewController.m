//
//  ThirdCollectViewController.m
//  FoodFamily
//
//  Created by qianfeng on 16/1/26.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import "ThirdCollectViewController.h"
#import "ThirdCookFoodView.h"

#import "ThirdCookTableViewCell1.h"
#import "ThirdCookTableViewCell2.h"
#import "ThirdCookTableViewCell3.h"
#import "ThirdCookTableViewCell4.h"
#import "CollectFavoriteModel2.h"

@interface ThirdCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSArray               * thirdCookArr;
@property (nonatomic) NSString              * rid;
@property (nonatomic) UITableView           * tableView;
@property (nonatomic) ThirdCookFoodView     * topView;
@property (nonatomic) CollectFavoriteModel2 * cookModel;
@end

@implementation ThirdCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rid = self.cookBaseModel.id;
   // NSLog(@"%@",_rid);
    _thirdCookArr = [CollectFavoriteModel2 MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"rid=%@",self.cookBaseModel.id]];
   // NSLog(@"%@",_thirdCookArr);
    [self crateFoodView];
    [self addData];
    [self creatTableView];
    

}

- (void)crateFoodView{
    
    UINib *nib = [UINib nibWithNibName:@"ThirdCookFoodView" bundle:nil];
    _topView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3 );
    _topView.layer.cornerRadius = 20;
    _topView.layer.masksToBounds = YES;
    
}
- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT -49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _topView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去除垂直的滚动条的指示
    _tableView.showsVerticalScrollIndicator = NO;
    //取消tableView自带的分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 20;
    
    
    UINib *nib1 = [UINib nibWithNibName:@"ThirdCookTableViewCell1" bundle:nil];
    [_tableView registerNib:nib1 forCellReuseIdentifier:@"cellID1"];
    
    UINib *nib2 = [UINib nibWithNibName:@"ThirdCookTableViewCell2" bundle:nil];
    [_tableView registerNib:nib2 forCellReuseIdentifier:@"cellID2"];
    
    UINib *nib3 = [UINib nibWithNibName:@"ThirdCookTableViewCell3" bundle:nil];
    [_tableView registerNib:nib3 forCellReuseIdentifier:@"cellID3"];
    
    UINib *nib4 = [UINib nibWithNibName:@"ThirdCookTableViewCell4" bundle:nil];
    [_tableView registerNib:nib4 forCellReuseIdentifier:@"cellID4"];
    
    
    
    [self.view addSubview:_tableView];
}

- (void)addData{
    
    [_topView.imageView sd_setImageWithURL:[NSURL URLWithString:_cookBaseModel.cover] placeholderImage:[UIImage imageNamed:@"111.png"]];
    _topView.lable1.text = _cookBaseModel.basefood;
    _topView.lable2.text = _cookBaseModel.during;
    _topView.lable3.text = _cookBaseModel.cuisine;
    _topView.lable4.text = _cookBaseModel.technics;
    _topView.lable5.text = _cookBaseModel.title;
    
}

#pragma mark <tableView带理方法>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return _thirdCookArr.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    if (indexPath.section == 1) {
        return 80;
    }
    if (indexPath.section == 3) {
        return 200;
    }
    return 115;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ThirdCookTableViewCell1 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID1" forIndexPath:indexPath];
        if(!_cookBaseModel.message.length){
            cell.cell1Lable.text = _cookBaseModel.message;
        }else{
            cell.cell1Lable.text = @"暂无";
        }
        
        return cell;
    }else if (indexPath.section == 1){
        ThirdCookTableViewCell1 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID1" forIndexPath:indexPath];
        cell.cell1Lable.text = _cookBaseModel.mainingredient;
        return cell;
        
    }else if (indexPath.section == 2){
        ThirdCookTableViewCell3 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID3" forIndexPath:indexPath];
        _cookModel = _thirdCookArr[indexPath.row];
        
        [cell.cell3ImageView sd_setImageWithURL:[NSURL URLWithString:_cookModel.pic] placeholderImage:[UIImage imageNamed:@"111.png"]];
        cell.cell3ImageView.layer.cornerRadius = 12;
        cell.cell3ImageView.layer.masksToBounds = YES;
        cell.cell3Lable.text = [NSString stringWithFormat:@"%ld、%@",indexPath.row + 1,_cookModel.note];
        
        return cell;
    }else if (indexPath.section == 3){
        ThirdCookTableViewCell4 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID4" forIndexPath:indexPath];
        //NSLog(@"%@",_cookBaseModel.tips );
        if (_cookBaseModel.tips.length) {
            [cell.cell4WebView loadHTMLString:_cookBaseModel.tips baseURL:nil];
        }else{
            
            [cell.cell4WebView loadHTMLString:@"尽情的享受下自己亲手做的美食吧" baseURL:nil];
            
        }
        
        return cell;
        
    }
    
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, 30)];
    lable.layer.cornerRadius = 15;
    lable.layer.masksToBounds = YES;
    lable.backgroundColor = [UIColor grayColor];
    if(section == 0){
        
        lable.text = @"   食物简介";
        [view addSubview:lable];
        //view.backgroundColor = [UIColor greenColor];
    }else if (section == 1){
        lable.text = @"   所需食材";
        [view addSubview:lable];
        // view.backgroundColor = [UIColor blueColor];
        
    }else if (section == 2){
        lable.text = @"   具体做法";
        [view addSubview:lable];
        //view.backgroundColor = [UIColor purpleColor];
    }else if (section == 3){
        lable.text = @"   后记";
        [view addSubview:lable];
        //view.backgroundColor = [UIColor brownColor];
    }
    
    return view;
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
