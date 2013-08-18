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

def get_lan_ip()
    require 'socket'
    ip = IPSocket.getaddress(Socket.gethostname)
    return ip
end

$header=%Q{#!ruby
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
print "Hello:"
world=gets.chomp
World='ruby is case sensitive'
puts "Hello "+world.capitalize + "!"
@],

    '1' => 
        ['If...else, case, unless',
%Q@
case Time.now.to_i % 10
when 0 .. 5
    if Time.now.to_i % 2 >0
        puts "odd"
    elsif true
        puts "even"
    else
    end
when 6,7
    puts 6 unless false
else
    puts 89
end
@],
    
    '2' => 
['Loops: while, for, until, break, redo and retry',
'
while not nil
    (0..2).each do |i|
        puts "i=#{i}"
        for j in 0..2
            next if j <2
            puts "j="+j.to_s
        end
        break unless i <2
    end
    break
end
'],

    '3' => 
['Array and Hash',
%Q@
list=[1,3,2]; puts list
list_of_list=[1,2,[3,4]]; print list_of_list; puts
list_of_dict=[{"name"=>"jack", "sex"=>"M"},{"name"=>"king","sex"=>"M"}]; puts list_of_dict
dict={'yi'=>'one','san'=>'three','er'=>'two','array'=>['four','five']}; puts dict
for i in dict.keys()
    print dict[i]; puts
end
for i in dict.keys.sort 
    print dict[i]; puts
end
puts dict.keys.size
@],

    '4' => 
['''File Read and Write''',
%Q@
file=File.open("test.txt","w")
file.write("line without newline")
file.puts("line with newline")
file.close
file=File.open("test.txt","r")
file.read.each_line do |line|
    puts line
end
file.close
@],
}

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
    uri = URI("http://"+$_newrb_server_+"/newrb")
    params = {'which'=> $__version__, 'where'=> get_lan_ip(), 'who'=> $_author_, 'what'=> what}
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(params)
    begin

        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
            http.read_timeout = 1
            http.set_debug_output($stdout) if $options[:debug]
            http.request(req)
        end

        case res
        when Net::HTTPSuccess, Net::HTTPRedirection
            # OK
            newrbid=res.body.to_i if res.is_a?(Net::HTTPSuccess)
        else
            res.value
        end
    rescue Exception => e
        puts e.message
    end

    if verbose 
        if newrbid >0 
            puts "ok, got "+newrbid.to_s
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
    uri = URI("http://"+$_newrb_server_+"/newrb/upload")
    params={'filename'=> filename, 'content'=> File.open(filename,'rb').read}
    begin

        res = Net::HTTP.post_form(uri,params)

        case res
        when Net::HTTPSuccess, Net::HTTPRedirection
            puts res.body
            puts "weblink: http://"+$_newrb_server_+"/newrb/"+newrbid.to_s
        else
            puts "ko "+res.value
        end
    
    rescue Exception => e
        puts "Exception: "+e.message
    end
    exit
end

$options={}
def main()
    optparser = OptionParser.new do|opts|
        opts.banner = "usage: #{__FILE__} [options] filename"

        opts.on("-h", "--help", "show this help message and exit") do 
            puts opts
            exit
        end

        $options[:sample_list]=''
        opts.on("-s", "--samples sample-id-list", 'select samples to include in the new file',
                      'e.g. -s 123, check -l for all ids.') do |sample_list|
            $options[:sample_list]=sample_list
        end

        opts.on("-l", "--list_sample_id", "list all the available samples.") do
            list_sample
        end

        opts.on("-u", "--upload FILENAME", 'upload file to newrb server as sample to others. the file must have a valid newrb ID.') do|filename|
            upload_file(filename)
            exit
        end

        $options[:comment]=false
        opts.on("-c", "--comment", "add samples with prefix '#'" ) do
            $options[:comment]=true
        end

        $options[:verbose]=true
        opts.on("-q", "--quiet", "run in silent mode") do
            $options[:verbose]=false
        end

        $options[:overwrite]=false
        opts.on("-o", "--overwrite", "overwrite existing file") do
            $options[:overwrite]=true
        end

        $options[:test]=false
        opts.on("-t", "--test", "run in test mode, no file generation, only print result to screen.") do
            $options[:test]=true
        end

        $options[:debug]=false
        opts.on("-d", "--debug", "run in debug mode, more debug info.",
               "note: put -d before any other options to take best effect.") do
            $options[:debug]=true
        end

        $options[:record]=true
        opts.on("-n", "--norecord", "don't submit record to improve newrb") do
            $options[:record]=false
        end
    end
    optparser.parse!

    if ARGV.length != 1
        puts "incorrect number of arguments, try -h"
        exit
    end

    filename=ARGV[0]+'.rb'
    if !$options[:overwrite] and File.exist?(filename)
        puts("error: "+filename+" already exist!")
        exit
    end

    verbose=$options[:verbose]
    sample_list=$options[:sample_list]

    if !$options[:test] and $options[:record]
        newrb_id=submit_record(sample_list,verbose)
    else 
        newrb_id=0
    end

    write_sample_to_file(newrb_id,
                         sample_list,
                         $options[:test] ? nil : filename,
                         $options[:comment])
    puts "generate #{filename} successfully." if verbose 
end

main()


