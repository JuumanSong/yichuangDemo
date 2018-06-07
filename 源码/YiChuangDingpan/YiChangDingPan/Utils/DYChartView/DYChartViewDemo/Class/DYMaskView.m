//
//  DYMaskView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYMaskView.h"
#import "DYChartItemView.h"
#import "DYChartViewCommonDef.h"
#import "DYAppearance.h"
#import "DYTools.h"

#define DATE_SOURCE_KEY     @"dataSource"
#define TAG_KEY             @"tag"
#define DELEGATE_KEY        @"delegate"

#define TOUCH_TOLERANCE_RANGE   20.0f

@interface DYMaskView ()
{
}
@property (nonatomic)CGFloat lastXPosition; // 上次手指的位置
@property (nonatomic)BOOL isTouchFlag;
@property (nonatomic)CGFloat xOfLongPressPoint1;    // 长按第一个点
@property (nonatomic)CGFloat xOfLongPressPoint2;    // 长按第二个点

@end

@implementation DYMaskView

- (void)setIsTouchFlag:(BOOL)isTouchFlag
{
    _isTouchFlag = isTouchFlag;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setLineColor:DYAppearanceColor(@"W1", 1.0)];
        [self setPointColor:DYAppearanceColor(@"W1", 1.0)];
        [self setShowMask:eDYMaskViewShowAll];
        [self setTouchEventsMask:eDYTouchStateAll];// ^ eTouchStateTwoFingersLongPress];
        [self addPanGestureRecognizer];
        self.lastXPosition = -1;
        self.tipTextGap = -1;
        self.tipsBackgroundColor = DYAppearanceColor(@"H1", 1.0);
        self.tipsColor = DYAppearanceColor(@"H9", 1.0);
        self.tipsFont = DYAppearanceFont(@"T0");
    }
    return self;
}

- (int)addDataSource:(id<DYMaskViewDataSource>)dataSource
{
    NSMutableArray* mArray = [NSMutableArray arrayWithArray:self.myDataSources];
    
    NSUInteger tag = 0;
    if ([mArray count] <= 0) {
        tag = 1;
    }
    else
    {
        tag = [[[mArray lastObject] objectForKey:TAG_KEY] intValue] + 1;
    }
    [mArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:dataSource, DATE_SOURCE_KEY, [NSNumber numberWithUnsignedInteger:tag], TAG_KEY, nil]];
    self.myDataSources = mArray;
    
    return (int)tag;
}

- (void)deleteDataSourceByTag:(int)tag
{
    NSMutableArray* mArray = [NSMutableArray arrayWithArray:self.myDataSources];
    for (NSDictionary* dic in mArray) {
        if ([[dic objectForKey:TAG_KEY] intValue] == tag) {
            [mArray removeObject:dic];
            break;
        }
    }
    
    self.myDataSources = mArray;
}

- (void)deleteAllDataSource
{
    self.myDataSources = nil;
}

- (void)redrawMaskView
{
    self.eTouchState = eDYTouchStateOneFingerSingleTap;
    [self setNeedsDisplay];
}

- (void)setTouchEventsMask:(NSUInteger)touchEventsMask
{
    _touchEventsMask = touchEventsMask;
    
    for (UIGestureRecognizer* gestureRecognizer in self.allGestureRecognizers) {
        [self removeGestureRecognizer:gestureRecognizer];
    }
    
    [self addPanGestureRecognizer];
}

- (void)addPanGestureRecognizer
{
    NSMutableArray* mArray = [NSMutableArray array];
    //    static dispatch_once_t predicate;
    //    dispatch_once(&predicate, ^
    {
        // 单指滑动
        UIPanGestureRecognizer *panGestureRecognizer = nil;
        if (self.touchEventsMask & eDYTouchStatePan) {
            panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            panGestureRecognizer.delegate = self;
            panGestureRecognizer.cancelsTouchesInView = NO;
            [self addGestureRecognizer:panGestureRecognizer];
            [mArray addObject:panGestureRecognizer];
        }
        
        // 单指敲击
        UITapGestureRecognizer* singleTapGestureRecognizer =  nil;
        if (self.touchEventsMask & eDYTouchStateOneFingerSingleTap) {
            singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            singleTapGestureRecognizer.numberOfTouchesRequired = 1;
            singleTapGestureRecognizer.cancelsTouchesInView = NO;
            singleTapGestureRecognizer.delegate = self;
            [self addGestureRecognizer:singleTapGestureRecognizer];
            [mArray addObject:singleTapGestureRecognizer];
        }
        
        // 单指双击
        UITapGestureRecognizer* doubleTapGestureRecognizer = nil;
        if (self.touchEventsMask & eDYTouchStateOneFingerDoubleTap) {
            doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            doubleTapGestureRecognizer.numberOfTapsRequired = 2;
            doubleTapGestureRecognizer.numberOfTouchesRequired = 1;
            doubleTapGestureRecognizer.cancelsTouchesInView = NO;
            doubleTapGestureRecognizer.delegate = self;
            [self addGestureRecognizer:doubleTapGestureRecognizer];
            [mArray addObject:doubleTapGestureRecognizer];
        }
        
        // 双指单击
        UITapGestureRecognizer* singleTapWithTwoFingersGestureRecognizer = nil;
        if (self.touchEventsMask & eDYTouchStateTwoFingersSingleTap) {
            singleTapWithTwoFingersGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapWithTwoFingers:)];
            singleTapWithTwoFingersGestureRecognizer.numberOfTapsRequired = 1;
            singleTapWithTwoFingersGestureRecognizer.numberOfTouchesRequired = 2;
            singleTapWithTwoFingersGestureRecognizer.cancelsTouchesInView = NO;
            singleTapWithTwoFingersGestureRecognizer.delegate = self;
            [self addGestureRecognizer:singleTapWithTwoFingersGestureRecognizer];
            [mArray addObject:singleTapWithTwoFingersGestureRecognizer];
        }
        
        // 双指双击
        UITapGestureRecognizer* doubleTapWithTwoFingersGestureRecognizer = nil;
        if (self.touchEventsMask & eDYTouchStateTwoFingersDoubleTap) {
            doubleTapWithTwoFingersGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapWithTwoFingers:)];
            doubleTapWithTwoFingersGestureRecognizer.numberOfTapsRequired = 2;
            doubleTapWithTwoFingersGestureRecognizer.numberOfTouchesRequired = 2;
            doubleTapWithTwoFingersGestureRecognizer.cancelsTouchesInView = NO;
            doubleTapWithTwoFingersGestureRecognizer.delegate = self;
            [self addGestureRecognizer:doubleTapWithTwoFingersGestureRecognizer];
            [mArray addObject:doubleTapWithTwoFingersGestureRecognizer];
        }
        
        // 单指长按
        UILongPressGestureRecognizer* longPressGestureRecognizer = nil;
        if (self.touchEventsMask & eDYTouchStateOneFingerLongPress) {
            longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            longPressGestureRecognizer.numberOfTouchesRequired = 1;
            longPressGestureRecognizer.minimumPressDuration = .1;
            longPressGestureRecognizer.cancelsTouchesInView = NO;
            longPressGestureRecognizer.minimumPressDuration = .1;
            longPressGestureRecognizer.delegate = self;
            [self addGestureRecognizer:longPressGestureRecognizer];
            [mArray addObject:longPressGestureRecognizer];
        }
        
        // 双指长按
        if (self.touchEventsMask & eDYTouchStateTwoFingersLongPress) {
            UILongPressGestureRecognizer* longPressWithTwoFingersGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressWithTwoFingers:)];
            longPressGestureRecognizer.minimumPressDuration = .1;
            longPressWithTwoFingersGestureRecognizer.numberOfTouchesRequired = 2;
            longPressWithTwoFingersGestureRecognizer.cancelsTouchesInView = NO;
            longPressWithTwoFingersGestureRecognizer.minimumPressDuration = .1;
            longPressWithTwoFingersGestureRecognizer.delegate = self;
            [self addGestureRecognizer:longPressWithTwoFingersGestureRecognizer];
            [mArray addObject:longPressWithTwoFingersGestureRecognizer];
        }
        
        // 双指缩放
        UIPinchGestureRecognizer *pinchGestureRecognizer = nil;
        if (self.touchEventsMask & eDYTouchStatePinch) {
            pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
            pinchGestureRecognizer.cancelsTouchesInView = NO;
            pinchGestureRecognizer.delegate = self;
            [self addGestureRecognizer:pinchGestureRecognizer];
            [mArray addObject:pinchGestureRecognizer];
        }
        
        self.allGestureRecognizers = mArray;
        // 单指双击优先级比单击高
        if (singleTapGestureRecognizer != nil && pinchGestureRecognizer != nil) {
            [singleTapGestureRecognizer requireGestureRecognizerToFail:pinchGestureRecognizer];
        }
        if (singleTapWithTwoFingersGestureRecognizer != nil && pinchGestureRecognizer != nil) {
            [singleTapWithTwoFingersGestureRecognizer requireGestureRecognizerToFail:pinchGestureRecognizer];
        }
        // 单指双击优先级比单击高
        if (singleTapGestureRecognizer != nil && doubleTapGestureRecognizer != nil) {
            [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        }
        
        // 单指长按优先级比单击高
        if (singleTapGestureRecognizer != nil && longPressGestureRecognizer != nil) {
            [singleTapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
        }
        
        // 双指单击优先级比双指双指单击高
        if (singleTapWithTwoFingersGestureRecognizer != nil && doubleTapWithTwoFingersGestureRecognizer != nil) {
            [singleTapWithTwoFingersGestureRecognizer requireGestureRecognizerToFail:doubleTapWithTwoFingersGestureRecognizer];
        }
        
        // 双指长按优先级比单指长按高
        if (panGestureRecognizer != nil && longPressGestureRecognizer != nil) {
            [panGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
        }
        
        self.eTouchState = eDYTouchStateNone;
    }
    //                  )
    ;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if ((self.touchEventsMask & eDYTouchStateOneFingerLongPress) && self.eTouchState == eDYTouchStateOneFingerLongPress)
    {
        self.gestureConflictView.scrollEnabled = NO;
        
//        self.xPosition = [self fixXPosition:self.xPosition];
//        DDLogInfo(@"pcyan fixed position %lld", self.xPosition);
        
        if (self.myDataSources != nil) {
            for (NSDictionary* dic in self.myDataSources) {
                id<DYMaskViewDataSource> dataSource = [dic objectForKey:DATE_SOURCE_KEY];
                DYChartItemView *chartItemView = [dic objectForKey:DATE_SOURCE_KEY];
                
                if (!self.tipNotShowWithFixedChartItemView && !chartItemView.isFixXPosition) {
                    continue;
                }
                
                if (![dataSource isBindMaskView:self]) {
                    continue;
                }
                
                // 画竖线
                if (self.showMask & eDYMaskViewShowVerticalLine) {
                    [self drawLineFromPoint:CGPointMake(self.xPosition, self.beginY) toPoint:CGPointMake(self.xPosition, self.endY) withColor:[UIColor redColor] andLineWidth:.5f];
                }
                else if (self.showMask & eDYMaskViewShowVerticalDashedLine ||
                         (self.showMask & eDYMaskViewShowHAndVerticalDashedLine)) {
                    [self drawNodLineFromPoint:CGPointMake(self.xPosition, self.beginY) toPoint:CGPointMake(self.xPosition, self.endY) withColor:self.lineColor andLineWidth:.5f];
                }
                
                CGFloat yPosition = [dataSource getYPositionOfMaskView:self atPosition:self.xPosition];
                if(!isnan(yPosition))
                {
                    if (self.showMask & eDYMaskViewShowHorizontalLine) {
                        [self drawLineFromPoint:CGPointMake(self.beginX, yPosition) toPoint:CGPointMake(self.endX, yPosition) withColor:[UIColor redColor] andLineWidth:.5f];
                    }
                    if(self.showMask & eDYMaskViewShowHAndVerticalDashedLine){
                        [self drawNodLineFromPoint:CGPointMake(self.beginX, yPosition) toPoint:CGPointMake(self.endX, yPosition) withColor:[UIColor redColor] andLineWidth:.5f];
                    }
                    if (self.showMask & eDYMaskViewShowHitCircle) {
                        
                        [self drawCycleAtPoint:CGPointMake(self.xPosition, yPosition) strokeColor:chartItemView.lineColor];
                    }
                }
                
               
                if (self.tipsShowType & eDYShowTipsAtXLine) {
                    NSString* xString = [dataSource xTipsOfMaskView:self atPosition:self.xPosition];
                    if ([xString length] > 0) {
                        CGRect xRect = [dataSource xTipsRectOfMaskView:self atPosition:self.xPosition withTipString:xString];
//                        DDLogInfo(@"%@ show x axis rect : x:%f y:%f w:%f h:%f ", dataSource, xRect.origin.x, xRect.origin.y, xRect.size.width, xRect.size.height);
                        [self drawText:xString atRect:xRect withFont:[dataSource fontOfTipsForMask:self] andColor:self.tipsColor andBgColor:self.tipsBackgroundColor andAlignment:NSTextAlignmentCenter withRectRoundSideType:eSideBottom recalcTextRect:YES];
                    }
                }
                
                if (self.tipsShowType & eDYShowTipsAtYLine) {
                    NSString* yString = [dataSource yTipsOfMaskView:self atPosition:self.xPosition];
                    if ([yString length] > 0) {
                        CGRect yRect = [dataSource yTipsRectOfMaskView:self atPosition:self.xPosition withTipString:yString withFont:[dataSource fontOfTipsForMask:self]];
                        CGRect drawRect = [self convertRect:yRect fromView:(UIView*)dataSource];
                        [self drawText:yString atRect:drawRect withFont:[dataSource fontOfTipsForMask:self] andColor:self.tipsColor andBgColor:self.tipsBackgroundColor andAlignment:NSTextAlignmentCenter withRectRoundSideType:eSideRight recalcTextRect:YES];
                    }
                }
                
                if (self.tipsShowType & eDYShowTipsAtFingerPoint||self.tipsShowType & eDYShowTipsAtFingerHotPoint || self.tipsShowType & eDYShowTipsAtFingerRongZiPoint|| self.tipsShowType & eDYShowTipsAtFingerStockDetail) {
                    NSString* yString = [dataSource yTipsOfMaskView:self atPosition:self.xPosition];
                    NSString* xString = [dataSource xTipsOfMaskView:self atPosition:self.xPosition];
               
//                    DDLogInfo(@"pcyan--fixed position %f and x string %@", self.xPosition, xString);
                    
                    if ([xString length] > 0 ||
                        [yString length] > 0) {
                        // 这种情况下，用yString描述的date
                        NSArray *array =  [yString componentsSeparatedByString:@"?"];
                        if (array.count == 2) {
                            xString = array[0];
                            yString = array[1];
                        }
                        
                        // 分解yString
                        NSMutableArray* mValue1TextArray = [NSMutableArray array];
                        NSMutableArray* mValue2TextArray = [NSMutableArray array];
                        NSArray* yStringArray = [yString componentsSeparatedByString:@"\n"];
                        for (NSString* yStringItem in yStringArray) {
                            NSArray* valuesArray = [yStringItem componentsSeparatedByString:@"&"];
                            if ([valuesArray count] > 1) {
                                [mValue1TextArray addObject:valuesArray[0]];
                                [mValue2TextArray addObject:valuesArray[1]];
                            }
                            else
                            {
                                [mValue1TextArray addObject:@""];
                                [mValue2TextArray addObject:yStringItem];
                            }
                        }
                        
                        // 处理过长的value1Text
                        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:mValue1TextArray.count];
                        for (NSString *value1Text in mValue1TextArray) {
                            if (value1Text.length > 10) {
                                [mArray addObject:[NSString stringWithFormat:@"%@...", [value1Text substringToIndex:10]]];
                            } else {
                                [mArray addObject:value1Text];
                            }
                        }
                        mValue1TextArray = mArray;
                        
                        // 重新组装yString
                        NSMutableString *mString = [NSMutableString string];
                        for (NSInteger i = 0 ; i < mValue1TextArray.count ; i ++) {
                            [mString appendFormat:@"%@&%@", mValue1TextArray[i], mValue2TextArray[i]];
                            if (i < mValue1TextArray.count - 1) {
                                [mString appendString:@"\n"];
                            }
                        }
                        yString = mString;
                        
                        // 把xString加到drawString中，用于计算绘制面积
                        NSString* drawString = nil;
                        if ([xString length] <= 0) {
                            drawString = yString;
                        }else {
                            drawString = [NSString stringWithFormat:@"%@\n%@", xString, yString];
                        }
                        
                        // 计算绘制面积
                        CGRect drawRect = [dataSource yTipsRectOfMaskView:self
                                                               atPosition:self.xPosition
                                                            withTipString:drawString
                                                                 withFont:[dataSource yTipsFontOfMaskView:self]];
                        if ([xString length] > 0) {
                            CGRect xRect = [dataSource yTipsRectOfMaskView:self
                                                                atPosition:self.xPosition
                                                             withTipString:xString
                                                                  withFont:[dataSource fontOfTipsForMask:self]];
                            CGRect yRect = [dataSource yTipsRectOfMaskView:self
                                                                atPosition:self.xPosition
                                                             withTipString:yString
                                                                  withFont:[dataSource yTipsFontOfMaskView:self]];
                            
                            // xString可能引起宽度值变大
                            if (drawRect.size.width > yRect.size.width) {
                                if (xRect.size.width > yRect.size.width) {
                                    // 如果已经到最右侧了，需要校正到最右侧
                                    CGRect tempDrawRect = drawRect;
                                    drawRect.size.width = xRect.size.width;
                                    if (tempDrawRect.size.width + tempDrawRect.origin.x >= self.bounds.size.width) {
                                        drawRect.origin.x = self.bounds.size.width - drawRect.size.width;
                                    }
                                }
                                else
                                {
                                    drawRect.size.width = yRect.size.width;
                                }
                            }
                        }
      
                        NSArray* colorArray = @[chartItemView.lineColor];
                        if ([mValue1TextArray count] > 1) {
                            colorArray = [dataSource yColorTipsColorOfMaskView:self];
                        } else if([mValue1TextArray count] > 1) {
                            colorArray = @[DYAppearanceColor(@"W1", 1.0)];
                        }
                         [self drawTipsViewWithDateText:xString
                                            andDateFont:[dataSource fontOfTipsForMask:self]
                                           andDateColor:[dataSource colorOfTipsForMaskView:self]
                                     withValueTextArray:mValue1TextArray
                                           andValueFont:[dataSource yColorTipsFontOfMaskView:self]
                                     andValueColorArray:colorArray
                                    withValue2TextArray:mValue2TextArray
                                          andValue2Font:[dataSource yTipsFontOfMaskView:self]
                                    andValue2ColorArray:[dataSource  yTipsColorOfMaskView:self]
                                                 inRect:drawRect
                                    drawColorCyclePoint:[dataSource ifDrawPointBeforeYColorTipsOfMaskView:self]];
                    }
                }
                break;
            }
            
        }
    }
    else if ((self.touchEventsMask & eDYTouchStateTwoFingersLongPress) && self.eTouchState == eDYTouchStateTwoFingersLongPress)
    {
        self.gestureConflictView.scrollEnabled = NO;
        
        self.xOfLongPressPoint1 = [self fixXPosition:self.xOfLongPressPoint1];
        self.xOfLongPressPoint2 = [self fixXPosition:self.xOfLongPressPoint2];
        
        [self drawLineFromPoint:CGPointMake(self.xOfLongPressPoint1, self.beginY) toPoint:CGPointMake(self.xOfLongPressPoint1, self.endY) withColor:[UIColor redColor] andLineWidth:2.0f];
        [self drawLineFromPoint:CGPointMake(self.xOfLongPressPoint2, self.beginY) toPoint:CGPointMake(self.xOfLongPressPoint2, self.endY) withColor:[UIColor redColor] andLineWidth:2.0f];
        
        if (self.xOfLongPressPoint1 > self.xOfLongPressPoint2) {
            [self drawTransparentRect:CGRectMake(self.xOfLongPressPoint2, self.beginY, self.xOfLongPressPoint1 - self.xOfLongPressPoint2, self.endY - self.beginY)];
            if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(selectAreaChangedForMaskView:fromXPos:toXPos:)]) {
                [self.mydelegate selectAreaChangedForMaskView:self fromXPos:self.xOfLongPressPoint2 toXPos:self.xOfLongPressPoint1];
            }
            
            if (self.myDataSources != nil) {
                for (NSDictionary* dic in self.myDataSources) {
                    id<DYMaskViewDataSource> dataSource = [dic objectForKey:DATE_SOURCE_KEY];
                    
                    if (self.tipsShowType & eDYShowTipsAtXLine) {
                        NSString* xString = [dataSource xSelectTipsOfMaskView:self fromPosition:self.xOfLongPressPoint2 toPosition:self.xOfLongPressPoint1];
                        if ([xString length] > 0) {
                            CGRect xRect = [dataSource xSelectTipsRectOfMaskView:self fromPosition:self.xOfLongPressPoint2 toPosition:self.xOfLongPressPoint1 withTipString:xString];
                            [self drawText:xString atRect:xRect withFont:[dataSource fontOfTipsForMask:self] andColor:DYAppearanceColor(@"H8", 1.0) andBgColor:self.tipsBackgroundColor andAlignment:NSTextAlignmentCenter withRectRoundSideType:eSideAll recalcTextRect:YES];
                        }
                    }
                    
                    if (self.tipsShowType & eDYShowTipsAtFingerPoint) {
                        // TODO:
                    }
                }
            }
        }
        else
        {
            [self drawTransparentRect:CGRectMake(self.xOfLongPressPoint1, self.beginY, self.xOfLongPressPoint2 - self.xOfLongPressPoint1, self.endY - self.beginY)];
            if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(selectAreaChangedForMaskView:fromXPos:toXPos:)]) {
                [self.mydelegate selectAreaChangedForMaskView:self fromXPos:self.xOfLongPressPoint1 toXPos:self.xOfLongPressPoint2];
            }
            
            if (self.myDataSources != nil) {
                for (NSDictionary* dic in self.myDataSources) {
                    id<DYMaskViewDataSource> dataSource = [dic objectForKey:DATE_SOURCE_KEY];
                    
                    if (self.tipsShowType & eDYShowTipsAtXLine) {
                        NSString* xString = [dataSource xSelectTipsOfMaskView:self fromPosition:self.xOfLongPressPoint1 toPosition:self.xOfLongPressPoint2];
                        if ([xString length] > 0) {
                            CGRect xRect = [dataSource xSelectTipsRectOfMaskView:self fromPosition:self.xOfLongPressPoint1 toPosition:self.xOfLongPressPoint2 withTipString:xString];
                            [self drawText:xString atRect:xRect withFont:[dataSource fontOfTipsForMask:self] andColor:DYAppearanceColor(@"H8", 1.0) andBgColor:self.tipsBackgroundColor andAlignment:NSTextAlignmentCenter withRectRoundSideType:eSideAll recalcTextRect:YES];
                        }
                    }
                    
                    if (self.tipsShowType & eDYShowTipsAtFingerPoint) {
                        // TODO:
                    }
                }
            }
        }
    }
    else
    {
        self.gestureConflictView.scrollEnabled = YES;
        //        [self.mydelegate touchEnded:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSSet* allTouchsSet = [event allTouches];
    //    NSArray* allTouchs = [allTouchsSet allObjects];
    //    if ([allTouchs count] > 1) {
    //        int count = 0;
    //        for (UITouch* touch in allTouchs) {
    //            CGPoint point = [touch locationInView:self];
    //            DDLogInfo(@"began touch%d  position x:%.2f y:%.2f", count ++, point.x, point.y);
    //        }
    //    }
    if (self.touchEventsMask == eDYTouchStateNone) {
        return;
    }
    
    self.lastXPosition = -1;
    
//    [[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchEventsMask == eDYTouchStateNone) {
        return;
    }
    
    NSSet* allTouchsSet = [event allTouches];
    NSArray* allTouchs = [allTouchsSet allObjects];
    if ([allTouchs count] > 1) {
        //        int count = 0;
        //        for (UITouch* touch in allTouchs) {
        //            CGPoint point = [touch locationInView:self];
        //            DDLogInfo(@"move touch%d  position x:%.2f y:%.2f", count ++, point.x, point.y);
        //        }
        
        // 先一个点长按，然后增加了一个点，这个也算做两点长按
        if ((self.touchEventsMask & eDYTouchStateTwoFingersLongPress) &&
            [allTouchs count] == 2 &&
            (self.eTouchState == eDYTouchStateOneFingerLongPress ||
             self.eTouchState == eDYTouchStateTwoFingersLongPress)) {
            self.eTouchState = eDYTouchStateTwoFingersLongPress;
            
            UITouch* touch1 = [allTouchs objectAtIndex:0];
            UITouch* touch2 = [allTouchs objectAtIndex:1];
            self.xOfLongPressPoint1 = [touch1 locationInView:self].x;
            self.xOfLongPressPoint2 = [touch2 locationInView:self].x;
        }
    }
    
    [self setNeedsDisplay];
    
//    [[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.fingerLeaveFlag && self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(touchEnded:)]) {
        [self.mydelegate touchEnded:self];
    }
    
    self.isTouchFlag = NO;
     [self redrawMaskView];
    if (self.touchEventsMask == eDYTouchStateNone) {
        return;
    }

//    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isTouchFlag = NO;
    [self redrawMaskView];

    if (self.fingerLeaveFlag && self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(touchEnded:)]) {
        [self.mydelegate touchEnded:self];
    }
    
//    [[self nextResponder] touchesCancelled:touches withEvent:event];
}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    if (self.fingerLeaveFlag && self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(touchEnded:)]) {
        [self.mydelegate touchEnded:self];
    }
    
//    [[self nextResponder] pressesEnded:presses withEvent:event];
}

- (void)pressesCancelled:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    if (self.fingerLeaveFlag && self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(touchEnded:)]) {
        [self.mydelegate touchEnded:self];
    }
    
//    [[self nextResponder] pressesCancelled:presses withEvent:event];
}

- (void)handlePan:(UIPanGestureRecognizer*) recognizer
{
    //    DDLogInfo(@"handlePan eTouchState is %d", self.eTouchState);
    
    if (!(self.touchEventsMask & eDYTouchStatePan))
        return;
    
    if (self.onlyBottomPanFlag) {
        self.eTouchState = eDYTouchStatePan;
        CGFloat y =  [recognizer locationInView:self].y;
        if (y <= (self.bounds.size.height -self.boottomHeight)) {
            self.eTouchState = eDYTouchStateOneFingerLongPress;
        }
    }
    
    if (self.eTouchState == eDYTouchStateOneFingerLongPress) {
        self.xPosition = [self fixXPosition:[recognizer locationInView:self].x];
        
        if (self.lastXPosition < 0) {
            self.lastXPosition = self.xPosition;
        }
        if (!self.isTouchFlag)
        {
            self.isTouchFlag = YES;
            self.lastXPosition = self.xPosition;
        }
        
        if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(maskView:movedTo:from:)]) {
            [self.mydelegate maskView:self movedTo:self.xPosition from:self.lastXPosition];
        }
        
        self.lastXPosition = self.xPosition;
//        DDLogInfo(@"pcyan-xposition:%f", self.xPosition);
        [self setNeedsDisplay];
    }
    //    else if (self.eTouchState == eTouchStateTwoFingersLongPress) {
    //        if ([recognizer numberOfTouches] > 1) {
    //            self.xOfLongPressPoint1 = [recognizer locationOfTouch:0 inView:self].x;
    //            self.xOfLongPressPoint2 = [recognizer locationOfTouch:1 inView:self].x;
    //
    //            [self setNeedsDisplay];
    //        }
    //        else
    //        {
    //            CGFloat x = [recognizer locationInView:self].x;
    //            if (x < self.beginX) {
    //                x = self.beginX;
    //            }
    //            if (x > self.endX) {
    //                x = self.endX;
    //            }
    //            CGFloat space1 = fabsf(x - self.xOfLongPressPoint1);
    //            CGFloat space2 = fabsf(x - self.xOfLongPressPoint2);
    //            if (space1 < TOUCH_TOLERANCE_RANGE) {   // 在第一根误差范围内，认为他拉第一根线呢
    //                if (space2 < space1) {  // 有更近的嘛？
    //                    self.xOfLongPressPoint2 = x;
    //                }
    //                else
    //                {
    //                    self.xOfLongPressPoint1 = x;
    //                }
    //            }
    //            else if (space2 < TOUCH_TOLERANCE_RANGE)    // 跟第二根线更近，那就认为用户在拉第二根线
    //            {
    //                self.xOfLongPressPoint2 = x;
    //            }
    //            else if ((x < self.xOfLongPressPoint2 && x > self.xOfLongPressPoint1) || (x < self.xOfLongPressPoint1 && x > self.xOfLongPressPoint2) || self.lastXPosition >= 0)
    //            {
    //                if (self.lastXPosition < 0) {
    //                    self.lastXPosition = x;
    //                }
    //
    //                CGFloat xPos1 = self.xOfLongPressPoint1;
    //                CGFloat xPos2 = self.xOfLongPressPoint2;
    //                xPos1 += x - self.lastXPosition;
    //                xPos2 += x - self.lastXPosition;
    //
    //                if (xPos1 < self.beginX || xPos2 < self.beginX) {
    //                    [self.mydelegate maskView:self movedTo:self.lastXPosition from:x];
    ////                    self.lastXPosition = x;
    //                }
    //                else if (xPos1 > self.endX || xPos2 > self.endX) {
    //                    [self.mydelegate maskView:self movedTo:self.lastXPosition from:x];
    ////                    self.lastXPosition = x;
    //                }
    //                else
    //                {
    //                    if ([self fixXPosition:xPos1] != [self fixXPosition:self.xOfLongPressPoint1]) {
    //                        self.xOfLongPressPoint1 += x - self.lastXPosition;
    //                        self.xOfLongPressPoint2 += x - self.lastXPosition;
    //
    //                        self.lastXPosition = x;
    //                    }
    //                }
    //            }
    //            else
    //            {
    //                DDLogInfo(@"*************%f", self.lastXPosition);
    //                self.eTouchState = eTouchStatePan;
    //            }
    //
    //            [self setNeedsDisplay];
    //        }
    //    }
    else if ([recognizer numberOfTouches] <= 1) // 这个判断，主要是为了避免在缩放的时候，手势演变成pan，然后切换到双指长按的状态
    {
        self.eTouchState = eDYTouchStatePan;
        
        self.xPosition = [self fixXPosition:[recognizer locationInView:self].x];
        
        if (self.lastXPosition < 0) {
            self.lastXPosition = self.xPosition;
        }
        if (!self.isTouchFlag)
        {
            self.isTouchFlag = YES;
            self.lastXPosition = self.xPosition;
        }
        
        if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(maskView:movedTo:from:)]) {
            [self.mydelegate maskView:self movedTo:self.xPosition from:self.lastXPosition];
        }
        
        self.lastXPosition = self.xPosition;
//        DDLogInfo(@"pcyan-xposition:%f", self.xPosition);
        [self setNeedsDisplay];
    }
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        self.isTouchFlag = NO;
        self.lastXPosition = -1;
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer*)recognizer
{
    if (!(self.touchEventsMask & eDYTouchStateOneFingerSingleTap))
        return;
    
    if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(oneFingerSingleTap:)]) {
        [self.mydelegate oneFingerSingleTap:self];
    }
        
    if (self.eTouchState == eDYTouchStateOneFingerSingleTap) {
    }
    else
    {
        self.eTouchState = eDYTouchStateOneFingerSingleTap;
        [self setNeedsDisplay];
        if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(touchEnded:)]) {
            [self.mydelegate touchEnded:self];
        }
    }
}

- (void)handleDoubleTap:(UIPanGestureRecognizer*) recognizer
{
    if (!(self.touchEventsMask & eDYTouchStateOneFingerDoubleTap))
        return;
    
    self.eTouchState = eDYTouchStateOneFingerDoubleTap;
    if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(oneFingerDoubleClickForMaskView:atPoint:)]) {
        [self.mydelegate oneFingerDoubleClickForMaskView:self atPoint:[recognizer locationInView:self]];
        [self setNeedsDisplay];
    }
}

- (void)handleSingleTapWithTwoFingers:(UIPanGestureRecognizer*) recognizer
{
    if (!(self.touchEventsMask & eDYTouchStateTwoFingersSingleTap))
        return;
    
    // 有时候俩手指头刚放上，选择区域已经显示出来了，这时不要转变状态
    if (self.eTouchState != eDYTouchStateTwoFingersLongPress) {
        self.eTouchState = eDYTouchStateTwoFingersSingleTap;
        
        if ([recognizer numberOfTouches] > 1) {
            CGPoint point1 = [recognizer locationOfTouch:0 inView:self];
            CGPoint point2 = [recognizer locationOfTouch:1 inView:self];
            CGPoint center = CGPointMake(point1.x + (point2.x - point1.x)/2, point1.y + (point2.y - point1.y)/2);
            
            if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(twoFingerSingleClickForMaskView:atPoint:)]) {
                [self.mydelegate twoFingerSingleClickForMaskView:self atPoint:center];
            }
            [self setNeedsDisplay];
        }
    }
}

- (void)handleDoubleTapWithTwoFingers:(UIPanGestureRecognizer*) recognizer
{
    if (!(self.touchEventsMask & eDYTouchStateTwoFingersDoubleTap))
        return;
    
    self.eTouchState = eDYTouchStateTwoFingersDoubleTap;
    
    if ([recognizer numberOfTouches] > 1) {
        CGPoint point1 = [recognizer locationOfTouch:0 inView:self];
        CGPoint point2 = [recognizer locationOfTouch:1 inView:self];
        CGPoint center = CGPointMake(point1.x + (point2.x - point1.x)/2, point1.y + (point2.y - point1.y)/2);
        
        if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(twoFingerDoubleClickForMaskView:atPoint:)]) {
            [self.mydelegate twoFingerDoubleClickForMaskView:self atPoint:center];
        }
        [self setNeedsDisplay];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer
{
    if (!(self.touchEventsMask & eDYTouchStateOneFingerLongPress))
        return;
    
    // 如果当前正在处理两指长按的手势，让处理继续下去
    if (self.eTouchState != eDYTouchStateTwoFingersLongPress || self.eTouchState!=eDYTouchStatePinch) {
        
        if (self.eTouchState != eDYTouchStateOneFingerLongPress) {
            self.eTouchState = eDYTouchStateOneFingerLongPress;
        }
//        if (self.onlyBottomPanFlag) {
//            CGFloat y =  [recognizer locationInView:self].y;
//            if (y > (self.bounds.size.height -self.boottomHeight)) {
//                self.eTouchState = eDYTouchStatePan;
//            }
//        }
        if ([recognizer numberOfTouches] == 1) {
            self.xPosition = [self fixXPosition:[recognizer locationInView:self].x];
            
            if (self.lastXPosition < 0) {
                self.lastXPosition = self.xPosition;
            }
            if (!self.isTouchFlag)
            {
                self.isTouchFlag = YES;
                self.lastXPosition = self.xPosition;
            }
            
            if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(maskView:movedTo:from:)]) {
                [self.mydelegate maskView:self movedTo:self.xPosition from:self.lastXPosition];
            }
            
            self.lastXPosition = self.xPosition;
//            DDLogInfo(@"pcyan-xposition:%f", self.xPosition);
            [self setNeedsDisplay];
        }
 
        if (recognizer.state==UIGestureRecognizerStateEnded || recognizer.state ==UIGestureRecognizerStateCancelled ||recognizer.state ==UIGestureRecognizerStateFailed  ) {
             self.isTouchFlag = NO;
            self.lastXPosition = -1;
        }
    }
}

- (void)handleLongPressWithTwoFingers:(UILongPressGestureRecognizer*)recognizer
{
    if (!(self.touchEventsMask & eDYTouchStateTwoFingersLongPress))
        return;
    
    // 如果当前正在缩放，让缩放继续下去
    if (self.eTouchState != eDYTouchStatePinch) {
        
        if (self.eTouchState != eDYTouchStateTwoFingersLongPress) {
            self.eTouchState = eDYTouchStateTwoFingersLongPress;
        }
        
        if ([recognizer numberOfTouches] > 1) {
            self.xOfLongPressPoint1 = [recognizer locationOfTouch:0 inView:self].x;
            self.xOfLongPressPoint2 = [recognizer locationOfTouch:1 inView:self].x;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    if (!(self.touchEventsMask & eDYTouchStatePinch))
        return;
    
    // 如果当前正在处理两指长按的手势，让处理继续下去
    if (self.eTouchState != eDYTouchStateTwoFingersLongPress) {
        self.eTouchState = eDYTouchStatePinch;
        
        if (self.mydelegate != nil && [self.mydelegate respondsToSelector:@selector(zoomForMaskView:atPoint:withZoomValue:)]) {
            if ([recognizer numberOfTouches] > 1) {
                CGPoint point1 = [recognizer locationOfTouch:0 inView:self];
                CGPoint point2 = [recognizer locationOfTouch:1 inView:self];
//                DDLogInfo(@"%@<%@",NSStringFromCGPoint(point1),NSStringFromCGPoint(point2));
                CGPoint center = CGPointMake(point1.x + (point2.x - point1.x)/2, point1.y + (point2.y - point1.y)/2);
                [self.mydelegate zoomForMaskView:self atPoint:center withZoomValue:recognizer.scale];
                recognizer.scale = 1;
            }
        }
        
        [self setNeedsDisplay];
    }
}

#pragma mark - UIGestureRecognizerDelegate 函数
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isTouchFlag) {
        return NO;
    }
    return YES;
}

#pragma mark - 工具函数
// 修正X坐标
- (CGFloat)fixXPosition:(CGFloat)xPosition
{
    if (xPosition > self.endX) {
        xPosition = self.endX;
    }
    else if (xPosition < self.beginX)
    {
        xPosition = self.beginX;
    }
    
    if ([self.myDataSources count] > 0) {
        // 根据曲线数据修正xPosition位置
        CGFloat tempXPosition = xPosition;
        CGFloat minAbs = MAXFLOAT;
        
        DYChartItemView *chartItemView = nil;
        for (NSDictionary* dic in self.myDataSources) {
            id<DYMaskViewDataSource> dataSource = [dic objectForKey:DATE_SOURCE_KEY];
            DYChartItemView *tempChartItemView = (DYChartItemView *)dataSource;
            tempChartItemView.isFixXPosition = NO;
            
            CGFloat tXPosition = [dataSource fixXPositionOfMaskView:self atPosition:xPosition];
            if (fabs(tXPosition - xPosition) < minAbs) {
                minAbs = fabs(tXPosition - xPosition);
                tempXPosition = tXPosition;
                chartItemView = tempChartItemView;
            }
        }
        
        chartItemView.isFixXPosition = YES;
        
        return tempXPosition;
    }
    
    return xPosition;
}

// 画线
- (void)drawLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withColor:(UIColor*)color andLineWidth:(CGFloat)lineWidth
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NAN_OR_INF_POINT_2_ZERO(fromPoint);
    NAN_OR_INF_POINT_2_ZERO(toPoint);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    
    CGContextStrokePath(context);
}
// 画虚线
- (void)drawNodLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withColor:(UIColor*)color andLineWidth:(CGFloat)lineWidth
{
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context,1);//线宽度
    
    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
    
    CGFloat lengths[] = {4,2};//先画4个点再画2个点
    
    CGContextSetLineDash(context,0, lengths,2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(context,fromPoint.x
                         ,fromPoint.y);
    
    CGContextAddLineToPoint(context,toPoint.x,toPoint.y);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

//根据线的颜色画圆点
- (void)drawCycleAtPoint:(CGPoint)point strokeColor:(UIColor *)strokeColor
{
    [self drawCycleAtPoint:point strokeColor:strokeColor andFillColor:self.pointColor];
}

- (void)drawCycleAtPoint:(CGPoint)point strokeColor:(UIColor *)strokeColor andFillColor:(UIColor*)fillColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NAN_OR_INF_POINT_2_ZERO(point);
    CGFloat lengths[] = {1,0};
    CGContextSetLineDash(context,0, lengths,2);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context,strokeColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddArc(context, point.x, point.y, DYTIPS_CYCLE_POINT_WIDTH/2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    
}

// 画圆点
- (void)drawCycleAtPoint:(CGPoint)point
{
    [self drawCycleAtPoint:point strokeColor:DYAppearanceColor(@"H13", 1.0)];
}

// 画圆角矩形
- (void)drawRoundRect:(CGRect)rect
{
    [self drawRoundRect:rect withColor:[DYAppearance colorWithRGBA:0xffffff99]];
}


- (void)drawRoundRect:(CGRect)rect
            withColor:(UIColor*)color
             withMask:(BOOL)triangleFlag
               origin:(BOOL)rightFlag
{
    if (color != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.0);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 1.0);
        NAN_OR_INF_POINT_2_ZERO(rect.origin);
        
        CGContextMoveToPoint(context,
                             rect.origin.x + rect.size.width,
                             rect.origin.y + rect.size.height - 4);
        CGContextAddArcToPoint(context,
                               rect.origin.x + rect.size.width,
                               rect.origin.y + rect.size.height,
                               rect.origin.x + rect.size.width - 4,
                               rect.origin.y + rect.size.height, 2);
        CGContextAddArcToPoint(context,
                               rect.origin.x,
                               rect.origin.y + rect.size.height,
                               rect.origin.x,
                               rect.origin.y + rect.size.height - 4, 2);
        CGContextAddArcToPoint(context,
                               rect.origin.x,
                               rect.origin.y,
                               rect.origin.x + 4,
                               rect.origin.y, 2);
        CGContextAddArcToPoint(context,
                               rect.origin.x + rect.size.width,
                               rect.origin.y,
                               rect.origin.x + rect.size.width,
                               rect.origin.y + 4, 2);
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        if (triangleFlag) {
            if (rightFlag) {
                CGContextMoveToPoint(context, rect.origin.x + rect.size.width + 10, rect.origin.y + rect.size.height/2);
                CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y+ rect.size.height/2-6);
                CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y+ rect.size.height/2+6);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
            else {
                CGContextMoveToPoint(context, rect.origin.x -10, rect.origin.y + rect.size.height/2);
                CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+ rect.size.height/2-6);
                CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+ rect.size.height/2+6);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathFillStroke);
                
            }
        }
        
    }
}

- (void)drawOneSideWithSide:(EMaskViewRectSide)side
               AndRoundRect:(CGRect)rect
                  withColor:(UIColor*)color
                 withRadius:(CGFloat)radius
{
    if (color != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.0);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 1.0);
        NAN_OR_INF_POINT_2_ZERO(rect.origin);
        
        switch (side) {
            case eSideBottom: {     // 底部是圆角
                CGContextMoveToPoint(context,
                                     rect.origin.x + rect.size.width,
                                     rect.origin.y + rect.size.height - radius*2);
                CGContextAddArcToPoint(context,
                                       rect.origin.x + rect.size.width,
                                       rect.origin.y + rect.size.height,
                                       rect.origin.x + rect.size.width - radius*2,
                                       rect.origin.y + rect.size.height,
                                       radius);
                CGContextAddLineToPoint(context,
                                        rect.origin.x + radius*2,
                                        rect.origin.y + rect.size.height);
                CGContextAddArcToPoint(context,
                                       rect.origin.x,
                                       rect.origin.y + rect.size.height,
                                       rect.origin.x,
                                       rect.origin.y + rect.size.height - radius*2,
                                       radius);
                CGContextAddLineToPoint(context,
                                        rect.origin.x,
                                        rect.origin.y);
                CGContextAddLineToPoint(context,
                                        rect.origin.x + rect.size.width,
                                        rect.origin.y);
            }
                break;
            case eSideTop: {        // 上方是圆角
                CGContextMoveToPoint(context,
                                     rect.origin.x + rect.size.width,
                                     rect.origin.y + rect.size.height);
                CGContextAddLineToPoint(context,
                                        rect.origin.x,
                                        rect.origin.y + rect.size.height);
                CGContextAddLineToPoint(context,
                                        rect.origin.x,
                                        rect.origin.y + radius*2);
                CGContextAddArcToPoint(context,
                                       rect.origin.x,
                                       rect.origin.y,
                                       rect.origin.x + radius*2,
                                       rect.origin.y,
                                       radius);
                CGContextAddLineToPoint(context,
                                        rect.origin.x + rect.size.width - radius*2,
                                        rect.origin.y);
                CGContextAddArcToPoint(context,
                                       rect.origin.x + rect.size.width,
                                       rect.origin.y,
                                       rect.origin.x + rect.size.width,
                                       rect.origin.y + radius*2,
                                       radius);
            }
                break;
            case eSideLeft: {       // 左侧是圆角
                CGContextMoveToPoint(context,
                                     rect.origin.x + rect.size.width,
                                     rect.origin.y + rect.size.height);
                CGContextAddLineToPoint(context,
                                        rect.origin.x + radius*2,
                                        rect.origin.y + rect.size.height);
                CGContextAddArcToPoint(context,
                                       rect.origin.x,
                                       rect.origin.y + rect.size.height,
                                       rect.origin.x,
                                       rect.origin.y + rect.size.height - radius*2,
                                       radius);
                CGContextAddLineToPoint(context,
                                        rect.origin.x,
                                        rect.origin.y + radius*2);
                CGContextAddArcToPoint(context,
                                       rect.origin.x,
                                       rect.origin.y,
                                       rect.origin.x + radius*2,
                                       rect.origin.y,
                                       radius);
                CGContextAddLineToPoint(context,
                                        rect.origin.x + rect.size.width,
                                        rect.origin.y);
            }
                break;
            case eSideRight: {      // 右侧是圆角
                CGContextMoveToPoint(context,
                                     rect.origin.x + rect.size.width,
                                     rect.origin.y + rect.size.height - radius*2);
                CGContextAddArcToPoint(context,
                                       rect.origin.x + rect.size.width,
                                       rect.origin.y + rect.size.height,
                                       rect.origin.x + rect.size.width - radius*2,
                                       rect.origin.y + rect.size.height,
                                       radius);
                CGContextAddLineToPoint(context,
                                        rect.origin.x,
                                        rect.origin.y + rect.size.height);
                CGContextAddLineToPoint(context,
                                        rect.origin.x,
                                        rect.origin.y);
                CGContextAddLineToPoint(context,
                                        rect.origin.x + rect.size.width - radius*2,
                                        rect.origin.y);
                CGContextAddArcToPoint(context,
                                       rect.origin.x + rect.size.width,
                                       rect.origin.y,
                                       rect.origin.x + rect.size.width,
                                       rect.origin.y + radius*2,
                                       radius);
            }
                break;
                
            default:
                break;
        }
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

- (void)drawRoundRect:(CGRect)rect withColor:(UIColor*)color
{
    [self drawRoundRect:rect withColor:color withMask:NO origin:NO];
}

// 画透明矩形
- (void)drawTransparentRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor*aColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.5];
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    NAN_OR_INF_POINT_2_ZERO(rect.origin);
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    //    CGContextStrokePath(context);
}

- (void)drawTipsViewWithDateText:(NSString*)dateText            // 日期字段
                     andDateFont:(UIFont*)dateFont              // 日期字体
                    andDateColor:(UIColor*)dateColor            // 日期文字的颜色

              withValueTextArray:(NSArray*)valueTextArray       // 值1的文字
                    andValueFont:(UIFont*)value1Font            // 值1的字体
              andValueColorArray:(NSArray*)valueColorArray      // 值1的颜色

             withValue2TextArray:(NSArray*)value2TextArray      // 值2的文字
                   andValue2Font:(UIFont*)value2Font            // 值2的字体
             andValue2ColorArray:(NSArray*)value2ColorArray     // 值2的颜色

                          inRect:(CGRect)rect                   // 绘制在这个rect内
             drawColorCyclePoint:(BOOL)draw                     // 是否绘制颜色原点
{
    [self drawRoundRect:rect withColor:DYAppearanceColor(@"H13", 0.75)];
    
    CGRect drawRect = rect;
    CGFloat tipTextGap = self.tipTextGap;
    if (tipTextGap < 0) {
        tipTextGap = DYTIPS_TEXT_GAP;
    }
    
    drawRect.origin.x += tipTextGap;
    drawRect.size.width -= tipTextGap*2;
    
    // 计算每行的高度
    NSInteger count = [valueTextArray count];
    CGFloat lineHeight=0 ;
    if ([dateText length] > 0) {
        lineHeight = (rect.size.height - tipTextGap)/(count + 1);
    }else {
        lineHeight = (rect.size.height - tipTextGap)/count;
    }
    
    // 画日期（顶部，左对齐）
    if ([dateText length] > 0) {
        CGRect dateRect = drawRect;
        dateRect.origin.y += tipTextGap;
        [self drawText:dateText atRect:dateRect withFont:dateFont andColor:dateColor andBgColor:nil andAlignment:NSTextAlignmentLeft withRectRoundSideType:eSideAll recalcTextRect:NO];
        
        drawRect.origin.y += lineHeight + tipTextGap;
    }
    else
    {
        drawRect.origin.y += tipTextGap;
    }
    
    // 画下面几行的东西
    
    if ([valueTextArray count] == [value2TextArray count]) {
        for (NSInteger i = 0 ; i < count ; i ++) {
            if (i == 0) {
                //
            }
            else
            {
                drawRect.origin.y += lineHeight;
                drawRect.size.height -= lineHeight;
            }
            
            if (draw) {
                CGRect dotRect = drawRect;
                dotRect.size.height = lineHeight - tipTextGap;
                
                CGPoint dotPoint = CGPointMake(dotRect.origin.x + DYTIPS_CYCLE_POINT_WIDTH/2,
                                               dotRect.origin.y + dotRect.size.height/2);
                UIColor* dotcolor;
                if (i < valueColorArray.count) {
                    dotcolor = valueColorArray[i];    // 值1的颜色和点的颜色一致
                }else {
                    dotcolor = valueColorArray[0];    // 值1的颜色和点的颜色一致
                }
                [self drawCycleAtPoint:dotPoint strokeColor:dotcolor andFillColor:dotcolor];
            }
            
            NSString* value1Text = valueTextArray[i];
            NSString* value2Text = value2TextArray[i];
            UIColor* value2Color ;
            if (i < value2ColorArray.count) {
                value2Color = value2ColorArray[i];
            }else {
                value2Color = value2ColorArray[0];    // 值1的颜色和点的颜色一致
            }
            // 画值1
            CGRect value1TextRect = drawRect;
            if (draw) {
                value1TextRect.origin.x += DYTIPS_CYCLE_POINT_WIDTH + tipTextGap;
                value1TextRect.size.width -= DYTIPS_CYCLE_POINT_WIDTH + tipTextGap;
            }

//            [self drawText:value1Text atRect:value1TextRect withFont:value1Font andColor:dotcolor andBgColor:nil andAlignment:NSTextAlignmentLeft];
            UIColor* grayColor = DYAppearanceColor(@"W1", 1.0);
            if ([value1Text length] > 0) {
                [self drawText:value1Text atRect:value1TextRect withFont:value1Font andColor:grayColor andBgColor:nil andAlignment:NSTextAlignmentLeft withRectRoundSideType:eSideAll recalcTextRect:NO];
            }
            
            // 画值2
            if ([value1Text length] > 0) {
                if ([value2Text length] > 0) {
                    [self drawText:value2Text atRect:value1TextRect withFont:value2Font andColor:value2Color andBgColor:nil andAlignment:NSTextAlignmentRight withRectRoundSideType:eSideAll recalcTextRect:NO];
                }
            }
            else
            {
                if ([value2Text length] > 0) {
                    [self drawText:value2Text atRect:value1TextRect withFont:value2Font andColor:value2Color andBgColor:nil andAlignment:NSTextAlignmentLeft withRectRoundSideType:eSideAll recalcTextRect:NO];
                }
            }
        }
    }
}

- (void)drawText:(NSString*)text
          atRect:(CGRect)rect
        withFont:(UIFont*)font
        andColor:(UIColor*)color
      andBgColor:(UIColor*)bgColor
    andAlignment:(NSTextAlignment)textAlignment
withRectRoundSideType:(EMaskViewRectSide)side
  recalcTextRect:(BOOL)recalc
 {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
     [style setAlignment:textAlignment];
     if (bgColor) {
         if (side == eSideAll) {
             [self drawRoundRect:rect withColor:bgColor];
         } else {
             [self drawOneSideWithSide:side AndRoundRect:rect withColor:bgColor withRadius:2];
         }
     }
    
     CGContextRef context = UIGraphicsGetCurrentContext();
    
     CGRect textRect = rect;
     if (recalc) {
         CGFloat tipTextGap = self.tipTextGap;
         if (tipTextGap < 0) {
             tipTextGap = DYTIPS_TEXT_GAP/4;
         }
         textRect.origin.x += tipTextGap;
         textRect.origin.y += tipTextGap;
         textRect.size.width -= tipTextGap * 2;
         textRect.size.height -= tipTextGap * 2;
     }
     
     if (textAlignment ==NSTextAlignmentRight) {
//         textRect.size.width -= self.textGap;
     } else if (textAlignment == NSTextAlignmentLeft) {
//         textRect.origin.x += self.textGap;
     }
     
    CGContextSetFillColorWithColor(context, color.CGColor);
     [text drawWithRect:textRect
                options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{NSParagraphStyleAttributeName:style,
                          NSFontAttributeName:font,
                          NSForegroundColorAttributeName:color}
                context:nil];
    CGContextStrokePath(context);
}
@end
