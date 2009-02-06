# coding: utf-8
# 2009-02-02.

$LOAD_PATH.delete(".")
$LOAD_PATH.unshift File.dirname(File.dirname(File.expand_path($PROGRAM_NAME)))
load 'bin/config', wrap=true

raise "sorry, i use ruby 1.9.1" if RUBY_VERSION < "1.9.1"
ext = Encoding.default_external.name
raise "Error, LANG must be UTF-8" unless ext == 'UTF-8'
# start
require 'readbook'
ReadBook::Starter.start

#===================================================
# if move this file to the other directory
#===================================================

=begin
#!/usr/local/bin/ruby19 -w
# coding: utf-8

$LOAD_PATH.delete(".")
# $LOAD_PATH.unshift File.dirname(File.dirname(File.expand_path($PROGRAM_NAME)))
$LOAD_PATH.push('/path/to/ReadBook-0.3/')
load 'bin/config', wrap=true

raise "sorry, i use ruby 1.9.1" if RUBY_VERSION < "1.9.1"
ext = Encoding.default_external.name
raise "Error, LANG must be UTF-8" unless ext == 'UTF-8'
# start
require 'readbook'
ReadBook::Starter.start

=end