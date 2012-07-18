#import "Item.h"

@implementation Item
@synthesize name= _name,index = _index,theta = _theta, radius = _radius;

-(id) initWithName:(NSString*)name Index:(NSInteger)index Radius:(NSInteger)radius End:(NSInteger)theta{
    self =   [super init];
    if(self){
        _name = name;
        _index = index;
        _theta = theta;
        _radius = radius;
    }
    return self;
}

-(CGPoint) raster{
    CGFloat x = _radius * cos((_theta * M_PI/180));
    CGFloat y = _radius * sin((_theta * M_PI/180));  
    return CGPointMake(x,y);
}
@end