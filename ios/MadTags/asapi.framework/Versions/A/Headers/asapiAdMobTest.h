//
//  asapiAdMobTest.h
//  asapi
//
//  Created by Richard Andrades on 1/9/14.
//  Copyright (c) 2014 Alphonso Inc. All rights reserved.
//
//
// This file is only needed if you wish to receive test AdMob ads while you
// are testing the ASAPI Ad Network configured as a custom Mediation network
// with AdMob. This file is strictly optional, and in fact, it must be removed
// from your app once you are ready to submit it to the AppStore.
//
// Generally AdMob requres the app developer to receive test ads while testing
// an app on the developer's own test devices. This is because for a developer
// to display and click on real AdMob ads on a test device could be viewed as
// Ad fraud.
//
// AdMob provides a means for the developer to register his or her own test
// devices as test devices so that any AdMob ad requests on those devices
// will result in a test ad being shown instead of a real ad. This provides a
// "safe harbour" for the app developer.
//
// However, this mechanism does not work properly when AdMob has been configured
// to use ASAPI Ad network as a custom mediation network, AND if the developer
// wishes to verify that the ASAPI Ad Network is properly serving ASAPI
// test ads. The problem an app developer might face is described below.
//
// When setup for custom mediation, AdMob will query the ASAPI Ad network for
// an ad, and if ASAPI does not have an ad at that moment, then AdMob will
// fetch a "real" ad from it's own Ad network. Since this AdMob ad is a real
// ad being displayed on the developer's test device, it puts the developer
// at risk for violating the AdMob terms of service.
//
// But if the app developer tries to play it safe and register his or her
// device as a test device, then AdMob will never attempt to retrieve an
// ad from the ASAPI Ad Network. It seems that AdMob does not invoke the
// custom mediation interface on test devices. So, the developer will not
// be able to verify that the custom mediation between AdMob and ASAPI is
// actually working.
//
// To get around this problem, we provide the following testing-time API
// function. When an app developer wishes to test that the ASAPI and AdMob
// ad networks are working together in custom mediation mode without
// running the risk of violating the AdMob terms or service, simply
// add the following function call in the viewDidLoad ethod of the
// ViewController for the screen on which you are displaying an AdMob app.
//
// It is important to make sure that you never release an app to the AppStore
// without deleting or commenting out this function call, otherwise your
// app's users will see test ads.
//
// This is optional. SInce Alphonso has already tested the custom mediation
// interface between the AdMob SDK and the ASAPI SDK, you could just skip
// this entirely. We are providing this information in case you wish to
// verify it yourself.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



//
//
// Parameters:
// view_controller_delegate:  If you call this function within the viewDidLoad
//                            of the view that contains the AdMob ad banner, this
//                            parameter will be 'self'. Otherwise parameter should
//                            point to the viewController for the view that contains
//                            the AdMob ad banner.
//
// admob_ad_unit:             This is the AdUnit corresponding to the AdMob banner
//                            ad. This is the same parameter that you would provide
//                            as the adUnitID parameter to the GADBannerView.
//
// admob_dev_id:              This is the device id reported by AdMob in the Xcode
//                            console whenever you start your app. The log line printed
//                            by the AdMob SDK is of the following form:
// <Google> To get test ads on this device, call: request.testDevices = @[ @"acbd......................" ];
//
// These three parameters are used within the ASAPI framework in the following manner.
// This code is executed in the case where the ASAPI Ad network does not have an
// ad to display and wants to pass on the ad handling to the AdMob Ad network
// but requesting AdMob to retrieve a test ad instead of a real ad.
//
// {
//     GADBannerView *adBannerView = [[GADBannerView alloc] initWithAdSize:...];
//
//     // Specify the ad unit ID.
//     adBannerView.adUnitID = admob_ad_unit;
//
//     // Let the runtime know which UIViewController to restore after taking
//     // the user wherever the ad goes and add it to the view hierarchy.
//
//     adBannerView.rootViewController = view_controller_delegate;
//     [view_controller_delegate.view addSubview:adBannerView];
//
//      GADRequest *req = [GADRequest request];
//
//     // Make the request for a test ad.
//     req.testDevices = admob_dev_id;
//
// }
//
// You need to invoke this function in the viewDidLoad or viewWillAppear methods in
// the viewControllers for every view on which you display AdMob banner ads. You can
// also invoke this function with all parameters set to nil in the viewDidUnload methods.
//
//
void use_admob_test_ad(UIViewController *view_controller_delegate, NSString *admob_ad_unit, NSString *admob_dev_id);

