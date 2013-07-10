Pod::Spec.new do |s|
  s.name         = 'P34CustomJsonSerialization'
  s.version      = '0.0.1'
  s.summary      = 'Convert custom classes to json with NSCoding'
  s.homepage     = 'https://github.com/pilot34/P34CustomJsonSerialization'
  s.license      = 'MIT'
  s.author       = { 'pilot34' => 'gleb34@gmail.com' }
  s.source       = { :git => 'https://github.com/pilot34/P34CustomJsonSerialization.git' }
  s.platform     = :ios, '5.0'
  s.source_files = 'CustomJsonSerialization/P34JsonCoder.{h,m}'
  s.requires_arc = true
end