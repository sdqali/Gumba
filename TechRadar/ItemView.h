#import <UIKit/UIKit.h>

@interface ItemView : UIView <UIActionSheetDelegate>
@property (nonatomic, assign) NSInteger entry;
@property (nonatomic, strong) NSString* blipName;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, assign) BOOL isMinized;
- (id)initWithFrame:(CGRect)frame AndEntry:(NSInteger)entry AndBlip:(NSString*)blipName AndType:(NSString*)type AndRadius:(NSInteger) radius;
-(void) drawTextWithContext:(CGContextRef)context Text:(NSString*)text Font:(UIFont*)font At:(CGPoint) point Angle:(CGFloat)angle;
-(void) minimize;
-(void) maximize;
@end
