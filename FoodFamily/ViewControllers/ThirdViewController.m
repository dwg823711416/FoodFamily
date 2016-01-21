//
//  ThirdViewController.m
//  FoodFamily
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "ThirdViewController.h"
#import "ThirdCollectionViewCell.h"
#import "ThirdPageModelONE.h"
#import "ThirdPopViewController.h"
#define CELLID @"collectionCellId"
@interface ThirdViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>
@property (nonatomic) UICollectionView       * collectionView;
@property (nonatomic) NSInteger                page;
@property (nonatomic) NSMutableArray         * dataSouce;
@property (nonatomic) BOOL                     isRefreshing;
@property (nonatomic) UIImageView            * imageView;
@property (nonatomic) ThirdPopViewController * contentVC;
@property (nonatomic) NSString               * strNew;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"美味生活";
    _strNew = @"家常饭菜";
     _dataSouce = [[NSMutableArray alloc]init];
     _contentVC = [[ThirdPopViewController alloc]init];
    //添加观察者 观察_contentVC.str的改变
    [_contentVC addObserver:self forKeyPath:@"str" options:NSKeyValueObservingOptionNew context:nil];
    [self createNavigationRightBarButtonItems];
    [self createNavigationLeftBarButtonItems];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.collectionView];
    
    [self requestData];
    [self createRefreshHeadView];
    [self createRefreshFootView];
}
- (void)createNavigationRightBarButtonItems{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"家常饭菜" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)rightBarButtonClick{
   
    //设置内容控制器的弹出模式为popover
    _contentVC.modalPresentationStyle = UIModalPresentationPopover;
    //修改弹出的大小
    _contentVC.preferredContentSize = CGSizeMake(100, 250);
    
    //注意：popover不是通过alloc init创建出来的，而是从内容控制器中的popoverPresentationController 属性 得到
    UIPopoverPresentationController *popover = _contentVC.popoverPresentationController;
    //设置弹出位置
    popover.barButtonItem = self.navigationItem.rightBarButtonItem;
    //设置箭头的方向
    //UIPopoverArrowDirectionAny 让系统自动调整方向
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //设置代理
    popover.delegate = self;
    
    
    //注意弹出的不是popover，而是内容，他的内容会呈现在popover中
    [self presentViewController:_contentVC animated:YES completion:nil];
}
//kvo回调
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context{
    if ([_strNew isEqualToString:[change objectForKey:NSKeyValueChangeNewKey]]) {
        return;
    }
    [_dataSouce removeAllObjects];
    _page = 0;
    _strNew = [change objectForKey:NSKeyValueChangeNewKey];
    // NSLog(@"%@",_strNew);
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:_strNew style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    [self requestData];
}

- (void)createNavigationLeftBarButtonItems{

}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:SCREEN_RECT];
        _imageView.image = [UIImage imageNamed:@"个人中心.png"];
    }
    return _imageView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/3 - 10, SCREEN_WIDTH/3 - 10 + 29);
       layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        //设置2个item之间的最小间隙，
        layout.minimumInteritemSpacing = 5;
        //设置行之间的最小间距
        layout.minimumLineSpacing      = 5;
        //设置滚动方向，默认是垂直滚动
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64 - 49) collectionViewLayout:layout];
         _collectionView.backgroundColor = [UIColor clearColor];
        //_collectionView.pagingEnabled = YES;//按页翻动
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        UINib * nib = [UINib nibWithNibName:@"ThirdCollectionViewCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:CELLID];
    }
    return _collectionView;
}

- (void)requestData{
    if ([_strNew isEqualToString:@"家常饭菜"]) {
        
        [NetDataEngine sharedInstance].url = URL_MWLife;
    }else if ([_strNew isEqualToString:@"女人最爱"]){
        
        [NetDataEngine sharedInstance].url = URL_ZY;
    }else if ([_strNew isEqualToString:@"男人最爱"]){
        
        [NetDataEngine sharedInstance].url = URL_BY;
    }else if ([_strNew isEqualToString:@"利身止咳"]){
        
        [NetDataEngine sharedInstance].url = URL_ZK;
    }else if ([_strNew isEqualToString:@"养颜美容"]){
        
        [NetDataEngine sharedInstance].url = URL_MR;
    }else if ([_strNew isEqualToString:@"滋补养生"]){
        
        [NetDataEngine sharedInstance].url = URL_YS;
    }

    [[NetDataEngine sharedInstance]requestThirdPageDataWithPage:(int)_page withSuccess:^(id responsData) {
        //NSLog(@"--------%ld",_page);
        [_dataSouce addObjectsFromArray:[ThirdPageModelONE parseRespondsData:responsData]];
        [_collectionView reloadData];
       // NSLog(@"%@",_dataSouce);
        
    } withFaileBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)createRefreshHeadView
{
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    
    [self.collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //如果正在刷新中，直接返回
        if (weakSelf.isRefreshing) {
            return ;
        }
        //执行刷新
        weakSelf.isRefreshing = YES;
        //执行刷新
        [weakSelf.dataSouce removeAllObjects];
        weakSelf.page = 0;
        [weakSelf requestData];
        //刷新结束
        //1:刷表
        [weakSelf.collectionView reloadData];
        //2:设置刷新状态为NO
        weakSelf.isRefreshing = NO;
        //3:通知刷新视图，结束刷新
        [weakSelf.collectionView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }];
}
- (void)createRefreshFootView
{
    __weak typeof(self) weakSelf = self;
    [self.collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.page++;
        //上拉加载更多结束
        [weakSelf requestData];
        
        [weakSelf.collectionView reloadData];
        weakSelf.isRefreshing = NO;
        //让footView 结束刷新状态
        [weakSelf.collectionView footerEndRefreshing];
    }];
}
#pragma mark
#pragma mark     - UIPopoverPresentationControllerDelegate代理方法-
//返回UIModalPresentationNone，按照内容控制自己指定的方式popover进行弹出
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark
#pragma mark     - UICollectionView代理方法-

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSouce.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ThirdCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    ThirdPageModelONE *model = _dataSouce[indexPath.row];
    cell.nameLable.text = model.title;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"111.png"]];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ThirdPageModelONE *model = _dataSouce[indexPath.row];
    NSLog(@"++++++%@",model.title);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_contentVC removeObserver:self forKeyPath:@"str"];
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
