//
//  AppDelegate.m
//  MagicTouch
//
//  Created by Pavel Gnatyuk on 7/27/13.
//  Copyright (c) 2013 Pavel Gnatyuk. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()

@property (retain) CAEmitterLayer *emitterLayer;

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    CGRect bounds = [[self window] bounds];
    UIViewController *controller = [[UIViewController alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:bounds];
    [view setBackgroundColor:[UIColor grayColor]];
    [controller setView:view];
    
    UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [view addGestureRecognizer:recongnizer];
    
    [[self window] setRootViewController:controller];
    [self.window makeKeyAndVisible];
    
    [recongnizer release];
    [view release];
    [controller release];
    
    CAEmitterCell *cell = [self makeEmitterCell];
    CAEmitterLayer *layer = [self makeEmitterLayerAtPoint:CGPointMake(160, 100)];
    [layer setEmitterCells:@[cell]];
    [[[[[self window] rootViewController] view] layer] addSublayer:layer];
    [self setEmitterLayer:layer];
    
    [self performSelector:@selector(autoStop) withObject:nil afterDelay:1.0];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)tapOnView:(id)sender
{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
    if ( [recognizer state] == UIGestureRecognizerStateRecognized ) {
        if ( [self emitterLayer] ) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoStop) object:nil];
            [[self emitterLayer] removeFromSuperlayer];
            [self setEmitterLayer:nil];
        }
        
        CGPoint point = [recognizer locationInView:recognizer.view];
        CAEmitterCell *cell = [self makeEmitterCell];
        CAEmitterLayer *layer = [self makeEmitterLayerAtPoint:point];
        [layer setEmitterCells:@[cell]];
        [[[[[self window] rootViewController] view] layer] addSublayer:layer];
        [self setEmitterLayer:layer];
        [self performSelector:@selector(autoStop) withObject:nil afterDelay:1.0];
    }
}

- (CAEmitterCell *)makeEmitterCell
{
	CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
	
	emitterCell.name = @"curve";
	emitterCell.enabled = YES;
    
	emitterCell.contents = (id)[[UIImage imageNamed:@"mysprite"] CGImage];
	emitterCell.contentsRect = CGRectMake(0.00, 0.00, 1.00, 1.00);
    
	emitterCell.magnificationFilter = kCAFilterNearest;
	emitterCell.minificationFilter = kCAFilterNearest;
	emitterCell.minificationFilterBias = 0.00;
    
	emitterCell.scale = 0.50;
	emitterCell.scaleRange = 1.40;
	emitterCell.scaleSpeed = 0.10;
    
	emitterCell.color = [[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00] CGColor];
	emitterCell.redRange = 1.00;
	emitterCell.greenRange = 1.00;
	emitterCell.blueRange = 1.00;
	emitterCell.alphaRange = 0.70;
    
	emitterCell.redSpeed = 0.00;
	emitterCell.greenSpeed = 0.00;
	emitterCell.blueSpeed = 0.00;
	emitterCell.alphaSpeed = 0.50;
    
	emitterCell.lifetime = 1.00;
	emitterCell.lifetimeRange = 0.40;
	emitterCell.birthRate = 17;
	emitterCell.velocity = 200.00;
	emitterCell.velocityRange = 50.00;
	emitterCell.xAcceleration = 100.00;
	emitterCell.yAcceleration = -250.00;
	emitterCell.zAcceleration = 7.00;
    
	// these values are in radians, in the UI they are in degrees
	emitterCell.spin = 0.000;
	emitterCell.spinRange = 0.785;
	emitterCell.emissionLatitude = 0.175;
	emitterCell.emissionLongitude = 1.047;
	emitterCell.emissionRange = 0.192;
    
    return emitterCell;
}

- (CAEmitterLayer *)makeEmitterLayerAtPoint:(CGPoint)point
{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    
	emitterLayer.name = @"emitterLayer";
	emitterLayer.emitterPosition = point;
	emitterLayer.emitterZPosition = 0;
    
	emitterLayer.emitterSize = CGSizeMake(1.00, 1.00);
	emitterLayer.emitterDepth = 0.00;
    
	emitterLayer.seed = 3087270819;
    return emitterLayer;
}

- (void)start
{
    [[self emitterLayer] setValue:@17 forKeyPath:@"emitterCells.curve.birthRate"];
}

- (void)stop
{
    NSLog(@"Entering %s", __FUNCTION__);
    [[self emitterLayer] setValue:@0 forKeyPath:@"emitterCells.curve.birthRate"];
}

- (void)autoStop
{
    NSLog(@"Entering %s", __FUNCTION__);
    [self stop];
}


@end
