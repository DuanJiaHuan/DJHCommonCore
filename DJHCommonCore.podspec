
Pod::Spec.new do |s|

  # ―――  规范元数据  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "DJHCommonCore" #框架名
  s.version      = "1.0.0" #当前版本（注意，是当前版本，假如你后续更新了新版本，需要修改此处）
  s.summary      = "项目开发的公共库，与业务层无关." #简要描述，在pod search的时候会显示该信息
  s.description  = "项目开发的公共库，与业务层无关,供其他模块工程使用" #详细描述
  s.homepage     = "https://github.com/DuanJiaHuan/DJHCommonCore.git" #页面链接，可填宣传页

  # ―――  规格许可证  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "LICENSE" #开源协议

  # ――― 作者元数据  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "duanjiahuan" => "duanjiahuan@163.com" } #作者

  # ――― 平台详细信息 ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.platform     = :ios #支持最低ios版本
  s.platform     = :ios, "8.0"
  #  When using multiple platforms
  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  # ――― 源位置 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/DuanJiaHuan/DJHCommonCore.git", :tag => "#{s.version}" } #源码git地址

  # ――― 源代码 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "DJHCommonCore/DJHCommonCore.h" #源文件（可以包含.h和.m）,使用的是真实的物理路径，包含Classes目录下的所有.h .m文件
  # s.exclude_files = "Classes/Exclude"
  s.public_header_files = "DJHCommonCore/DJHCommonCore.h" #头文件(.h文件)，如果不指定那么source_files中的所有header都被认为是公共的

  # ――― 资源 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.resource  = "icon.png" #资源文件（配置的文件都会被放到mainBundle中）
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # ――― 项目链接 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.framework  = "SomeFramework" #依赖的系统框架
  # s.frameworks = "UIKit", "Foundation"
  # s.vendored_frameworks = "" #依赖的非系统框架
  # s.library   = "iconv" #依赖的系统库
  # s.libraries = "iconv", "xml2"
  # vendored_libraries = "" #依赖的非系统的静态库

  # ――― 项目设置 ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true #使用ARC

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "AFNetworking" #依赖的三方库，pod库或者可以是自身的subspec

  # ――― subspec ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.subspec 'DJHNetworking' do |ss| #组件
    ss.dependency 'AFNetworking' #依赖其他层级时使用的是层级路径
    ss.source_files = 'DJHCommonCore/Classes/DJHNetworking'
    ss.public_header_files = 'DJHCommonCore/Classes/DJHNetworking/*.h'
  end

  s.subspec 'DJHBaseClass' do |ss| #组件
    ss.dependency 'YYKit' #依赖其他层级时使用的是层级路径
    ss.source_files = 'DJHCommonCore/Classes/DJHBaseClass'
    ss.public_header_files = 'DJHCommonCore/Classes/DJHBaseClass/*.h'
  end

end
