//
//  TransImageTool.m
//  图片操作
//
//  Created by LUOSU on 2019/2/13.
//  Copyright © 2019 LUOSU. All rights reserved.
//

#import "TransImageTool.h"
#define kSCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define kMaxZoom 1.5
@interface TransImageTool ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isTwiceTaping;
@property (nonatomic, assign) BOOL isDoubleTapingForZoom;
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat touchX;
@property (nonatomic, assign) CGFloat touchY;
@property (nonatomic, strong) UIImageView *transImageView;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backView;


@end

static CGRect oldframe;
@implementation TransImageTool

- (void)showImage:(UIImageView *)avatarImageView{
    
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.backView = backgroundView;
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 1;
   
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    self.transImageView = imageView;
 
    
    //[backgroundView addGestureRecognizer: onetap];
     [self draw];
    /*[backgroundView addSubview:imageView];
     
    
//
    [window addSubview:backgroundView];
//
  
//
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transtfromBig:)];
//    doubleTap.numberOfTapsRequired = 2;
//    [backgroundView addGestureRecognizer: doubleTap];
//    [onetap requireGestureRecognizerToFail:doubleTap];
//
    CGFloat imageViewX = 0;
    CGFloat imageViewY = ([UIScreen mainScreen].bounds.size.height - image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2;
    CGFloat imageViewW =  [UIScreen mainScreen].bounds.size.width;
    CGFloat imageViewH = image.size.height * [UIScreen mainScreen].bounds.size.width/image.size.width;

    [UIView animateWithDuration:0.3
                     animations:^{

                         imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);

                         backgroundView.alpha = 1;

                     } completion:^(BOOL finished) {



                     }];
     */
    
}



- (void)hideImage:(UITapGestureRecognizer*)tap{
    NSLog(@"隐藏");
    UIView *backgroundView = tap.view;
    
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         imageView.frame = oldframe;
                         //backgroundView.alpha = 0;
                         self.scrollView.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         [backgroundView removeFromSuperview];
                         [self.scrollView removeFromSuperview];
                         
                     }];
    
}


- (void)transtfromBig:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"双击");
}

- (void)draw
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView = self.transImageView;
    imageView.tag = 1;
    
  
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.maximumZoomScale = 3.0;
    CGFloat ratio = _width / _height * kSCREEN_HEIGHT / kSCREEN_WIDTH;
    CGFloat min = MIN(ratio, 1.0);
    scrollView.minimumZoomScale = min;
    self.scrollView = scrollView;
    
    UITapGestureRecognizer *onetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [self.scrollView addGestureRecognizer:onetap];
    [self.scrollView addSubview:imageView];

    UITapGestureRecognizer *tapImgViewTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandleTwice:)];
    tapImgViewTwice.numberOfTapsRequired = 2;
    tapImgViewTwice.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:tapImgViewTwice];
    [onetap requireGestureRecognizerToFail:tapImgViewTwice];

    
    [window addSubview:self.scrollView];
    UIImage *image = imageView.image;
    CGFloat imageViewX = 0;
    CGFloat imageViewY = ([UIScreen mainScreen].bounds.size.height - image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2;
    CGFloat imageViewW =  [UIScreen mainScreen].bounds.size.width;
    CGFloat imageViewH = image.size.height * [UIScreen mainScreen].bounds.size.width/image.size.width;
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
                         
                         backgroundView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
    
}

#pragma mrak -- UIScrollViewDelegate  --

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    self.currentScale = scale;
    NSLog(@"current scale:%f",scale);
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.transImageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat xcenter = scrollView.center.x;
    CGFloat ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width / 2 : xcenter;
     ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    if(_isDoubleTapingForZoom){
        NSLog(@"taping center");
        xcenter = kMaxZoom * (kSCREEN_WIDTH - _touchX);
        ycenter = kMaxZoom * (kSCREEN_HEIGHT - _touchY);
        if(xcenter > (kMaxZoom - 0.5) * kSCREEN_WIDTH){//放大后左边超界
            xcenter = (kMaxZoom - 0.5) * kSCREEN_WIDTH;
        }else if(xcenter < 0.5 * kSCREEN_WIDTH){ //放大后右边超界
            xcenter = 0.5 * kSCREEN_WIDTH;
        }
        
        if(ycenter > (kMaxZoom - 0.5) * kSCREEN_HEIGHT){//放大后左边超界
            ycenter = (kMaxZoom - 0.5)*kSCREEN_HEIGHT +_offsetY * kMaxZoom;
        }else if(ycenter < 0.5*kSCREEN_HEIGHT){    //放大后右边超界
            ycenter = 0.5*kSCREEN_HEIGHT +_offsetY * kMaxZoom;
        }
        NSLog(@"adjust postion sucess, x:%f,y:%f",xcenter,ycenter);
    }
    [self.transImageView setCenter:CGPointMake(xcenter, ycenter)];
    
}

-(void)tapImgViewHandleTwice:(UIGestureRecognizer *)sender{
    _touchX = [sender locationInView:sender.view].x;
    _touchY = [sender locationInView:sender.view].y;
    if(_isTwiceTaping){
        return;
    }
    _isTwiceTaping = YES;
    
    NSLog(@"tap twice");
    
    if(_currentScale > 1.0){
        _currentScale = 1.0;
        [_scrollView setZoomScale:1.0 animated:YES];
    }else{
        _isDoubleTapingForZoom = YES;
        _currentScale = kMaxZoom;
        [_scrollView setZoomScale:kMaxZoom animated:YES];
    }
    _isDoubleTapingForZoom = NO;
    //延时做标记判断，使用户点击3次时的单击效果不生效。
    [self performSelector:@selector(twiceTaping) withObject:nil afterDelay:0.65];
}
-(void)twiceTaping{

    _isTwiceTaping = NO;
}

@end
