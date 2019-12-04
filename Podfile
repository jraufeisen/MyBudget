workspace 'MyBudget.xcworkspace'

project 'MyBudget/MyBudget.xcodeproj'
project 'MyBudget_MacOS/MyBudget_MacOS.xcodeproj'

target 'MyBudget' do
   project 'MyBudget/MyBudget.xcodeproj'
   platform :ios, '12.4'
	# Comment the next line if you don't want to use dynamic frameworks
	use_frameworks!

	# Pods for MyBudget
	pod 'ValueCoding', '~> 3.0.0'
		
	pod 'paper-onboarding', '6.1.3'
	pod 'SwiftyStoreKit', '0.15.0'
	pod 'BulletinBoard', '4.0.0'
	pod 'Charts', '~> 3.3.0'
	pod 'MaterialComponents/ProgressView', '88.0.1'
	pod "WSTagsField", '5.2.0'
end

 
target 'MyBudget_MacOS' do
	project 'MyBudget_MacOS/MyBudget_MacOS.xcodeproj'
   platform :osx, '10.14'
	# Comment the next line if you don't want to use dynamic frameworks
	use_frameworks!

	# Pods for MyBudget_MacOS
	pod 'ValueCoding', '~> 3.0.0'
	pod 'Charts', '~> 3.3.0'
	pod 'SwiftyStoreKit'
end

