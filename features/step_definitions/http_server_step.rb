# encoding: UTF-8

require 'open-uri'
require 'rspec/expectations'


前提 /^: HTTPで ([\w\.]+) にリクエストする$/ do |host|
  @resource = open("http://#{host}")
end

ならば /^: レスポンスのステータスが (\d+) だ$/ do |status|
  @resource.status[0].should == "200"
end

前提 /^: Hostヘッダ に "([\w\.]+)" をつけてHTTPで ([\w\.]+) にリクエストする$/ do |host_header, host|
  @resource = open("http://#{host}","Host" => host_header)
end

ならば /^: コンテンツに ([\w\.]+) が含まれている$/ do |expect_string|
  @resource.read.should match(expect_string)
end

