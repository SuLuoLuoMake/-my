//
//  ImageTransCell.m
//  图片操作
//
//  Created by LUOSU on 2019/2/13.
//  Copyright © 2019 LUOSU. All rights reserved.
//

#import "ImageTransCell.h"
#import "TransImageTool.h"

@interface ImageTransCell ()
@property (weak, nonatomic) IBOutlet UIImageView *transImageView;
@property (nonatomic, strong)  TransImageTool *tool;


@end

@implementation ImageTransCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageAction:)];
    [self.transImageView addGestureRecognizer:tapGesture];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setBigImage:(UIImage *)bigImage{
    _bigImage = bigImage;
    self.transImageView.image = self.bigImage;
}

- (void)bigImageAction:(UITapGestureRecognizer *)ges{
    TransImageTool *tool = [[TransImageTool alloc] init];
    self.tool = tool;
    NSLog(@"%@", NSStringFromCGRect(self.transImageView.frame));
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect oldframe = [self.transImageView convertRect:self.transImageView.bounds toView:window];
    [tool showImage:self.transImageView];
}


@end
