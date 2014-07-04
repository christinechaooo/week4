//
//  CanvasViewController.m
//  week4
//
//  Created by Christine Chao on 7/1/14.
//  Copyright (c) 2014 Christine Chao. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()

@property (strong, nonatomic) UIScrollView *scrollViewController;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIView *canvasView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

- (void)onScrollViewDrag:(UIPanGestureRecognizer *)sender;
- (void)onImageDrag:(UIPanGestureRecognizer *)sender;
- (void)onNewImgPan:(UIPanGestureRecognizer *)sender;
- (void)onNewImgPinch:(UIPinchGestureRecognizer *)sender;
- (void)onNewImgRotate:(UIRotationGestureRecognizer *)sender;

@end

@implementation CanvasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.canvasView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    //Set ScrollView Initial offset
    CGFloat contentOffSet = 0.0f;
    //Array to hold the images to displayed in the scrollView
    NSArray *imageNames = [NSArray arrayWithObjects:@"mouse",
                           @"lion",@"penguin", @"goat", @"manatee", @"runnerduck", nil];
    
    self.scrollViewController = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 548, 320, 120)];
    [self.scrollViewController setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:255.0/255.0 blue:240.0/255.0 alpha:1]];
    
    int count = 1;
	for (NSString *singleImageFilename in imageNames) {
        UIImage *img = [UIImage imageNamed:singleImageFilename];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(contentOffSet, (self.scrollViewController.frame.size.height - img.size.height) / 2, img.size.width, img.size.height)];
        imgView.image = img;
        
        UIPanGestureRecognizer *imgDrag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageDrag:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:imgDrag];
        imgView.tag = count;
        imgView.transform = CGAffineTransformMakeScale(0.5,0.5);
        [self.scrollViewController addSubview:imgView];
        contentOffSet += imgView.frame.size.width + 30;
		
		self.scrollViewController.contentSize = CGSizeMake(contentOffSet, self.scrollViewController.frame.size.height);
        count++;
	}
    
    [self.view addSubview:self.canvasView];
    [self.view addSubview:self.scrollViewController];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewDrag:)];
    [self.scrollViewController addGestureRecognizer:self.panGesture];
}

- (void)onScrollViewDrag:(UIPanGestureRecognizer *)sender {
    CGPoint gestureVelocity = [sender velocityInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    
    sender.view.center = CGPointMake(sender.view.center.x, sender.view.center.y + translation.y);
//    NSLog(@"%f", sender.view.center.y);
    
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        if(self.scrollViewController.center.y < 508) {
            self.scrollViewController.center = CGPointMake(sender.view.center.x , 508);
        } else {
            
        }
    } else if (sender.state == UIGestureRecognizerStateEnded){
        if(gestureVelocity.y > 0) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.scrollViewController.center = CGPointMake(sender.view.center.x, 608);
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
        } else if(gestureVelocity.y < 0) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.scrollViewController.center = CGPointMake(sender.view.center.x, 508);
                                 
                             } completion:^(BOOL finished) {
                                 sender.enabled = NO;
                             }];
        }
    }
}

- (void)onImageDrag:(UIPanGestureRecognizer *)sender {
//    NSLog(@"img dragged!");

    CGPoint touchPosition = [sender locationInView:self.view];
//    CGPoint translation = [sender translationInView:self.scrollViewController];
    
//    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        /*switch ([sender.view tag]) {
            case 1:
                NSLog(@"1");
                break;
            case 2:
                NSLog(@"2");
                break;
            case 3:
                NSLog(@"3");
                break;
            case 4:
                NSLog(@"4");
                break;
            case 5:
                NSLog(@"5");
                break;
            case 6:
                NSLog(@"6");
                break;
            default:
                break;
        }*/
        UIImageView *prevImgView = (UIImageView *)sender.view;
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(prevImgView.frame.origin.x, prevImgView.frame.origin.y + self.scrollViewController.frame.origin.y, prevImgView.image.size.width, prevImgView.image.size.height)];
        
        self.imgView.image = prevImgView.image;
        self.imgView.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *imgPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onNewImgPan:)];
        [self.imgView addGestureRecognizer:imgPan];
        
        UIPinchGestureRecognizer *imgPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onNewImgPinch:)];
        [self.imgView addGestureRecognizer:imgPinch];
        
        UIRotationGestureRecognizer *imgRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onNewImgRotate:)];
        [self.imgView addGestureRecognizer:imgRotate];
        
        [self.canvasView addSubview:self.imgView];
        self.imgView.center = CGPointMake(touchPosition.x, touchPosition.y);
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"%f, %f", touchPosition.x, touchPosition.y);
        self.imgView.center = CGPointMake(touchPosition.x, touchPosition.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.imgView.center.y > self.scrollViewController.frame.origin.y) {
            [self.imgView removeFromSuperview];
        }
    }
    

}

- (void)onNewImgPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.canvasView bringSubviewToFront:sender.view];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
       
    
    }
    
}

- (void)onNewImgPinch:(UIPinchGestureRecognizer *)sender {
    NSLog(@"pinch!");
    CGFloat scale = sender.scale;
    sender.view.transform = CGAffineTransformScale(sender.view.transform,scale,scale);
    sender.scale = 1.0;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.canvasView bringSubviewToFront:sender.view];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        
    }
}

- (void)onNewImgRotate:(UIRotationGestureRecognizer *)sender {
    NSLog(@"rotate!");
    CGFloat angle = sender.rotation;
    sender.view.transform = CGAffineTransformRotate(sender.view.transform, angle);
    sender.rotation = 0.0;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.canvasView bringSubviewToFront:sender.view];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
