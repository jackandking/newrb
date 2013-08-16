#!ruby
# Author: jackandking@gmail.com
# DateTime: 2013-08-15 16:03:14
# HomePage: https://github.com/jackandking/newrb

$__version__='0.1'

'Contributors:
    Yingjie.Liu@thomsonreuters.com
'

# Configuration Area Start for users of newrb
$_author_ = 'Yingjie.Liu@thomsonreuters.com'
# Configuration Area End

#$_newrb_server_='newxx.sinaapp.com'
$_newrb_server_='localhost:8080'

require 'optparse'
require 'uri'
require 'net/http'
=begin
import sys,os
import socket

if os.name != "nt":
    import fcntl
    import struct

    def get_interface_ip(ifname):
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, struct.pack('256s',
                                ifname[:15]))[20:24])

=end

def get_lan_ip()
    ip='non'
    return ip
end

$header=%Q{# -*- coding: utf-8 -*-
# Author: %s
# DateTime: %s
# Generator: https://github.com/jackandking/newrb
# Newrb Version: %s
# Newrb ID: %s
}

$sample_blocks = {

    '0' => 
        ['Hello World',
%Q@
world=raw_input("Hello:")
World='ruby is case sensitive'
print "Hello",world + "!"
@],

    '1' => 
['''If-Else inside While''',
'
from time import time
while not nil:
    if int(time()) % 2:
            print "True"
            continue
    else:
            break
'],

    '2' => 
['''List and Dict''',
%Q@
list=[1,3,2]; print list
list_of_list=[1,2,[3,4]]; print list_of_list
list_of_dict=[{"name":"jack", "sex":"M"},{"name":"king","sex":"M"}]; print list_of_dict
dict={'yi':'one','san':'three','er':'two','array':['four','five']}; print dict
for i in dict.keys(): print dict[i]
for i in sorted(dict.keys()): print dict[i]
print len(dict.keys())
@],

    '3' => 
['''File Read and Write''',
%Q@
file=open("test.txt","w")
file.write("line1")
file.close
file=open("test.txt","r")
line=file.readline()
while line:
    print line
    line=file.readline()
file.close
@],
}
=begin
    ('4' , 
['''Regular Expression''',
'''
import re
line='abc123abc'
m=re.search('(\d+)',line)
if m: print m.group(1)
''']),

    ('5' , 
['''URLFetch and Exception Handling''',
'''
import urllib2,sys
from urllib2 import URLError, HTTPError
try:
    response=urllib2.urlopen("www.baidu.com")
    response=urllib2.urlopen("http://www.baidu.com")
    print response.read(); 
except HTTPError, e:
    print 'The server couldn\'t fulfill the request.'
    print 'Error code: ', e.code
except URLError, e:
    print 'We failed to reach a server.'
    print 'Reason: ', e.reason
except:
    print "Unexpected error:", sys.exc_info()[0]
''']),

    ('6' , 
['System Call',
'''
import subprocess
#only care about return value
print subprocess.call("dir abc.txt", shell=True)
#Care about output
print subprocess.check_output("hostname", shell=True)
''']),

    ('7' , 
['String Operation',
'''
s='abc'+'de'
print len(s)
print s[0],s[-1]
''']),

    ('8' , 
['eval and exec',
'''
a=eval('1+1')
exec('b=1+1')
print a,b
''']),

    ('9' , 
['Unit Test',
'''
if __name__ == '__main__':
    print "hello world!"
''']),

    ('c' , 
['Class and SubClass',
'''
class Parent:        # define parent class
   data = 100
   def __init__(self): print "Calling parent constructor"
   def __del__(self): print "Parent D'tor: ",self.data,Parent.data

class Child(Parent): # define child class
   def __init__(self): self.data=2; print "Calling child constructor"

print Child()
''']),

    ('d' , 
['Dict Deep Copy',
'''
import copy
my_dict = {'a': [1, 2, 3], 'b': [4, 5, 6]}
my_copy = copy.deepcopy(my_dict)
my_dict['a'][2] = 7
print my_copy['a'][2]
''']),

    ('f' , 
['Function and DataTime',
'''
from datetime import date
def isleap(year):
    """Return True for leap years, False for non-leap years."""
    return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)
thisyear=date.today().year
print isleap.__doc__
print "this year is leap year:",isleap(thisyear)
''']),

    ('i' , 
['Runtime Import',
'''
libname='time'
globals()[libname] = __import__(libname)
mod=globals()[libname]
if hasattr(mod,'sleep'):
    mod.sleep(1)
''']),

    ('m' , 
['MongoDB - NoSQL',
'''
from pymongo import MongoClient
client = MongoClient('localhost', 27017)
db = client.test_database
collection = db.test_collection
post = {"author": "Mike","text": "My first blog post!"}
posts = db.posts
post_id = posts.insert(post)
posts.find_one({"author": "Mike"})
for post in posts.find():
    post
''']),

])
=end

def write_sample_to_file(newrb_id=0,
                         id_list=nil,
                         filename=nil,
                         comment=nil)
    if id_list  
        id_list= id_list.split(//)
    else
        id_list=$sample_blocks.keys() 
    end
    if !filename
        file=$stdout
    else
        file=File.open(filename,'w')
    end
    file.write( $header % [$_author_, Time.now(), $__version__, newrb_id] )
    for i in id_list
        if !$sample_blocks.keys().include?(i)
            puts "invalid sample ID, ignore",i
            next
        end
        file.puts("")
        file.puts("=begin") if comment
        file.puts('#'+$sample_blocks[i][0])
        file.puts($sample_blocks[i][1])
        file.puts("=end") if comment 
        file.puts("")
    end
    file.close() if file != $stdout 
end

def list_sample()
    puts "Here are the available samples:"
    for i in $sample_blocks.keys().sort()
        puts "#{i} => #{$sample_blocks[i][0]}"
    end
    exit
end


def submit_record(what,verbose)
    newrbid=0
    print("apply for newrb ID...") if verbose
    #conn = Net::HTTP.new("http://"+$_newrb_server_)
    #conn.read_timeout = 1
    #conn.set_debug_output($stdout)
    #request = Net::HTTP::Post.new "/newpy"
    params = {'which'=> $__version__, 'where'=> get_lan_ip(), 'who'=> $_author_, 'what'=> what}
    #request.set_form_data({'which'=> $__version__, 'where'=> get_lan_ip(), 'who'=> $_author_, 'what'=> what})

    begin
        response = Net::HTTP.post_form(URI.parse("http://"+$_newrb_server_+"/newpy"), params)
        #response = conn.request(request)
        #puts response.body
        newrbid=response.body.to_i if response.is_a?(Net::HTTPSuccess)
    rescue Exception => e
        puts e.message
    end

    if verbose 
        if newrbid >0 
            puts "ok, got",newrbid
        else  
            puts "ko, use 0"
        end
    end

    return newrbid
    end
 
def upload_file(filename)
    abort("error: "+filename+" does not exist!") unless File.exist?(filename) 
    file=File.open(filename,"r")
    newrbid=0
    file.read.each_line do |line|
        m=/# Newrb ID: (\d+)/.match(line)
        if m 
            newrbid=m[1].to_i
            break
        end
    end
    file.close
    if newrbid == 0
        abort("error: no valid newrb ID found for "+filename)
    end
    print("uploading "+filename+"(newrbid="+newrbid.to_s+")...")
    #conn = Net::HTTP.new("http://"+$_newrb_server_)
    #conn.read_timeout = 5 
    #conn.set_debug_output($stdout)
    #request = Net::HTTP::Post.new "/newpy/upload"
    #request.set_form_data({'filename'=> filename, 'content'=> File.open(filename,'rb').read})
    params={'filename'=> filename, 'content'=> File.open(filename,'rb').read}
    begin
        #response = conn.request(request)
        response = Net::HTTP.post_form(URI.parse("http://"+$_newrb_server_+"/newpy/upload"), params)
        if response.is_a?(Net::HTTPSuccess)
            puts response.body
            puts "weblink: http://"+$_newrb_server_+"/newrb/"+newrbid.to_s
        else
            puts "ko"
        end
    rescue Exception => e
        puts e.message
    end
    exit
end

def main()
    options={}
    optparser = OptionParser.new do|opts|
        opts.banner = "usage: #{__FILE__} [options] filename"

        opts.on("-h", "--help", "show this help message and exit") do 
            puts opts
            exit
        end

        options[:sample_list]=''
        opts.on("-s", "--samples sample-id-list", 'select samples to include in the new file',
                      'e.g. -s 123, check -l for all ids.') do |sample_list|
            options[:sample_list]=sample_list
        end

        opts.on("-l", "--list_sample_id", "list all the available samples.") do
            list_sample
        end

        opts.on("-u", "--upload FILENAME", 'upload file to newrb server as sample to others. the file must have a valid newrb ID.') do|filename|
            upload_file(filename)
            exit
        end

        options[:comment]=false
        opts.on("-c", "--comment", "add samples with prefix '#'" ) do
            options[:comment]=true
        end

        options[:verbose]=true
        opts.on("-q", "--quiet", "run in silent mode") do
            options[:verbose]=false
        end

        options[:overwrite]=false
        opts.on("-o", "--overwrite", "overwrite existing file") do
            options[:overwrite]=true
        end

        options[:test]=false
        opts.on("-t", "--test", "run in test mode, no file generation, only print result to screen.") do
            options[:test]=true
        end

        options[:record]=true
        opts.on("-n", "--norecord", "don't submit record to improve newrb") do
            options[:record]=false
        end
    end
    optparser.parse!

    if ARGV.length != 1
        puts "incorrect number of arguments, try -h"
        exit
    end

    filename=ARGV[0]+'.rb'
    if !options[:overwrite] and File.exist?(filename)
        puts("error: "+filename+" already exist!")
        exit
    end

    verbose=options[:verbose]
    sample_list=options[:sample_list]

    if options[:record]
        newrb_id=submit_record(sample_list,verbose)
    else 
        newrb_id=0
    end

    write_sample_to_file(newrb_id,
                         sample_list,
                         options[:test] ? nil : filename,
                         options[:comment])
    puts "generate #{filename} successfully." if verbose 
end

main()


