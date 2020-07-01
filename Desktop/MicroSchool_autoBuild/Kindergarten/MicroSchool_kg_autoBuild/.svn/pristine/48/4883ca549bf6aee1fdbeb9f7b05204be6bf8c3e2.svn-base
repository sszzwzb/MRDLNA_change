#!/bin/sh

# 此脚本会将视频的解码部分的lib剥离出工程，使最后的ipa包的大小缩减10M左右。
# 后台通过判断是否需要添加视频监控的学校列表来确认是否调用这个脚本。

# 注意事项：每次提交到tag中的代码是正常带视频的工程，
# 需要在上面完整工程的基础上，进行手工剥离lib流程，如下所示：
#  1.copy一份完整的工程代码，打开工程并删除FFMpegDecoder，FFMpegiOS的引用。
#  2.把CCTV目录下的涉及到视频解码部分的代码注释掉，并保证编译通过。
#  3.将工程文件以及CCTV目录下的文件放到工程根目录下的StripCCTVProjFiles目录下。

# 删除视频lib文件
# rm -rf MicroSchool/Utilities/FFMpegDecoder 
# rm -rf MicroSchool/Utilities/FFMpegiOS

# # 替换工程文件以及CCTV相关文件
# # 当前工程目录
# projPath=""

# x=`echo $0 | grep "^/"`
# if test "${x}"; then
#         projPath=$(dirname $0)
# else
#         projPath=$(dirname `pwd`/$0)
# fi

# cp $projPath/StripCCTVProjFiles/CCTV/* $projPath/MicroSchool/UI/CCTV
# cp -r $projPath/StripCCTVProjFiles/MicroSchool/* $projPath/
