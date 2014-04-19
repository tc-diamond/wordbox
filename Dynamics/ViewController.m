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
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;

@property (weak, nonatomic) UIView *movedView;
@property (weak, nonatomic) UIView *selectedView;
@property (strong, nonatomic) NodeView *parrentView;

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
    self.parrentView = self.viewAnimated;
    
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
    self.dynamicItemBehavior = ({
        UIDynamicItemBehavior *behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.viewAnimated]];
        behavior.resistance = 0.f;
        behavior.allowsRotation = NO;
        behavior.elasticity = 0.f;
        behavior.friction = 0.f;
        [self.animator addBehavior:behavior];
        behavior;
    });
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.viewAnimated] ];
    collision.collisionDelegate = self;
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    UIPanGestureRecognizer *gr = ({
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panned:)];

        pan;
    });
    [self.view addGestureRecognizer:gr];

    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tg];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressed:)];
    [self.view addGestureRecognizer:longpress];
    
    self.attachment.length = 100;
    
    self.attachment.damping = 1.;
    self.attachment.frequency = 10;
    
    [self.animator addBehavior:self.attachment];
    
}

- (void)panned:(UIPanGestureRecognizer*)tg
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

- (void)tapped:(UITapGestureRecognizer*)tg
{
    UIView *tappedView = [self.view hitTest:[tg locationInView:self.view]
                              withEvent:nil];
    if ([self.view isEqual:tappedView] || !tappedView) {
        return;
    }
    
    self.snap = [[UISnapBehavior alloc]initWithItem:tappedView snapToPoint:self.view.center];
    
}

- (void)longPressed:(UILongPressGestureRecognizer*)gr
{
    NodeView *pressedView = (NodeView*)[self.view hitTest:[gr locationInView:self.view]
                                  withEvent:nil];
    if ([self.view isEqual:pressedView] || !pressedView) {
        return;
    }
    
    self.parrentView = pressedView;
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
    NodeView *childView = [[NodeView alloc]initWithWord:@"Test word" partOfSpeech:arc4random() % 3 parrent:self.parrentView];
    [self.view insertSubview:childView belowSubview:self.parrentView];
    [self.parrentView addChild:childView];
    [self.collision addItem:childView];
    [self.dynamicItemBehavior addItem:childView];
    self.attachment = [[UIAttachmentBehavior alloc]initWithItem:self.parrentView attachedToItem:childView];
    self.attachment.length = self.parrentView.childViews.count <= 6 ? 100 : 200;
    self.attachment.damping = 1.;
    self.attachment.frequency = 6;
    
    [self.animator addBehavior:self.attachment];
}

@end
