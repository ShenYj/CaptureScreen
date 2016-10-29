//
//  ViewController.m
//  CaptureScreen
//
//  Created by 赵凯 on 16/10/27.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "ViewController.h"

#define KWIDTH self.view.frame.size.width
#define KHEIGHT self.view.frame.size.height

@interface ViewController ()
{
    UIScrollView *scroll;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT)];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.contentSize = CGSizeMake(KWIDTH, KHEIGHT*2);
    [self.view addSubview:scroll];
    
    for (int index = 0; index < 6; index ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, index*(KHEIGHT/3), KWIDTH, (KHEIGHT/3)) ];
        view.backgroundColor =[UIColor colorWithRed:[self getrand] green:[self getrand] blue:[self getrand] alpha:[self getrand]];
        [scroll addSubview:view];
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 40, 80, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"截屏" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(CaptureScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(CGFloat)getrand{
    return (float)(1+arc4random()%99)/100;
}

#pragma mark   ==============截屏方法==============
- (void)CaptureScreen{
    
    UIImage* image = nil;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
    UIGraphicsBeginImageContextWithOptions(scroll.contentSize, YES, [UIScreen mainScreen].scale);
    
    CGPoint savedContentOffset = scroll.contentOffset;
    CGRect savedFrame = scroll.frame;
    scroll.contentOffset = CGPointZero;
    scroll.frame = CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height);
    [scroll.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    scroll.contentOffset = savedContentOffset;
    scroll.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

//指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功，可到相册查看" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert show];
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
