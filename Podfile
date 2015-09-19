# Podfile
platform :ios, '8.0'

xcodeproj 'SwiftOrganizer.xcodeproj'

use_frameworks!

link_with 'SwiftOrganizer', 'DataBaseKit'

# Available pods

def available_pods
    pod 'Parse'
end

target 'SwiftOrganizer' do
    available_pods
end

target 'DataBaseKit' do
    available_pods
end
