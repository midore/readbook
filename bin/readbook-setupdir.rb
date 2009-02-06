# coding: utf-8
# 2009-02-03

#===================================================
# ReadBook/mydata/text => for text file.
# ReadBook/mydata/data => for marshal.
#===================================================

$LOAD_PATH.delete(".")
$LOAD_PATH.unshift File.dirname(File.dirname(File.expand_path($PROGRAM_NAME)))
load 'bin/config', wrap=true
require 'lib/mod_conf'
require 'lib/mod_setupdir'
require 'fileutils'

begin
  raise "sorry, i use ruby 1.9.1" if RUBY_VERSION < "1.9.1"
  e = ReadBook::MineSetup::CheckVAndPath.yourenv
  ext = Encoding.default_external.name
  raise "Error, LANG must be UTF-8" unless ext == 'UTF-8'
  # clear
  print "Your environment\n #{e} \nYour default_external\n#{ext}\n\n"
  print "Check DataDirectory\n"
  ReadBook::MineSetup::CheckVAndPath.data_dir_check

rescue RuntimeError => err
  print err.message, "\n"
rescue Exception => err
  print err.message, "\n"
  abort "abort. bye.\n"
ensure
  exit(1)
end
