//
//  ShoppingCartTool.m
//  仿饿了么加入购物车动画
//
//  Created by 李真 on 2018/3/1.
//  Copyright © 2018年 李真. All rights reserved.
//

#import "ShoppingCartTool.h"

@implementation ShoppingCartTool
+ (void)addToShoppingCartWithGoodsImage:(UIImage *)goodsImage startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint completion:(void (^)(BOOL))completion
{
//    ---------创建shapeLayer-----------
    CAShapeLayer *animationLayer = [[CAShapeLayer alloc]init];
    animationLayer.frame = CGRectMake(startPoint.x - 10, startPoint.y - 10, 20, 20);
    /*
     展示：由layer决定
     layer可以装图片
    */
    animationLayer.contents = (id)goodsImage.CGImage;
//    获取window的最顶层试图控制器
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    UIViewController * parentVC = rootVC;
    while ((parentVC = rootVC.presentedViewController) != nil) {
        rootVC = parentVC;
    }
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
//    添加layer到顶层视图控制器上
    [rootVC.view.layer addSublayer:animationLayer];
    
// -------创建移动轨迹--------//
    UIBezierPath * movePath = [UIBezierPath bezierPath];
    
    [movePath moveToPoint:startPoint];
    [movePath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(200, startPoint.y - 50)];
    //轨迹动画
    CAKeyframeAnimation * pathAnmation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGFloat durationTime = 0.5;//动画时间1s
    pathAnmation.duration = durationTime;
    pathAnmation.removedOnCompletion = NO;
    pathAnmation.fillMode = kCAFillModeForwards;
    /*
     轨迹：由贝塞尔曲线决定
     贝塞尔曲线决定了移动轨迹
     
     */
    pathAnmation.path = movePath.CGPath;
    
//    -----------创建缩小动画----------------
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.duration = 0.5;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
//   添加轨迹动画
    [animationLayer addAnimation:pathAnmation forKey:nil];
    // 添加缩小动画
    [animationLayer addAnimation:scaleAnimation forKey:nil];
    
    //------- 动画结束后执行 -------//
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationLayer removeFromSuperlayer];
        completion(YES);
    });
    
}
@end
