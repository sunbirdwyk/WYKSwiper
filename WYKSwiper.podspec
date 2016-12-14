Pod::Spec.new do |s|
    s.name         = 'WYKSwiper'
    s.version      = '1.0.0'
    s.summary      = 'A Swiper written in swift 3.0'
    s.homepage     = 'https://github.com/sunbirdwyk/WYKSwiper'
    s.license      = 'MIT'
    s.authors      = {'Sunbird' => 'sunbirdwyk@163.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/sunbirdwyk/WYKSwiper.git', :tag => s.version}
    s.source_files = 'WYKSwiper/WYKSwiper/*.swift'
    s.requires_arc = true
end