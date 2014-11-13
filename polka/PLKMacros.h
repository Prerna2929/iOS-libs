//
//  PLKMacros.h
//  App
//
//  Created by Alvaro Talavera on 5/23/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

// MACROS
// --------------------------------------------

#ifndef Ticketea_PLKMacros_h
#define Ticketea_PLKMacros_h

#define _PLK_SCREEN_SIZE    ([[UIScreen mainScreen] bounds].size)
#define _PLK_SCREEN_ORIGIN  ([[UIScreen mainScreen] bounds].origin)

#define _PLK_IPHONE_5_SCREEN_HEIGHT 568.f
#define _PLK_IPHONE_4_SCREEN_HEIGHT 480.f

#define _PLK_IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )_PLK_IPHONE_5_SCREEN_HEIGHT ) < DBL_EPSILON )

#define _PLK_IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define _PLK_IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define _PLK_IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define _PLK_IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#endif
