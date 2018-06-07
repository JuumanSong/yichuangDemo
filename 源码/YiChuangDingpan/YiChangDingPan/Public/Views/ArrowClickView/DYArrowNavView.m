//
//  DYArrowNavView.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/27.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYArrowNavView.h"

@interface DYArrowNavView()
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSMutableArray *midLineArr;
@end

@implementation DYArrowNavView

//初始化
- (id)initWithArr:(NSArray *)arr AndClickedBlock:(DataBlock)block {
    return [self initWithArr:arr
             AndClickedBlock:block
                   withImage:nil
                    selImage:nil];
}

//初始化
- (id)initWithArr:(NSArray *)arr
  AndClickedBlock:(DataBlock)block
        withImage:(UIImage *)image
         selImage:(UIImage *)selImage {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor=DYAppearanceColor(@"W1", 1.0);
        
        self.btnArr=[[NSMutableArray alloc]init];
        self.midLineArr = [[NSMutableArray alloc]init];
        
        for(int i=0;i<arr.count;i++){
            DYArrowButton *btn=[[DYArrowButton alloc]init];
            [btn setImageViewImage:image selectedImage:selImage];
            btn.tag = i;
            btn.label.text = arr[i];
            WS(weakSelf);
            [btn arrowButtonClick:^(id data) {
                DYArrowButton *tempBtn = data;
                if (tempBtn.selected) {
                    [weakSelf clearAnother:tempBtn.tag];
                }
                block(data);
            }];
            [self.btnArr addObject:btn];
            [self addSubview:btn];
            
            if (i != arr.count -1) {
                UIView *line = [[UIView alloc]init];
                line.backgroundColor = DYAppearanceColor(@"H2", 1);
                [self.midLineArr addObject:line];
                [self addSubview:line];
            }
        }
        
        self.bottomLine = [[UIView alloc]init];
        self.bottomLine.backgroundColor = DYAppearanceColor(@"H2", 1);
        [self addSubview:self.bottomLine];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    NSInteger height = rect.size.height;
    CGFloat avgWidth = rect.size.width/self.btnArr.count;
    
    for(int i = 0;i<self.btnArr.count;i++){
        UIButton *btn = self.btnArr[i];
        btn.frame = CGRectMake(i*avgWidth, 0, avgWidth, height);
        
        if (i != self.btnArr.count -1) {
            UIView *line = self.midLineArr[i];
            line.frame = CGRectMake(CGRectGetMaxX(btn.frame), 0, 0.5, height);
        }
    }
    
    self.bottomLine.frame = CGRectMake(0, height-1,rect.size.width, 0.5);
}

- (void)changeBottomLineFrameToTop {
    self.bottomLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
}

- (void)hideMidLine:(BOOL)hide {
    for (int i = 0; i < self.midLineArr.count; i++) {
        UIView *line = self.midLineArr[i];
        line.hidden = hide;
    }
}

- (void)hideBottomLine:(BOOL)hide {
    self.bottomLine.hidden = hide;
}

- (void)clearAnother:(NSInteger)index{
    for (DYArrowButton *tempBtn in self.btnArr) {
        if (tempBtn.tag != index) {
            [tempBtn setBtnSelected:NO];
        }
    }
}

- (void)clearSelected {
    for (DYArrowButton *tempBtn in self.btnArr) {
        [tempBtn setBtnSelected:NO];
    }
}

- (void)setText:(NSString *)string
        AtIndex:(NSInteger)index {
    
    if (self.btnArr.count > index) {
        DYArrowButton *btn = self.btnArr[index];
        btn.label.text = string?string:@"";
    }
}

//设置字体样式
- (void)setLabelFont:(UIFont *)font
               color:(UIColor *)color
       selectedColor:(UIColor*)selectColor {
    for (DYArrowButton *tempBtn in self.btnArr) {
        [tempBtn setLabelFont:font color:color selectedColor:selectColor];
    }
}

@end
