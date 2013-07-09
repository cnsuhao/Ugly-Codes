//
//  UCCodeSample.m
//  UglyCodeSamples
//
//  Created by Yao Melo on 7/9/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "UCCodeSample.h"

@implementation UCCodeSample

- (void)addReadyScreenMessage
{
    DDLogInfo(@"----- addReadyScreenMessage -----");
    
    systemReadyForCall = YES;
    didReconnectSinceLastDisconnect = YES;
    CGRect rect = readyForCallView.frame;
    
    [self removeAllScreenMessages];
    [readyForCallView setFrame:CGRectMake(630, 370, rect.size.width, rect.size.height)];
    
    NSDictionary *parameters = [[DAOManager sharedInstance].clientFeatureDAO featureForCode:FC_TERMOFUSE].parameters;
    NSString *parameterValue = [parameters objectForKey:FK_FLAG];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL didShowAnnotationInfo = [defaults boolForKey:@"didShowTermOfUse"];
    BOOL delayShowFlag = false;
    if(parameterValue && [parameterValue isEqualToString:FV_TERMOFUSE_EM] && !didShowAnnotationInfo){
        delayShowFlag = YES;
        self.termOfUseTextView.hidden = NO;
        [loginIndicatorBk setHidden:YES];
        [loginLoadingLabel setHidden:YES];
        [loginActivityIndicator setHidden:YES];
        [loginActivityIndicator stopAnimating];
    }
    [defaults setBool:YES forKey:@"didShowTermOfUse"];
    [defaults synchronize];
    
    if (!initTabView) {
        if(delayShowFlag){
            [self performSelector:@selector(initNewTabBarViewController) withObject:nil afterDelay:5];
        } else {
            [self initNewTabBarViewController];
        }
        initTabView = YES;
    }
    //    if ([UserRegistration sharedManager].otherSipUserName == nil){
    //        [self.CallTo setText:NSLocalizedString(@"( Select to make call )",@"")];
    //    }
    //    else {
    //        [self.CallTo setText:[UserRegistration sharedManager].otherSipUserName];
    //    }
    //re-login would cause othersipusername changes nil
    if ([self.CallTo.text isEqual:@"Label"])
        [self.CallTo setText:NSLocalizedString(@"( Select to make call )",@"")];
    
    [self.view insertSubview:readyForCallView belowSubview:callAlertView];
    //    if (![LAUtilities getSessionServerFlag]) {
    //        self.startButton.hidden = YES;
    //    }
    //logButton.hidden = NO;
    NSDictionary *debugLogFeature = [[DAOManager sharedInstance].clientFeatureDAO featureForCode:FC_DEBUG].parameters;
    // NSString *debugLogFeatureValue = [debugLogFeature objectForKey:@"flag"];
    BOOL debugLogFeatureBool = [[debugLogFeature objectForKey:@"flag"]boolValue];
    if (debugLogFeatureBool) {
        ddLogLevel = LOG_LEVEL_INFO;
        logButton.hidden = NO;
        [LAUtilities setShouldShowDebuggingMessages:YES];
        //        [LogHandler checkForLogDirectory];
        [LAUtilities showDebuggingMessageTitle:nil
                                      withBody:NSLocalizedString(@"Set Debug Log File ON", @"")];
    }else {
        ddLogLevel = LOG_LEVEL_WARN;
        logButton.hidden = YES;
        [LAUtilities setShouldShowDebuggingMessages:NO];
        //        [LogHandler deleteLocalLogFile];
    }
    
    NSDictionary *CRMODFeature = [[DAOManager sharedInstance].clientFeatureDAO featureForCode:FC_CRMOD].parameters;
    // NSString *CRMODFeatureValue = [CRMODFeature objectForKey:@"flag"];
    BOOL CRMODFeatureBool = [[CRMODFeature objectForKey:@"flag"]boolValue];
    if (CRMODFeatureBool) {
        
        self.CRMODBtn.hidden = NO;
    }else {
        self.CRMODBtn.hidden = YES;
    }
    
    //settingButton.hidden = NO;
    // for ipad placed call --cuckoo
    [self configSupportID];
    // Add whether this iPad is a CSR/TSR or any other group name as well as the user's name
    NSString* username = [DAOManager sharedInstance].userProfileDAO.userProfile.canonicalName;
    
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //
    NSString * version = [NSString stringWithFormat:@"%@ | %@ | %@ %@ | @%@", [username uppercaseString],
                          [DAOManager sharedInstance].serverSettingDAO.sipprofileModel.sipsupporttype,
                          NSLocalizedString(@"Version", @"Version word"),
                          buildVersion,
                          [NSString stringWithString:[defaults stringForKey:kSessionServerIPKey]]];
    self.versionLabel.text = version;
    // See if we need to have the settings button
    //    uinfoModel *umodel = (uinfoModel*)[[SessionsManager sharedclass].registrationClasses
    //                                       objectForKey:kuinfoModel];
    //    if ([umodel.debug isEqualToString:@"1"])
    //    {
    //        [self.settingButton setHidden:NO];
    //    }
    // Let's check if we received the version information from session server
    // and accordingly show an alert to user
    //    if (uModel)
    //    {
    //        if([uModel.version length] >0)
    //        {
    //            // We did receive the version information from sessions server
    //            if (![buildVersion isEqualToString:uModel.version])
    //            {
    //                // show system latest version
    //                self.versionLabel.text = [NSString stringWithFormat:@"%@ | %@: %@",version,NSLocalizedString(@"Please upgrade to",@"System latest version label"),uModel.version];
    //            }
    //        }
    //    }
    //
    // Dismiss all Alertveiw - Themis
    [self checkViews:[[UIApplication sharedApplication] windows]];
    // Dismiss all AlertVeiw - Themis
}

@end
