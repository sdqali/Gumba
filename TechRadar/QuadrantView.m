#import "QuadrantView.h"
#import "CircleView.h"
#import "TriangleView.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppConstants.h"
#import "Item.h"

@implementation QuadrantView

@synthesize center, frameOrigin, quadrant = _quadrant;

- (void) drawArcTitles :(CGContextRef) context withTitle:(NSString*)label Width:(CGFloat)width Height:(CGFloat)distance{
    [[UIColor whiteColor] set];
    UIFont *font = [UIFont systemFontOfSize:18];
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.center.x +width, self.center.y+distance);
    CGAffineTransform textTransform = CGAffineTransformMakeRotation(-1.57/2.0);
    CGContextConcatCTM(context, textTransform);
    CGContextTranslateCTM(context, -(self.center.x +width), -(self.center.y+distance));
    [label drawAtPoint:CGPointMake(self.center.x +width, self.center.y+distance) withFont:font];
    CGContextRestoreGState(context);
}
- (void) resize:(UINavigationItem*)navigationItem{
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:animationIDfinished:finished:context:)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.50];
	[UIView setAnimationTransition:([self superview] ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromLeft)
                           forView:self
                             cache:NO];
    CGRect resized;
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height-Y_OFFSET-NAVBAR_SIZE;
    if(self.frame.size.height == screenHeight){
        navigationItem.hidesBackButton=NO;
        for(CircleView *subView in self.subviews){
            [subView minimize];
            [subView setNeedsDisplay];
        }
        resized = CGRectMake(self.frameOrigin.x, self.frameOrigin.y, screenWidth/2, screenHeight/2);
    } else {
        navigationItem.hidesBackButton=YES;
        for(CircleView *subView in self.subviews){
            [subView maximize];
            [subView setNeedsDisplay];
        }
        resized = CGRectMake(0, Y_OFFSET, screenWidth, screenHeight);
        [self.superview bringSubviewToFront:self];
    }
    self.frame = resized;	
	[UIView commitAnimations];	
}


-(void) drawQuadrantLabelInContext:(CGContextRef)context{
    float labelX = self.frame.size.width/3.0;
    float labelYDelta = 60.0;
    float labelY=0;
    
    if(self.frameOrigin.y == Y_OFFSET){
        labelY = labelYDelta;
    } else {
        labelY = self.frame.size.height - labelYDelta;
    }
    
    UIGraphicsPushContext(context);
    [[UIColor whiteColor] set]; 
    UIFont *font = [UIFont systemFontOfSize:20];
    CGPoint textPoint = CGPointMake(labelX,labelY);
    [[_quadrant name] drawAtPoint:textPoint withFont:font];
    UIGraphicsPopContext();
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, M_PI*2.0, true);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}   

-( CGPoint) adjustPoint:(CGPoint) point {
    if(point.x < 0){
        point.x = self.frame.size.width + point.x;
    } 
    if(point.y <0){
        point.y = (point.y * -1);
    } else {
        point.y = (self.frame.size.height - point.y);
    }
    return CGPointMake(point.x,point.y);
}

-(void) drawBackgroundGradient : (CGContextRef) context{
    CGContextDrawLinearGradient (context, [AppConstants backgroundGradient], CGPointMake(0.0, 0.0), 
                                 CGPointMake(self.frame.size.width, self.frame.size.height), 0);
}

- (id)initWithFrame:(CGRect)frame WithCenter:(CGPoint)point AndQuadrant:(Quadrant*)quadrant{
    self = [super initWithFrame:frame];
    if (self) {
        self.frameOrigin=self.frame.origin;
        self.center = point;
        _quadrant = quadrant;
    }
    return self;
}

- (void)addCircleViews {
    NSMutableArray *circles = [_quadrant circles];
    for(Item *circle in circles){
        CGPoint point = [self adjustPoint:[circle raster]];
        CGRect someRect = CGRectMake(point.x-10.0, point.y-10.0, 20.0, 20.0);
        CircleView *circleView = [[CircleView alloc] initWithFrame:someRect Entry:[circle index] Tip:[circle tip]  Blip:[circle name] Type:@"c.png" Radius:[circle radius]];
        [self insertSubview:circleView atIndex:0];
    }
}

- (void)addTriangleViews {
    NSMutableArray *triangles = [_quadrant triangles];    
    for(Item *triangle in triangles){
        CGPoint point = [self adjustPoint:[triangle raster]];
        CGRect someRect = CGRectMake(point.x-10.0, point.y-10.0, 20.0, 20.0);
        TriangleView *triangleView = [[TriangleView alloc] initWithFrame:someRect Entry:[triangle index] Tip:[triangle tip] Blip:[triangle name] Type:@"t.png" Radius:[triangle radius]];
        [self insertSubview:triangleView atIndex:0];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();     
    
    [self drawBackgroundGradient:context];
    
    CGContextSetLineWidth(context, 2.0);
    [[UIColor whiteColor] setStroke];
    
    [self drawCircleAtPoint:self.center withRadius:150*RADAR_RATIO inContext:context];
    [self drawCircleAtPoint:self.center withRadius:275*RADAR_RATIO inContext:context];
    [self drawCircleAtPoint:self.center withRadius:350*RADAR_RATIO inContext:context];    
    [self drawCircleAtPoint:self.center withRadius:400*RADAR_RATIO inContext:context];    
    
    CGRect    myFrame = self.bounds;
    CGContextSetLineWidth(context, 1);
    CGRectInset(myFrame, 2, 2);
    [[UIColor whiteColor] set];
    UIRectFrame(myFrame);
    
    [self drawArcTitles:context withTitle:@"Adopt" Width:80.0*RADAR_RATIO Height:130.0*RADAR_RATIO];
    [self drawArcTitles:context withTitle:@"Trial" Width:165.0*RADAR_RATIO Height:225.0*RADAR_RATIO];
    [self drawArcTitles:context withTitle:@"Assess" Width:210.0*RADAR_RATIO Height:280.0*RADAR_RATIO];
    [self drawArcTitles:context withTitle:@"Hold" Width:250.0*RADAR_RATIO Height:315.0*RADAR_RATIO];
    
    [self drawQuadrantLabelInContext:context];
}
@end