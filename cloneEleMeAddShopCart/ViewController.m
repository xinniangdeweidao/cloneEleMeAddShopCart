//
//  ViewController.m
//  仿饿了么加入购物车动画
//
//  Created by 李真 on 2018/3/1.
//  Copyright © 2018年 李真. All rights reserved.
//

#import "ViewController.h"
#import "ShoppingCartTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    tableview
    _tabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, 400, 600) style:UITableViewStylePlain];
    _tabV.delegate = self;
    _tabV.dataSource = self;
    [_tabV registerNib:[UINib nibWithNibName:@"CartTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartTableViewCellID"];
    [self.view addSubview:_tabV];
    
//购物车
    _shoppingCartImgV = [[UIImageView alloc]initWithFrame:CGRectMake(30,self.view.frame.size.height - 80, 60, 60)];
    _shoppingCartImgV.image = [UIImage imageNamed:@"购物车"];
    _shoppingCartImgV.contentMode = UIViewContentModeScaleAspectFit;
     [self.view addSubview:_shoppingCartImgV];
    
//商品数量
    _goodsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingCartImgV.frame) - 15, CGRectGetMinY(_shoppingCartImgV.frame), 20, 20)];
    _goodsNumLabel.textAlignment = 1;
    _goodsNumLabel.textColor = [UIColor whiteColor];
    _goodsNumLabel.backgroundColor = [UIColor redColor];
    _goodsNumLabel.font = [UIFont systemFontOfSize:14];
    _goodsNumLabel.text = @"99";
    _goodsNumLabel.layer.cornerRadius = 10;
    _goodsNumLabel.clipsToBounds = YES;
    [self.view addSubview:_goodsNumLabel];
    
}
///////---------tablview----------/////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCellID" forIndexPath:indexPath];
    [cell.addBtn addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.addBtn.tag = indexPath.row + 1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

/** 加入购物车按钮点击 */
- (void)addButtonClicked:(UIButton *)sender{
    NSInteger btnTag = sender.tag;
    UIButton *  btn = (UIButton *)[self.view viewWithTag:btnTag];
    
//    重点：获取当前点击的cell的按钮相对于self.view的位置，才能准确定位贝塞尔曲线的起点位置
    CartTableViewCell * cell = (CartTableViewCell *)[_tabV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag - 1 inSection:0]];
    CGRect startR = [btn convertRect:cell.addBtn.bounds toView:self.view];
    CGPoint  startP = CGPointMake(startR.origin.x + 30, startR.origin.y);
    
//    贝塞尔曲线的重点位置
    CGPoint endPoint = CGPointMake(_shoppingCartImgV.center.x + 5, _shoppingCartImgV.center.y - 37);
    
    
//    -------开箱动画-------
//  NSObject参数一定要一一对应，否则延迟调用取消不了
//    如果不带selector，则默认取消target对象的所有延迟调用
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideGif) object:nil];
    _shoppingCartImgV.image = [UIImage sd_animatedGIFNamed:@"shopcart"];
     [self performSelector:@selector(hideGif) withObject:nil afterDelay:0.9];
   
    
//    开始画完整的贝塞尔曲线
   
         [ShoppingCartTool addToShoppingCartWithGoodsImage:[UIImage imageNamed:@"add"] startPoint:startP endPoint:endPoint completion:^(BOOL finished) {
             NSLog(@"动画结束了");
            
             //------- 颤抖吧 -------//
             CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
             scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
             scaleAnimation.toValue = [NSNumber numberWithFloat:0.7];
             scaleAnimation.duration = 0.1;
             scaleAnimation.repeatCount = 2; // 颤抖两次
             scaleAnimation.autoreverses = YES;
             scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
             [self.goodsNumLabel.layer addAnimation:scaleAnimation forKey:nil];
         }];

}
- (void)hideGif{
     _shoppingCartImgV.image = [UIImage imageNamed:@"购物车"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
