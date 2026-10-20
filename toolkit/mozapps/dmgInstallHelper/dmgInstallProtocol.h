/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef DMGINSTALLPROTOCOL_H_
#define DMGINSTALLPROTOCOL_H_

#include <Foundation/Foundation.h>

@protocol DMGInstallProtocol
- (void)installDMGFromPath:(NSString*)bundlePath
                 withReply:(void (^)(BOOL))reply;
- (void)terminateDMGInstallHelper;
@end

#endif
