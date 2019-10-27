workspace 'MyBudget.xcworkspace'

xcodeproj 'MyBudget/MyBudget.xcodeproj'
xcodeproj 'MyBudget_MacOS/MyBudget_MacOS.xcodeproj'

target 'MyBudget' do
   xcodeproj 'MyBudget/MyBudget.xcodeproj'
	# Comment the next line if you don't want to use dynamic frameworks
	use_frameworks!

	# Pods for MyBudget
	pod 'ValueCoding', '~> 3.0.0'
	
	source 'https://github.com/CocoaPods/Specs.git'
	pod 'SideMenu', '~> 6.0'
	
	pod 'paper-onboarding', '~> 6.1.3'
	
	pod 'SwiftyStoreKit'
	pod 'BulletinBoard'
	pod 'Charts', '~> 3.3.0'
end

 
target 'MyBudget_MacOS' do
	xcodeproj 'MyBudget_MacOS/MyBudget_MacOS.xcodeproj'

	# Comment the next line if you don't want to use dynamic frameworks
	use_frameworks!

	# Pods for MyBudget_MacOS
	pod 'ValueCoding', '~> 3.0.0'

	pod 'Charts', '~> 3.3.0'
	
	pod 'SwiftyStoreKit'
end

