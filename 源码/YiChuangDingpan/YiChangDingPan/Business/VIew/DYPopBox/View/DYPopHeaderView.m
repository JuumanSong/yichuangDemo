//
//  DYPopHeaderView.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPopHeaderView.h"
#import "DYBasePopupView.h"
#import "DYItem.h"
#import "DYPopBoxHeader.h"
#import "DYYCStocksMoveService.h"
#import "DYYCIndustryListService.h"

@interface DYPopHeaderView()<DYDropDownBoxDelegate,DYBasePopupViewDelegate>

@property (nonatomic, strong) NSMutableArray <DYItem *>*itemArray;
@property (nonatomic, strong) NSMutableArray <DYBasePopupView *>*symbolArray;  /*当成一个队列来标记那个弹出视图**/
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, strong) DYBasePopupView *popupView;
@property (nonatomic, strong) DYDropDownBox *dropDownBox;
@property (nonatomic, assign) BOOL isAnimation;                               /*防止多次快速点击**/

@end

@implementation DYPopHeaderView
{
    CAShapeLayer *shapeLayer;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DYAppearanceColorFromHex(0x3B3A3F, 1);
        self.dropDownBoxArray = [NSMutableArray array];
        self.itemArray = [NSMutableArray array];
        self.symbolArray = [NSMutableArray arrayWithCapacity:1];
        
        
    }
    return self;
}


- (void)reload {
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsIncomBoBoxView:)]) {
        count = [self.dataSource numberOfColumnsIncomBoBoxView:self];
    }
    CGFloat margin = (iPhone5_5s || iPhone4_4s) ? 4 : 7;
    CGFloat width = (self.width - margin * 5)/count;
    if ([self.dataSource respondsToSelector:@selector(comBoBoxView:infomationForColumn:)]) {
        for (NSUInteger i = 0; i < count; i++) {
            DYItem *item = [self.dataSource comBoBoxView:self infomationForColumn:i];
            
            DYDropDownBox *dropBox = [[DYDropDownBox alloc] initWithFrame:CGRectMake(i*width + margin*(i + 1), 1, width, self.height) titleName:item.title];
            dropBox.tag = i;
            // 配置默认值
            if (i == 0) {
                [self showSelectItemWithType:DYItemMarkTypeViewDisplayTypeNormal Block:^(NSArray *arr) {
                    NSString *title = arr.firstObject;
                    if (title.length == 0) {
                        [dropBox updateTitleContent:@"全A股"];
                        return ;
                    }
                    if (title.length) {[dropBox updateTitleContent:title];}
                }];
                
                
            } else if (i == 1) {
                [self showSelectItemWithType:DYItemMarkTypeViewDisplayTypeindustry Block:^(NSArray *arr) {
                    NSString *title = arr.firstObject;
                    if (title.length == 0) {
                        [dropBox updateTitleContent:@"行业板块"];
                        return ;
                    }
                    if (arr.count == 1) {
                        [dropBox updateTitleContent:title];
                    }else if (arr.count > 1) {
                        
                        [dropBox updateTitleContent:[NSString stringWithFormat:@"%@...",title]];
                    }
                }];
                
            }
            dropBox.delegate = self;
            [self addSubview:dropBox];
            [self.dropDownBoxArray addObject:dropBox];
            [self.itemArray addObject:item];
        }
        
        //
    }
//    [self _addLine];
}

// 显示默认配置
- (void)showSelectItemWithType:(DYItemMarkTypeViewDisplayType)type Block:(void(^)(NSArray *arr))Block {
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *arr = [NSMutableArray array];
        id data = [[DYYCStocksMoveService shareInstance] getLocalSaveSettingDataType:type];
        
        if (!data) {
            Block(arr);
            return;
        }
        if (type == DYItemMarkTypeViewDisplayTypeNormal) {
            NSString *selectName = (NSString *)data;
            [arr addObject:selectName];
        }
        else {
            NSArray *industryArr = (NSArray *)data;
            for (NSString *ID in industryArr) {
                NSString *selectName = [[DYYCIndustryListService shareInstance] getIndustryNameWithID:ID];
                [arr addObject:selectName ?: @""];
            }
        }
        Block(arr.copy);
    });
    
}

- (void)dimissPopView {
    if (self.popupView.superview) {
        [self.popupView dismissWithOutAnimation];
    }
}

#pragma mark - Private Method
/****
- (void)_addLine {
    self.topLine = [CALayer layer];
    self.topLine.frame = CGRectMake(0, 0 , self.width, 1.0/scale);
    self.topLine.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3].CGColor;
    [self.layer addSublayer:self.topLine];
    
    self.bottomLine = [CALayer layer];
    self.bottomLine.frame = CGRectMake(0, self.height - 4.0/scale , self.width, 4.0/scale);
    self.bottomLine.backgroundColor = [UIColor darkGrayColor].CGColor;
    [self.layer addSublayer:self.bottomLine];
}
**/
- (void)addBorderLineWithFillColor:(UIColor *)fillColor view:(UIView *)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setFillColor:[fillColor CGColor]];
    [shapeLayer setStrokeColor:[[UIColor darkTextColor] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // Setup the path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //画左边实线
    [path moveToPoint:CGPointMake(0, view.frame.size.height)];
    [path addLineToPoint:CGPointZero];
    
    // 画上实线
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(view.frame.size.width, 0)];
    
    // 画右实线
    [path moveToPoint:CGPointMake(view.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(view.frame.size.width, view.frame.size.height)];
    
    
    [shapeLayer setPath:path.CGPath];
    
    [view.layer addSublayer:shapeLayer];
}

- (void)addBorderLineWithFrameX:(CGFloat)orginX sizeW:(CGFloat)sizeW {
    self.bottomLine.hidden = YES;
    [shapeLayer removeFromSuperlayer];
    shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setFillColor:[[UIColor darkGrayColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor darkGrayColor] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // Setup the path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //画下实线
    [path moveToPoint:CGPointMake(0, self.size.height)];
    [path addLineToPoint:CGPointMake(orginX, self.size.height)];
    
    [path moveToPoint:CGPointMake(orginX + sizeW, self.size.height)];
    [path addLineToPoint:CGPointMake(self.width, self.size.height)];
    
    
    [shapeLayer setPath:path.CGPath];
    
    [self.layer addSublayer:shapeLayer];
}

#pragma mark - MMDropDownBoxDelegate
- (void)didTapDropDownBox:(DYDropDownBox *)dropDownBox atIndex:(NSUInteger)index {
    if (index == 3) {
        if ([self.delegate respondsToSelector:@selector(pushToSetViewController)]) {
            [self.delegate pushToSetViewController];
        }
        return;
    }
    if (self.isAnimation == YES) return;

    //点击后先判断symbolArray有没有标示
    if (self.symbolArray.count) {
        //移除
        DYBasePopupView * lastView = self.symbolArray.firstObject;
        if (lastView.tag == index) return;
        self.bottomLine.hidden = NO;
        [lastView dismiss];
        [self.symbolArray removeAllObjects];

    }

    DYDropDownBox *box = self.dropDownBoxArray[index];
    self.dropDownBox = box;
//    [self addBorderLineWithFillColor:[UIColor darkGrayColor] view:box];
    for (int i = 0; i < self.dropDownBoxArray.count; i++) {
        DYDropDownBox *currentBox  = self.dropDownBoxArray[i];
        [currentBox updateTitleState:(i == index)];

    }
    self.isAnimation = YES;
    // 重新绘制边框
    [self addBorderLineWithFrameX:box.origin.x sizeW:box.size.width];
    //配置显示popupView
    DYItem *item = self.itemArray[index];
    DYBasePopupView *popupView = [DYBasePopupView getSubPopupView:item];
    popupView.tag = index;
    popupView.backgroundColor = DYAppearanceColor(@"H18", 1.0);
    popupView.orginX = box.origin.x;
    popupView.sizeW = box.size.width;
    popupView.delegate = self;
    self.popupView = popupView;
    CGRect frame = self.frame;
    frame.origin.y = frame.origin.y;
    [popupView popupViewFromSourceFrame:frame superView:self.baseView completion:^{
        self.isAnimation = NO;
    }];
    [self.symbolArray addObject:popupView];

}

#pragma DYBasePopupViewDelegate

- (void)popupView:(DYBasePopupView *)popupView didSelectedItem:(NSArray *)arr {
    
    if (arr.count == 1) {
        NSString *title = arr[0];
        [self.dropDownBox updateTitleContent:title];
    }
    else if (arr.count > 1) {
        NSString *title = arr[0];
        
        [self.dropDownBox updateTitleContent:[NSString stringWithFormat:@"%@...",title]];
    }
    else {
        [self.dropDownBox reSetHeaderTitle];
    }
}

- (void)popupView:(DYBasePopupView *)popupView didSelected:(BOOL)isSelected {
    
    [self.dropDownBox updateSelectState:isSelected];
}

- (void)popupViewWillDismiss:(DYBasePopupView *)popupView {
    self.bottomLine.hidden = NO;
    [self.symbolArray removeAllObjects];
    for (DYDropDownBox *currentBox in self.dropDownBoxArray) {
        [currentBox updateTitleState:NO];
    }
    if (self.popupView.superview) {
        [self.popupView dismissWithOutAnimation];
    }
}
@end
