//
//  DYDataAdapterBase.m
//  IntelligenceResearchReport
//  用于适配曲线图中的各种数据，使得曲线满足各种展示需求
//  Created by datayes on 15/11/26.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYDataAdapterBase.h"
#import "DYChartCandleView.h"
#import "DYIndexPath.h"
#import "DYTools+FloatingPoint.h"

#define MAX_CACHE_SIZE  200

static NSMutableArray *gCache125ResultArray = nil;

@interface DYDataAdapterBase ()

/**
 *	@brief	原始 X 轴上分几格
 */
@property (nonatomic)NSUInteger originalXPartCount;

/**
 *	@brief	原始 X 轴上一个大格分几个小格
 */
@property (nonatomic)NSUInteger originalXSubPartCount;

/**
 *	@brief	原始 Y 轴上分几格
 */
@property (nonatomic)NSUInteger originalYPartCount;

/**
 *	@brief	原始 右侧Y轴上分几格
 */
@property (nonatomic)NSUInteger originalYRightPartCount;

/**
 *	@brief  原始 Y 轴上一个大格分几个小格
 */
@property (nonatomic)NSUInteger originalYSubPartCount;

/**
 *	@brief	原始 右侧Y轴上分几格
 */
@property (nonatomic)NSUInteger originalYRightSubPartCount;

@end

@implementation DY125RuleInputParameters

//

@end

@implementation DYFixDataBy125RuleResult

//

@end

@implementation DY125InputAndResultPair

//

@end

@implementation DYDataAdapterBase

- (id)init
{
    if (self = [super init]) {
        self.adjustMethod = adjustByTranslation;
        _yPartCount = 4;
        _yRightPartCount = 4;
        
        _ySubPartCount = 0;
        _yRightSubPartCount = 0;
        
        _xPartCount = 4;
        _xSubPartCount = 0;
        
//        self.drawYZeroLines = YES;
//        self.yZeroInMiddle = YES;
        
        self.yZeroPosition = MAXFLOAT;
    }
    
    return self;
}

- (void)setXPartCount:(NSUInteger)xPartCount
{
//    if (_originalXPartCount == 0) {
        _originalXPartCount = xPartCount;
//    }
    
    _xPartCount = xPartCount;
}

- (void)setYPartCount:(NSUInteger)yPartCount
{
//    if (_originalYPartCount == 0) {
        _originalYPartCount = yPartCount;
//    }
    
    _yPartCount = yPartCount;
}

- (void)setYRightPartCount:(NSUInteger)yRightPartCount
{
//    if (_originalYRightPartCount == 0) {
        _originalYRightPartCount = yRightPartCount;
//    }
    
    _yRightPartCount = yRightPartCount;
}

- (void)setXSubPartCount:(NSUInteger)xSubPartCount
{
//    if (_originalXSubPartCount == 0) {
        _originalXSubPartCount = xSubPartCount;
//    }
    
    _xSubPartCount = xSubPartCount;
}

- (void)setYSubPartCount:(NSUInteger)ySubPartCount
{
//    if (_originalYSubPartCount == 0) {
        _originalYSubPartCount = ySubPartCount;
//    }
    
    _ySubPartCount = ySubPartCount;
}

- (void)setYRightSubPartCount:(NSUInteger)yRightSubPartCount
{
//    if (_originalYRightSubPartCount == 0) {
        _originalYRightSubPartCount = yRightSubPartCount;
//    }
    
    _yRightSubPartCount = yRightSubPartCount;
}

- (void)adapterData
{
//    DDLogInfo(@"adapterData start ...");
    _xPartCount = _originalXPartCount;
    if (_xPartCount == 0) {
        _xPartCount = 4;
    }
    
    _yPartCount = _originalYPartCount;
    if (_yPartCount == 0) {
        _yPartCount = 4;
    }
    
    _yRightPartCount = _originalYRightPartCount;
    if (_yRightPartCount == 0) {
        _yRightPartCount = 4;
    }
    
    _xSubPartCount = _originalXSubPartCount;
    _ySubPartCount = _originalYSubPartCount;
    _yRightSubPartCount = _originalYRightSubPartCount;
    
    NSUInteger endIndex = 0;
    NSUInteger chartItemCount = [self.chartView countOfChartItemViewForDataAdapter:self];
    for (NSUInteger i = 0 ; i < chartItemCount ; i ++) {
        NSUInteger dataCount = [self.chartView countOfDataForDataAdapter:self atIndex:i];
        if (endIndex < dataCount) {
            endIndex = dataCount;
        }
    }
    
    if (endIndex > 0) {
        [self adapterDataWithStartIndex:0 andEndIndex:endIndex - 1];
    }
    
//    DDLogInfo(@"adapterData finished ...");
}

- (void)adapterDataWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex
{
    [self calcMinMaxValueWithStartIndex:startIndex andEndIndex:endIndex];
    
    if (!self.xAxisIsNotContinueIntIndex) {
        self.minX = startIndex;
        self.maxX = endIndex;
    
        if (self.redesignMaxX) {
            self.maxX = [self getMaxXDataWithMinX:self.minX andMaxV:self.maxX];
        }
    }
    
//    CGFloat chartHeight = (1 - self.bottomGapPercent - self.topGapPercent)*self.canvasHeight;
    CGFloat chartHeight = self.canvasHeight;
    self.originalZoomX = self.canvasWidth/(self.maxX - self.minX);
    self.originalZoomY = chartHeight/(self.maxY - self.minY);
}

- (BOOL)calcMinMaxValueWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex
{
    if (startIndex > endIndex) {
        return NO;
    }
    
    self.minX = MAXFLOAT;
    self.maxX = -MAXFLOAT;
    
    self.minY = MAXFLOAT;
    self.maxY = -MAXFLOAT;
    
    NSUInteger chartItemCount = [self.chartView countOfChartItemViewForDataAdapter:self];
    if (chartItemCount <= 0) {
        self.minX = 0;
        self.maxX = 0;
        
        self.minY = 0;
        self.maxY = 0;
        return NO;
    }
    
    self.minYArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.maxYArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.minXArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.maxXArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.startYArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    
    BOOL hitData = NO;
    for (NSUInteger i = 0; i < chartItemCount ; i ++) {
        CGFloat minXOfChartItemView = MAXFLOAT;
        CGFloat maxXOfChartItemView = -MAXFLOAT;
        CGFloat minYOfChartItemView = MAXFLOAT;
        CGFloat maxYOfChartItemView = -MAXFLOAT;
        
        NSRange validDataRange = [self.chartView rangeOfValidDataForDataAdapter:self atIndex:i];
        for (NSUInteger j = validDataRange.location ; j < validDataRange.location + validDataRange.length ; j ++) {
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:j inSection:i];
            
            id dataValue = [self.chartView dataValueForDataAdapter:self
                                                        atIndexPath:indexPath];
            id dataXValue = @(j);
            if ([self.chartView respondsToSelector:@selector(dataXValueForDataAdapter:atIndexPath:)]) {
                dataXValue = [self.chartView dataXValueForDataAdapter:self atIndexPath:indexPath];
            }
            
            if (dataValue==nil) {
//                self.minY = 0;
//                self.maxY = 0;
                return NO;
            }
            
            if (j == startIndex) {
                [self.startYArray addObject:dataValue];
            }
            
            if ([dataValue isKindOfClass:[NSNumber class]]) {
                CGFloat yValue = [dataValue floatValue];
                CGFloat xValue = [dataXValue floatValue];
                
                if (yValue < -MAXFLOAT/2) {
                    continue;
                }
                if (yValue > self.maxY) {
                    self.maxY = yValue;
                }
                if (yValue < self.minY) {
                    self.minY = yValue;
                }
                if (xValue > self.maxX) {
                    self.maxX = xValue;
                }
                if (xValue < self.minX) {
                    self.minX = xValue;
                }
                
                if (yValue > maxYOfChartItemView) {
                    maxYOfChartItemView = yValue;
                }
                if (yValue < minYOfChartItemView) {
                    minYOfChartItemView = yValue;
                }
                if (xValue > maxXOfChartItemView) {
                    maxXOfChartItemView = xValue;
                }
                if (xValue < minXOfChartItemView) {
                    minXOfChartItemView = xValue;
                }
                
                hitData = YES;
            }
            else if ([dataValue isKindOfClass:[DYChartCandleDataItem class]]) {
                DYChartCandleDataItem* dataItem = dataValue;
                
                if (dataItem.highValue > self.maxY) {
                    self.maxY = dataItem.highValue;
                }
                if (dataItem.lowValue < self.minY) {
                    self.minY = dataItem.lowValue;
                }
                if (dataItem.xPosition > self.maxX) {
                    self.maxX = dataItem.xPosition;
                }
                if (dataItem.xPosition < self.minX) {
                    self.minX = dataItem.xPosition;
                }
                
                if (dataItem.highValue > maxYOfChartItemView) {
                    maxYOfChartItemView = dataItem.highValue;
                }
                if (dataItem.lowValue < minYOfChartItemView) {
                    minYOfChartItemView = dataItem.lowValue;
                }
                if (dataItem.xPosition > maxXOfChartItemView) {
                    maxXOfChartItemView = dataItem.xPosition;
                }
                if (dataItem.xPosition < minXOfChartItemView) {
                    minXOfChartItemView = dataItem.xPosition;
                }
                
                hitData = YES;
            }
        }
        
        [self.minXArray addObject:@(minXOfChartItemView)];
        [self.maxXArray addObject:@(maxXOfChartItemView)];
        
        if (minYOfChartItemView == maxYOfChartItemView) {
            minYOfChartItemView -= .2;
            maxYOfChartItemView += .2;
        }
        [self.minYArray addObject:@(minYOfChartItemView)];
        [self.maxYArray addObject:@(maxYOfChartItemView)];
    }
    
    if (!hitData) {
        self.minY = 0;
        self.maxY = 0;
    }
    
    // 避免除数为0
    if (self.minY == self.maxY) {
        self.minY -= .02 * fabs(self.minY);
        self.maxY += .02 * fabs(self.minY);
    }
    
    if (self.topGapPercent + self.bottomGapPercent > 0 &&
        self.topGapPercent + self.bottomGapPercent < 1 &&
        self.maxY != .0 && self.minY != .0) {
        self.maxY += self.topGapPercent*(self.maxY - self.minY);
        CGFloat tempMinY = self.minY;
        tempMinY -= self.bottomGapPercent*(self.maxY - self.minY);
        if (tempMinY < 0.0 && self.minY >= 0.0) {
            // 调整引起跨0时，不调整
        }
        else
        {
            self.minY = tempMinY;
        }
    }
    
    // 需要画Y值为0的线
    if (self.drawYZeroLines || self.maxY*self.minY < 0) {
        // 需要把Y值为0的线画在中间
        if (self.yZeroInMiddle) {
            if (fabs(self.maxY) > fabs(self.minY)) {
                self.minY = -self.maxY;
            }
            else
            {
                self.maxY = -self.minY;
            }
        }
        else
        {
            // 所有点全大于0
            if (self.minY >= 0) {
                self.minY = 0;
            }
            else if (self.maxY <= 0)
            {
                self.maxY = 0;
            }
            else
            {
                if (_yPartCount <= 1) {
                    _yPartCount = 3;
                }
                
                if (self.notFixDataWith125Rule) {
                    // 125法则如果当中有0，会把0轴放到某个刻度上
                    [self putYZeroLine];
                }
            }
        }
    }
    
    return YES;
}

- (void)putYZeroLine
{
    if (self.maxY*self.minY < 0) {
        // 找到接近0的虚线Y坐标，让Y值为0的线移到这根线上
        CGFloat distance = (self.maxY - self.minY)/(_yPartCount - 1);
        CGFloat nearPostion = 0;
        for (int i = 0 ; i < _yPartCount; i ++) {
            // 找一根离0最近的
            if (fabs(self.minY + i*distance) <= distance/2) {
                nearPostion = self.minY + i*distance;
                break;
            }
        }
        
        if (nearPostion < 0) {
            self.minY -= distance + nearPostion;
            self.maxY -= nearPostion;
            
            _yPartCount += 1;
        }
        else if (nearPostion > 0)
        {
            self.minY -= nearPostion;
            self.maxY += distance - nearPostion;
            
            _yPartCount += 1;
        }
    }
}

+ (DYFixDataBy125RuleResult*)fixDataBy125RuleWithMinValue:(CGFloat)minValue
                                              andMaxValue:(CGFloat)maxValue
                                     andDefaultYPartCount:(NSInteger)yPartCount
                                      andFixPartCountFlag:(BOOL)isFix
                                       andIsYZeroInMiddle:(BOOL)isYZeroInMiddleFlag
                                          andCanvasHeight:(CGFloat)canvasHeight
{
    DYFixDataBy125RuleResult* result = [DYDataAdapterBase fetch125ResultWithMinValue:minValue
                                                                         andMaxValue:maxValue
                                                                andDefaultYPartCount:yPartCount
                                                                 andFixPartCountFlag:isFix
                                                                  andIsYZeroInMiddle:isYZeroInMiddleFlag
                                                                     andCanvasHeight:canvasHeight];
    
    if (result != nil) {
        return result;
    }
    
    
    result = [DYFixDataBy125RuleResult new];
    result.yZeroPosition = MAXFLOAT;
    result.yPartCount = yPartCount;
    
    if (minValue > maxValue) {
        result.minValue = maxValue;
        result.maxValue = minValue;
        
        minValue = result.minValue;
        maxValue = result.maxValue;
    }
    else {
        result.minValue = minValue;
        result.maxValue = maxValue;
    }
    
    if (minValue <= -MAXFLOAT/2 ||
        maxValue >= MAXFLOAT/2) {
        result.minValue = -.2;
        result.maxValue = .2;
        
        return result;
    }
    
    if (yPartCount < 2) {
        return result;
    }
    
    CGFloat totalGap = maxValue - minValue;
    
    // 如果y为0的线在中间，那么间隔应该是偶数个
    if (isYZeroInMiddleFlag && yPartCount%2 != 0) {
        yPartCount += 1;
    }
    
    // NOTE:yPartCount目前的意思是，Y轴上有多少个刻度，所以这里要减1
    CGFloat oneGap = totalGap/(yPartCount - 1);
    
    CGFloat calcOneGap = oneGap;
    CGFloat calcMinValue = minValue;
    CGFloat calcMaxValue = maxValue;
    
    // 先将间隔缩放到1-10的范围
    NSInteger cycleCount = 0;
    BOOL divideFlag = YES;
    if (calcOneGap > 1) {
        while (calcOneGap > 10) {   // 等于10时，为了不让图形振幅变小，让他去>5那档，所以不再缩小了
            calcOneGap /= 10;
            calcMinValue /= 10;
            calcMaxValue /= 10;
            cycleCount ++;
        }
    }
    else
    {
        if (calcOneGap > 0) {
            while (calcOneGap <= 1) {   // 等于1时，为了不让图形振幅变小，让他去>5那档，所以继续放大成10
                divideFlag = NO;
                calcOneGap *= 10;
                calcMinValue *= 10;
                calcMaxValue *= 10;
                cycleCount ++;
            }
        }
    }
    
    // 匹配 5，2，1，得到推荐的间隔
    CGFloat fixedGap = 1;
    if (calcOneGap > 5) {
        fixedGap = 10;
    }
    else if (calcOneGap > 2) {
        fixedGap = 5;
    }
    else {
        fixedGap = 2;
    }
    
    // 计算得到最新的max，min值，使得坐标为1，2，5这几个数
    
    // 如果Y为0的点必须在Y轴中间的话
    if (isYZeroInMiddleFlag) {
        if (divideFlag) {
            for (int i = 0 ; i < cycleCount ; i ++) {
                fixedGap *= 10;
            }
        }
        else
        {
            for (int i = 0 ; i < cycleCount ; i ++) {
                fixedGap /= 10;
            }
        }
        
        calcMinValue = 0;
        while (calcMinValue > minValue) {
            calcMinValue -= fixedGap;
        }
        
        minValue = calcMinValue;
        maxValue = -minValue;
        
        if (isFix) {
            // 检查上方是否太空（多出一行，数据完全没有画到这个区间）
            while (result.maxValue + fixedGap < maxValue) {
                yPartCount --;
                maxValue -= fixedGap;
                minValue += fixedGap;
            }
        }
    }
    else
    {
        // 得到新min值，新min值恒比min值小
        NSInteger unFixedGap = (NSInteger)fixedGap;
        NSInteger nMinValue = (NSInteger)floor(calcMinValue);
        
        if (nMinValue < 0) {
            if (-nMinValue < unFixedGap) {
                // 最小值为负数，而且绝对值小于Gap，则直接等于-Gap，此时能保证0轴在轴线上
                nMinValue = - unFixedGap;
            }
            else if (-nMinValue > unFixedGap)
            {
                // 最小值为负数，而且绝对值大于Gap，先求出当前最小值与Gap的距离
                NSInteger tempValue = -nMinValue%unFixedGap;
                if (tempValue != 0) {
                    // 再找出目标最小值与上一个gap的距离
                    NSInteger modNumber = unFixedGap - tempValue;
                    nMinValue -= modNumber;
                }
            }
        }
        else
        {
            NSInteger modNumber = nMinValue % unFixedGap;
            nMinValue -= modNumber;
        }
        
        
        // 得到min下方最近的一根线，这根线满足1，2，5规则
        minValue = nMinValue;
        maxValue = nMinValue + fixedGap*yPartCount;
        
        // 值回归原单位
        if (divideFlag) {
            for (int i = 0 ; i < cycleCount ; i ++) {
                minValue *= 10;
                maxValue *= 10;
                fixedGap *= 10;
            }
        }
        else
        {
            for (int i = 0 ; i < cycleCount ; i ++) {
                minValue /= 10;
                maxValue /= 10;
                fixedGap /= 10;
            }
        }
        
        if (isFix) {
            // 检查上方是否太空（多出一行，数据完全没有画到这个区间）
            while (result.maxValue + fixedGap < maxValue) {
                yPartCount --;
                maxValue -= fixedGap;
            }
        }
        
        // 寻找Y轴上值为0的刻度的位置
        NSInteger findZero = nMinValue;
        for (NSInteger i = 0 ; i < yPartCount ; i ++) {
            if (findZero == 0) {
                result.yZeroPosition = canvasHeight*(yPartCount - i)/yPartCount;
                break;
            }
            findZero += unFixedGap;
        }
    }
    
    result.minValue = minValue;
    result.maxValue = maxValue;
    result.yPartCount = yPartCount;
    
    DY125RuleInputParameters *inputParam = [DY125RuleInputParameters new];
    inputParam.minValue = minValue;
    inputParam.maxValue = maxValue;
    inputParam.yPartCount = yPartCount;
    inputParam.isFix = isFix;
    inputParam.isYZeroInMiddleFlag = isYZeroInMiddleFlag;
    inputParam.canvasHeight = canvasHeight;
    [self cache125ResultWithResult:result andInputParameter:inputParam];
    
//    DDLogInfo(@"fixDataBy125RuleWithMinValue minValue is %f and maxValue is %f", result.minValue, result.maxValue);
    return result;
}

+ (NSMutableArray *)gCache125ResultArray
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gCache125ResultArray = [NSMutableArray arrayWithCapacity:MAX_CACHE_SIZE];
    });
    
    return gCache125ResultArray;
}

+ (void)cache125ResultWithResult:(DYFixDataBy125RuleResult *)result andInputParameter:(DY125RuleInputParameters *)inputParameter
{
    @synchronized ([DYDataAdapterBase gCache125ResultArray]) {
        while ([[DYDataAdapterBase gCache125ResultArray] count] >= MAX_CACHE_SIZE) {
            [[DYDataAdapterBase gCache125ResultArray] removeLastObject];
        }
        
        DY125InputAndResultPair *pair = [DY125InputAndResultPair new];
        pair.inputParam = inputParameter;
        pair.result = result;
        [[DYDataAdapterBase gCache125ResultArray] insertObject:pair atIndex:0];
    }
}

+ (DYFixDataBy125RuleResult *)fetch125ResultWithMinValue:(CGFloat)minValue
                                             andMaxValue:(CGFloat)maxValue
                                    andDefaultYPartCount:(NSInteger)yPartCount
                                     andFixPartCountFlag:(BOOL)isFix
                                      andIsYZeroInMiddle:(BOOL)isYZeroInMiddleFlag
                                         andCanvasHeight:(CGFloat)canvasHeight
{
    @synchronized ([DYDataAdapterBase gCache125ResultArray]) {
        for (DY125InputAndResultPair *pair in [DYDataAdapterBase gCache125ResultArray]) {
            DY125RuleInputParameters *inputParam = pair.inputParam;
            if ([DYTools compareFloatNumber1:inputParam.minValue withFloatNumber2:minValue] == eEqual &&
                [DYTools compareFloatNumber1:inputParam.maxValue withFloatNumber2:maxValue] == eEqual &&
                [DYTools compareFloatNumber1:inputParam.canvasHeight withFloatNumber2:canvasHeight] == eEqual &&
                inputParam.yPartCount == yPartCount &&
                inputParam.isFix == isFix &&
                inputParam.isYZeroInMiddleFlag == isYZeroInMiddleFlag) {
                return pair.result;
            }
        }
        
        return nil;
    }
}

- (CGFloat)getMaxXDataWithMinX:(CGFloat)minValue andMaxV:(CGFloat)maxValue
{
    NSUInteger nMax = (self.maxX - self.minX);
    
    NSUInteger count = 0;
    while (nMax % _xPartCount) {
        nMax ++;
        count ++;
    }
    
    return self.maxX + count;
}

- (CGFloat)xZoomValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.originalZoomX;
}

- (CGFloat)yZoomValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.originalZoomY;
}

- (CGFloat)yOffsetForChartItemViewAtIndex:(NSUInteger)index
{
    return 0;//self.bottomGapPercent*self.canvasHeight;
}

- (CGFloat)yRightZoomValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.originalRightZoomY;
}

- (CGFloat)yRightOffsetForChartItemViewAtIndex:(NSUInteger)index
{
    return 0;//self.bottomGapPercent*self.canvasHeight;
}

- (CGFloat)yMinValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.minY;
}

- (CGFloat)yRightMinValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.minY;
}

- (void)setJustYPartCount:(NSInteger)yPartCount;
{
    _yPartCount = yPartCount;
}

- (void)setJustYRightPartCount:(NSInteger)yRightPartCount
{
    _yRightPartCount = yRightPartCount;
}
@end
