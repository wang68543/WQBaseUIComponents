

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "WQBaseUIComponents"
  s.version      = "0.0.4"
  s.summary      = "基础组件(UI部分)"

  s.description  = <<-DESC 
                      平常自己使用一些频率比较高得工具、控件的封装,后期使用的时候也不断维护、更新 
                    DESC

  s.homepage     = "https://github.com/wang68543/WQBaseUIComponents"

  s.license      = "MIT"
  s.author             = { "王强" => "wang68543@163.com" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios
  s.platform     = :ios, "8.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/wang68543/WQBaseUIComponents.git", :tag => "#{s.version}" }
  s.requires_arc = true
  # s.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

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
     ss.source_files = 'WQBaseUIComponents/CommonTableView/**/*.{h,m}'
  end
end
