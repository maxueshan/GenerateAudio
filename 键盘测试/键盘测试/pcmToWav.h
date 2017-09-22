//
//  pcmToWav.h
//  键盘测试
//
//  Created by Gopay_y on 16/08/2017.
//  Copyright © 2017 Gopay_y. All rights reserved.
//

#ifndef pcmToWav_h
#define pcmToWav_h

#include <stdio.h>

int convertPcm2Wav(char *src_file, char *dst_file, int channels, int sample_rate);

#endif /* pcmToWav_h */
