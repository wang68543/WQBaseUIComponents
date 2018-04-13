

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "WQBaseUIComponents"
  #弄错了 版本号
  s.version      = "0.1.6"
  s.summary      = "基础组件(UI部分)"

  s.description  = <<-DESC 
                      平常自己使用一些频率比较高得工具、控件的封装,后期使用的时候也不断维护、更新 
                    DESC

  s.homepage     = "https://github.com/wang68543/WQBaseUIComponents"

  s.license      = "MIT"
  s.author             = { "王强" => "wang68543@163.com" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios, "8.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/wang68543/WQBaseUIComponents.git", :tag => "#{s.version}" }
  s.requires_arc = true
  # s.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "WQBaseUIComponents/WQBaseUIComponents.h"

  
   s.subspec 'AnmationViews' do |ss|
    ss.subspec 'Animation' do |sss|
      sss.source_files = 'WQBaseUIComponents/AnmationViews/Animation/*.{h,m}'
    end 
  end
   s.subspec 'UICustom' do |ss|
    ss.subspec 'ViewCustom' do |sss|
      sss.source_files = 'WQBaseUIComponents/UICustom/ViewCustom/*.{h,m}'
    end 
     ss.subspec 'StarView' do |sss|
      sss.source_files = 'WQBaseUIComponents/UICustom/StarView/*.{h,m}'
    end 
    # ss.subspec 'ViewInherit' do |sss|
    #   sss.dependency 'WQBaseUIComponents/UICustom/ViewCustom'
    #   sss.source_files = 'WQBaseUIComponents/UICustom/ViewInherit/*.{h,m}'
    # end 
    
  end
  
  s.subspec 'UICategory' do |ss|
     ss.subspec 'UICategory_Vendor' do |sss|
      sss.subspec 'UIImage_Category' do |ssss| 
      	ssss.source_files = 'WQBaseUIComponents/UICategory/UICategory_Vendor/UIImage_Category/*.{h,m}'
      end
      sss.source_files = 'WQBaseUIComponents/UICategory/UICategory_Vendor/*.{h,m}'
    end 
    ss.subspec 'UICategory_UIKit' do |sss|
      sss.dependency 'WQBaseUIComponents/UICategory/UICategory_Vendor'
      sss.source_files = 'WQBaseUIComponents/UICategory/UICategory_UIKit/*.{h,m}'
    end 
    ss.subspec 'UICategory_NetWork' do |sss|
      sss.source_files = 'WQBaseUIComponents/UICategory/UICategory_NetWork/*.{h,m}'
    end 
    
   end


  s.subspec 'UILoading' do |ss|
  	  ss.dependency 'MBProgressHUD', '~> 1.0.0'
      ss.resource = 'WQBaseUIComponents/UILoading/MBProgressHUD.bundle'
      ss.source_files = 'WQBaseUIComponents/UILoading/*.{h,m}'
   end
  s.subspec 'UIHelp' do |ss|
    ss.subspec 'UIFounctionHelp' do |sss|
      sss.source_files = 'WQBaseUIComponents/UIHelp/UIFounctionHelp/*.{h,m}'
    end 
     ss.subspec 'UITransitionHelp' do |sss|
      sss.source_files = 'WQBaseUIComponents/UIHelp/UITransitionHelp/*.{h,m}'
    end 
   end
   
    s.subspec 'WQCommonTableView' do |ss|
     ss.dependency 'WQBaseUIComponents/UIHelp'
     ss.dependency 'Masonry', '>= 1.0.2'
     ss.source_files = 'WQBaseUIComponents/CommonTableView/**/*.{h,m}'
  end
     s.dependency 'SDWebImage'
end
