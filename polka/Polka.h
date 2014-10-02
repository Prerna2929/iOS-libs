//
//  Polka.h
//  App
//
//  Created by Alvaro Talavera on 5/23/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

// MACROS
// --------------------------------------------


#define _PLK_SCREEN_SIZE    ([[UIScreen mainScreen] bounds].size)
#define _PLK_SCREEN_ORIGIN  ([[UIScreen mainScreen] bounds].origin)

#define _PLK_IPHONE_5_SCREEN_HEIGHT 568.f
#define _PLK_IPHONE_4_SCREEN_HEIGHT 480.f

#define _PLK_IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )_PLK_IPHONE_5_SCREEN_HEIGHT ) < DBL_EPSILON )

#define _PLK_IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define _PLK_IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define _PLK_IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define _PLK_IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "PLKObjects.h"

#import "PLKDatabase.h"
#import "PLKSimpleDatabase.h"

#import "PLKLocationManager.h"

#import "PLKNetUtils.h"
#import "PLKRequest.h"
#import "PLKRequest+Multi.h"
#import "PLKNetUpload.h"
#import "PLKNetDownload.h"
#import "PLKSocketClient.h"

#import "PLKColor.h"
#import "PLKButton.h"
#import "PLKButtonBar.h"
#import "PLKAlert.h"
#import "PLKScrollViewPaginator.h"
#import "PLKKeyboard.h"
#import "PLKKeyboardAttachedView.h"

#import "PLKTabBarController.h"

#import "PLKCache.h"
#import "PLKDate.h"
#import "PLKHash.h"
#import "PLKNumber.h"
#import "PLKString.h"
#import "PLKImage.h"

#import "PLKTextView.h"
#import "PLKTextFieldWithPadding.h"

#import "PLKTableViewCellSizeManager.h"



