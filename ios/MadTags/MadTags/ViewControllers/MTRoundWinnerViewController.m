//
//  MTRoundWinnerViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTRoundWinnerViewController.h"
#import "MTSentenceUtils.h"

#define kPadding 10.0
#define kGreen [UIColor colorWithRed:0.318 green:0.509 blue:0.166 alpha:1.000]
#define kBlue [UIColor colorWithRed:0.057 green:0.259 blue:0.782 alpha:1.000]

@interface MTRoundWinnerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sentenceLabel;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

@end

@implementation MTRoundWinnerViewController

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
    
    self.endButton.layer.cornerRadius = floor( self.endButton.bounds.size.width / 2.0 );
    
//    MTCardView *cardView = [[MTCardView alloc] initWithFrame:CGRectMake(0, 0, self.cardViewContainer.bounds.size.width, self.cardViewContainer.bounds.size.height + 40)];
//    self.cardView = cardView;
//    self.cardView.delegate = self;
//    self.cardView.buttonState = kMTButtonStateWinner;
//    self.cardView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.cardViewContainer addSubview:self.cardView];
//    self.cardViewContainer.backgroundColor = [UIColor clearColor];
    
    NSAttributedString *attributedString = [MTSentenceUtils attributedStringForSentence:self.card.sentence withWords:self.card.words textColor:[UIColor whiteColor] highlightColor:kGreen];
    self.sentenceLabel.attributedText = attributedString;
    
    CGSize size = [self.sentenceLabel sizeThatFits:CGSizeMake( self.sentenceLabel.bounds.size.width - kPadding*2, 100.0 )];
    self.sentenceLabel.frame = CGRectMake( kPadding, kPadding, self.sentenceLabel.bounds.size.width - kPadding*2, size.height );
}

-(void) viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
}

-(void) setCard:(MTCard *)card;
{
    _card = card;
    
    NSAttributedString *attributedString = [MTSentenceUtils attributedStringForSentence:self.card.sentence withWords:self.card.words textColor:[UIColor whiteColor] highlightColor:kGreen];
    self.sentenceLabel.attributedText = attributedString;
    
    CGSize size = [self.sentenceLabel sizeThatFits:CGSizeMake( self.sentenceLabel.bounds.size.width - kPadding*2, 100.0 )];
    self.sentenceLabel.frame = CGRectMake( kPadding, kPadding, self.sentenceLabel.bounds.size.width - kPadding*2, size.height );
}

- (IBAction)didClickNext:(id)sender;
{
    [self.delegate didClickStart];
}

@end
