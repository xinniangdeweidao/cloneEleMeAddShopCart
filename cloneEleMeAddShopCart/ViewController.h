//
//  ViewController.h
//  仿饿了么加入购物车动画
//
//  Created by 李真 on 2018/3/1.
//  Copyright © 2018年 李真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+GIF.h"
#import "CartTableViewCell.h"
@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView * shoppingCartImgV;
//@property (nonatomic,strong) UIButton * shoppingCartButton;
@property (nonatomic,strong) UILabel * goodsNumLabel;
@property (nonatomic,strong) UITableView * tabV;
@property (nonatomic,assign) NSTimeInterval lastClickTimeInterval;
@end

