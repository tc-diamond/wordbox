//
//  ViewController.m
//  Dynamics
//
//  Created by Dmitri Doroschuk on 12.04.14.
//  Copyright (c) 2014 Dmitri Doroschuk. All rights reserved.
//

#import "ViewController.h"
#import "NodeView.h"

@interface ViewController () <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet NodeView *viewAnimated;
@property (weak, nonatomic) IBOutlet UIView *viewAnchor;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior * collision;
@property (strong, nonatomic) UISnapBehavior *snap;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;

@property (weak, nonatomic) UIView *movedView;
@property (weak, nonatomic) UIView *selectedView;

- (IBAction)addChild:(id)sender;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.selectedView = self.viewAnimated;
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.animator.delegate = self;
    
    self.viewAnimated.layer.cornerRadius = self.viewAnimated.bounds.size.width / 2;
//    self.viewAnimated.userInteractionEnabled = NO;
    self.collision = ({
        UICollisionBehavior *cB = [[UICollisionBehavior alloc]initWithItems:@[self.viewAnimated]];
        cB.collisionDelegate = self;
        [self.animator addBehavior: cB];
        cB;
    });
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.viewAnimated] ];
    collision.collisionDelegate = self;
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    UIPanGestureRecognizer *gr = ({
        UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];

        tap;
    });
    
    [self.view addGestureRecognizer:gr];
    
    self.attachment.length = 100;
    
    self.attachment.damping = 1.;
    self.attachment.frequency = 10;
    
    [self.animator addBehavior:self.attachment];
    
}

- (void)tapped:(UIPanGestureRecognizer*)tg
{
    if (tg.state == UIGestureRecognizerStateBegan) {
        self.movedView = [self.view hitTest:[tg locationInView:self.view]
                                                withEvent:nil];
    }
    
    if ([self.view isEqual:self.movedView]) {
        return;
    }
    
    self.snap = [[UISnapBehavior alloc]initWithItem:self.movedView snapToPoint:[tg locationInView:self.view]];

    if (tg.state == UIGestureRecognizerStateEnded) {
        self.movedView = nil;
        self.snap = nil;
    }
}

- (void)setSnap:(UISnapBehavior *)snap
{
    if (_snap) {
        [self.animator removeBehavior:_snap];
        snap = nil;
    }
    
    _snap = snap;
    [self.animator addBehavior:snap];
}

- (void)setAttachment:(UIAttachmentBehavior *)attachment
{
    if (_attachment) {
//        [self.animator removeBehavior:_attachment];
//        _attachment = nil;
    }
    
    _attachment = attachment;
}

- (IBAction)addChild:(id)sender
{
    NodeView *childView = [[NodeView alloc]initWithWord:@"Test word" partOfSpeech:arc4random() % 3 parrent:self.viewAnimated];
    [self.view insertSubview:childView belowSubview:self.viewAnimated];
    [self.viewAnimated addChild:childView];
    [self.collision addItem:childView];
    
    self.attachment = [[UIAttachmentBehavior alloc]initWithItem:self.viewAnimated attachedToItem:childView];
    self.attachment.length = self.viewAnimated.childViews.count <= 6 ? 100 : 200;
    
    self.attachment.damping = 1.;
    self.attachment.frequency = 10;
    
    [self.animator addBehavior:self.attachment];
}

@end
