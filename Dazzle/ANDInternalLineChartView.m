//
//  ANDExampleViewController.h
//  SimpleAnimatedGraph v.0.1.0
//
//  Created by Andrzej Naglik on 19.01.2014.
//  Copyright (c) 2014 Andrzej Naglik. All rights reserved.
//

#import "ANDInternalLineChartView.h"
#import "ANDLineChartView.h"
#import "tgmath.h"

#define INTERVAL_TEXT_LEFT_MARGIN 10.0
#define INTERVAL_TEXT_MAX_WIDTH 100.0

#define CIRCLE_SIZE 14.0

@implementation ANDInternalLineChartView{
  CAShapeLayer *_graphLayer;
  CAShapeLayer *_maskLayer;
  CAGradientLayer *_gradientLayer;
  CAShapeLayer *_labelsLayer;
  UIImage *_circleImage;
  NSUInteger _numberOfPreviousElements;

  CGFloat _maxValue;
  CGFloat _minValue;
  BOOL _animationNeeded;
}

- (instancetype)initWithFrame:(CGRect)frame{
  return [self initWithFrame:frame chartContainer:nil];
}

- (instancetype)initWithFrame:(CGRect)frame chartContainer:(ANDLineChartView*)chartContainer{
  self = [super initWithFrame:frame];
  if(self){
      [self setupDefaultAppearence];
    [self setChartContainer:chartContainer];
    [self setupGradientLayer];
    [self setupMaskLayer];
    [self setupLabelsLayer];
    [self setupGraphLayer];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:NO];
  }
  return self;
}

- (void)setupGraphLayer{
  _graphLayer = [CAShapeLayer layer];
  [_graphLayer setFrame:[self bounds]];
  [_graphLayer setGeometryFlipped:YES];
  [_graphLayer setStrokeColor:[[self.chartContainer lineColor] CGColor]];
  [_graphLayer setFillColor:nil];
  [_graphLayer setLineWidth:3.0f];
  [_graphLayer setLineJoin:kCALineJoinBevel];
  [[self layer] addSublayer:_graphLayer];
}

- (void)setupLabelsLayer{
    _labelsLayer = [CAShapeLayer layer];
    [_labelsLayer setFrame:[self bounds]];
    [_labelsLayer setGeometryFlipped:YES];
    [_labelsLayer setLineJoin:kCALineJoinBevel];
    [[self layer] addSublayer:_labelsLayer];
}

- (void)setupGradientLayer{
  _gradientLayer = [CAGradientLayer layer];
    CGColorRef color1 = self.gradientStartColor.CGColor;
    CGColorRef color2 = self.gradientEndColor.CGColor;
  [_gradientLayer setColors:@[(__bridge id)color1,(__bridge id)color2]];
  [_gradientLayer setLocations:@[@0.0,@0.9]];
  [_gradientLayer setFrame:[self bounds]];
  [[self layer] addSublayer:_gradientLayer];
}

- (void)setupMaskLayer{
  _maskLayer = [CAShapeLayer layer];
  [_maskLayer setFrame:[self bounds]];
  [_maskLayer setGeometryFlipped:YES];
  [_maskLayer setStrokeColor:[[UIColor clearColor] CGColor]];
  [_maskLayer setFillColor:[[UIColor blackColor] CGColor]];
  [_maskLayer setLineWidth:2.0f];
  [_maskLayer setLineJoin:kCALineJoinBevel];
  [_maskLayer setMasksToBounds:YES];
}

- (void)reloadData{
  _animationNeeded = YES;
  NSUInteger numberOfPoints = [self.chartContainer numberOfElements];
  if(numberOfPoints != _numberOfPreviousElements){
    [self invalidateIntrinsicContentSize];
  }
  [self setNeedsLayout];
}

- (void)layoutSubviews{
  [super layoutSubviews];
  [_graphLayer setFrame:[self bounds]];
  [_labelsLayer setFrame:[self bounds]];
  [_maskLayer setFrame:[self bounds]];
  [_gradientLayer setFrame:[self bounds]];

  [self refreshGraphLayer];
}

- (void)refreshGraphLayer{
  if([self.chartContainer numberOfElements] == 0)
    return;

  UIBezierPath *path = [UIBezierPath bezierPath];
  //[path moveToPoint:CGPointMake(0.0, 0.0)];
  NSUInteger numberOfPoints = [self.chartContainer numberOfElements];
  _numberOfPreviousElements = numberOfPoints;
  CGFloat xPosition = 0.0;
  CGFloat yMargin = 0.0;
  CGFloat yPosition = 0.0;

  [_graphLayer setStrokeColor:[[self.chartContainer lineColor] CGColor]];

  CGPoint lastPoint = CGPointMake(0, 0);
  [CATransaction begin];
  for(NSUInteger i = 0; i<numberOfPoints;i++){
    CGFloat value = [self.chartContainer valueForElementAtRow:i];
    CGFloat minGridValue = [self.chartContainer minValue];
    
    xPosition += [self.chartContainer spacingForElementAtRow:i] ;
    yPosition = yMargin + floor((value-minGridValue)*[self pixelToRecordPoint]);
    yPosition+= BOTTOM_PADDING;
    
    CGPoint newPosition = CGPointMake(xPosition, yPosition);
      
      if(i == 0){
          [path moveToPoint:newPosition];
      }else{
        [path addLineToPoint:newPosition];
      }
    
    
    CALayer *circle = [self circleLayerForPointAtRow:i];
    CGPoint oldPosition = [circle.presentationLayer position];
    oldPosition.x = newPosition.x;
    [circle setPosition: newPosition];
    lastPoint = newPosition;
    
    //animate position change
    if(_animationNeeded){
      CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
      positionAnimation.duration = [self.chartContainer animationDuration];
      positionAnimation.fromValue = [NSValue valueWithCGPoint:oldPosition];
      positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
      //[positionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
      [positionAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.5 :1.4 :1 :1]];
      [circle addAnimation:positionAnimation forKey:@"position"];
    }
  }
  
  // hide other circles if needed
  //hide them under minValue - 10.0 points
  if([[_graphLayer sublayers] count] > numberOfPoints){
    for(NSUInteger i = numberOfPoints; i < [[_graphLayer sublayers] count];i++){
      CALayer *circle = [self circleLayerForPointAtRow:i];
      CGPoint oldPosition = [circle.presentationLayer position];
      CGPoint newPosition = CGPointMake(oldPosition.x, [self.chartContainer minValue] - 50.0);
      [circle setPosition:newPosition];
      
      
      // animate position change
      if(_animationNeeded){
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = [self.chartContainer animationDuration];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:oldPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
        [positionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [circle addAnimation:positionAnimation forKey:@"position"];
      }
    }
  }
  
  CGPathRef oldPath = [_graphLayer.presentationLayer path];
  CGPathRef newPath = path.CGPath;
  
  [_graphLayer setPath:path.CGPath];
  if(_animationNeeded){
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = [self.chartContainer animationDuration];
    pathAnimation.fromValue = (__bridge id)oldPath;
    pathAnimation.toValue = (__bridge id)newPath;
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.5 :1.4 :1 :1]];
    [_graphLayer addAnimation:pathAnimation forKey:@"path"];
  }
  
  UIBezierPath *copyPath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
  [copyPath addLineToPoint:CGPointMake(lastPoint.x+90, BOTTOM_PADDING)];
    [copyPath addLineToPoint:CGPointMake([self.chartContainer spacingForElementAtRow:0], BOTTOM_PADDING)];
    [copyPath closePath];
  //[copyPath addLineToPoint:CGPointMake(0.0, 0.0)];
  CGPathRef maskOldPath = [_maskLayer.presentationLayer path];
  CGPathRef maskNewPath = copyPath.CGPath;
  [_maskLayer setPath:copyPath.CGPath];
  [_gradientLayer setMask:_maskLayer];

  if(_animationNeeded){
    CABasicAnimation *pathAnimation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation2.duration = [self.chartContainer animationDuration];
    pathAnimation2.fromValue = (__bridge id)maskOldPath;
    pathAnimation2.toValue = (__bridge id)maskNewPath;
    //[pathAnimation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [pathAnimation2 setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.5 :1.4 :1 :1]];
    [_maskLayer addAnimation:pathAnimation2 forKey:@"path"];
      
  }

  
  [CATransaction commit];
    
    xPosition = 0;
    for (int i = 0; i < numberOfPoints; i++) {
        CATextLayer* label = [self labelLayerForPointAtRow:i];
    
        [label setString:[self.chartContainer labelForElementAtRow:i]];
        
        [label setFrame:CGRectMake(xPosition, 0, INTERVAL_TEXT_MAX_WIDTH, [[self.chartContainer gridIntervalFont] lineHeight])];
        
        xPosition += [self.chartContainer spacingForElementAtRow:i] ;
    }
    
    //hide extra label layers
    if([[_labelsLayer sublayers] count] > numberOfPoints){
        for(NSUInteger i = numberOfPoints; i < [[_labelsLayer sublayers] count];i++){
            CATextLayer *label = [self labelLayerForPointAtRow:i];
            CGPoint oldPosition = [label.presentationLayer position];
            CGPoint newPosition = CGPointMake(oldPosition.x, [self.chartContainer minValue] - 50.0);
            [label setPosition:newPosition];
            
            
            // animate position change
            if(_animationNeeded){
                CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
                positionAnimation.duration = [self.chartContainer animationDuration];
                positionAnimation.fromValue = [NSValue valueWithCGPoint:oldPosition];
                positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
                [positionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [label addAnimation:positionAnimation forKey:@"position"];
            }
        }
    }

}

#pragma mark -
#pragma mark - Helpers

- (CGFloat)viewHeight{
  UIFont *font = [self.chartContainer gridIntervalFont];
  CGFloat maxHeight = round(CGRectGetHeight([self frame]) - [font lineHeight]);
  return maxHeight;
}

- (CGFloat)pixelToRecordPoint{
  CGFloat maxHeight = [self viewHeight];
  
  CGFloat maxIntervalValue = [self.chartContainer maxValue];
  CGFloat minIntervalValue = [self.chartContainer minValue];
  
  return (maxHeight/(maxIntervalValue - minIntervalValue));
}

- (CALayer*)circleLayerForPointAtRow:(NSUInteger)row{
  NSUInteger totalNumberOfCircles = [[_graphLayer sublayers] count];
  if(row >=  totalNumberOfCircles){
    CALayer *circleLayer = [self newCircleLayer];
    [_graphLayer addSublayer:circleLayer];
  }

  return [_graphLayer sublayers][row];
}

- (CATextLayer*)labelLayerForPointAtRow:(NSUInteger)row{
    NSUInteger totalNumberOfLabels = [[_labelsLayer sublayers] count];
    if(row >=  totalNumberOfLabels){
        CATextLayer *labelLayer = [self newTextLayer];
        [_labelsLayer addSublayer:labelLayer];
    }
    
    return [_labelsLayer sublayers][row];
}

- (CALayer*)newCircleLayer{
  CALayer *newCircleLayer = [CALayer layer];
  UIImage *img = [self circleImage];
  [newCircleLayer setContents:(id)img.CGImage];
  [newCircleLayer setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
  [newCircleLayer setGeometryFlipped:YES];
  return newCircleLayer;
}

- (CATextLayer*)newTextLayer{
    CATextLayer *label = [CATextLayer layer];
    [label setFont:(__bridge CFTypeRef)([self.chartContainer gridIntervalFont])];
    [label setFontSize:10];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[self.chartContainer gridIntervalFontColor].CGColor];
    [label setGeometryFlipped:YES];
    
    return label;
}


- (UIImage*)circleImage{
  if(!_circleImage){
    CGSize imageSize = CGSizeMake(CIRCLE_SIZE, CIRCLE_SIZE);
    CGFloat strokeWidth = 3;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);//[UIImage imageNamed:@"circle"];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor clearColor] setFill];
    CGContextFillRect(context, (CGRect){CGPointZero, imageSize});
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: (CGRect){CGPointMake(strokeWidth/2.0, strokeWidth/2.0),
                                                                    CGSizeMake(CIRCLE_SIZE-strokeWidth, CIRCLE_SIZE-strokeWidth)}];
    CGContextSaveGState(context);
    [[self.chartContainer elementFillColor] setFill];
    [ovalPath fill];
    CGContextRestoreGState(context);
    
    [[self.chartContainer elementStrokeColor] setStroke];
    [ovalPath setLineWidth:strokeWidth];
    [ovalPath stroke];
    
    _circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  return _circleImage;
}

#pragma mark - 
#pragma mark - Autolayout code

- (CGSize)intrinsicContentSize{
  CGFloat width = 0.0;
  NSUInteger totalElements = [self.chartContainer numberOfElements];
  for(int i = 0;i < totalElements;i++){
    width += [self.chartContainer spacingForElementAtRow:i];
  }
  
  width += [[self circleImage] size].width;
  if(width < [self preferredMinLayoutWidth]) width = [self preferredMinLayoutWidth];
  return CGSizeMake(width, UIViewNoIntrinsicMetric);
}

- (void)setPreferredMinLayoutWidth:(CGFloat)preferredMinLayoutWidth{
  if(_preferredMinLayoutWidth != preferredMinLayoutWidth){
    _preferredMinLayoutWidth = preferredMinLayoutWidth;
    if(CGRectGetWidth([self frame]) < preferredMinLayoutWidth){
      [self invalidateIntrinsicContentSize];
    }
  }
}

- (void)setupDefaultAppearence{
    
    _gradientStartColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    _gradientEndColor = [UIColor colorWithWhite:1.0 alpha:0.1];
}


-(void)setGradientStartColor:(UIColor *)gradientStartColor{
    
    _gradientStartColor = gradientStartColor;
    if(_gradientLayer){
        CGColorRef color1 = self.gradientStartColor.CGColor;
        CGColorRef color2 = self.gradientEndColor.CGColor;
        [_gradientLayer setColors:@[(__bridge id)color1,(__bridge id)color2]];
    }
}

-(void)setGradientEndColor:(UIColor *)gradientEndColor{
    
    _gradientEndColor = gradientEndColor;
    if(_gradientLayer){
        CGColorRef color1 = self.gradientStartColor.CGColor;
        CGColorRef color2 = self.gradientEndColor.CGColor;
        [_gradientLayer setColors:@[(__bridge id)color1,(__bridge id)color2]];
    }
}

@end
