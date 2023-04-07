#!/usr/bin/expect -f
set timeout 20

send_user "Enter server name: "
expect_user -re "(.*)\n"
set server_name $expect_out(1,string)

spawn ping -c 5 $server_name.englab.juniper.net
expect {
	"packet loss" {
		puts "This device is in englab domain"
        set eng 1
	}
	"Unknown host" {
		puts "This device is not in englab domain"
        set eng 0
	}
}

puts "Ping output:"
puts "==============================================================="
puts $expect_out(buffer)
puts "==============================================================="

spawn ping -c 5 $server_name.spglab.juniper.net
expect {
        "packet loss" {
            puts "This device is in spglab domain"
			set spg 1
        }
	"Unknown host" {
            puts "This device is not in englab domain"
			set spg 0
	}
}

puts "Ping output:"
puts "==============================================================="
puts $expect_out(buffer)
puts "==============================================================="


if {$eng == 1} {
	send "ssh-keygen -R $server_name.englab.juniper.net"
	sleep 5
	set var $expect_out(buffer)
	puts $var
    send "ssh-keyscan -H $server_name.englab.juniper.net >> ~/.ssh/known_hosts"
    sleep 5
	set var $expect_out(buffer)
	puts $var
    spawn ssh -o StrictHostKeyChecking=accept-new root@$server_name.englab.juniper.net 
} elseif {$spg == 1} {
	send "ssh-keygen -R $server_name.spglab.juniper.net"
	sleep 5
    send "ssh-keyscan -H $server_name.spglab.juniper.net >> ~/.ssh/known_hosts"
    sleep 5
	set var $expect_out(buffer)
	puts $var
    spawn ssh -o StrictHostKeyChecking=accept-new root@$server_name.spglab.juniper.net
} else {
    puts "These devices are neither in spg nor eng domain OR not alive"
}

catch {
	expect {
	    "password:" {
			send "Embe1mpls\r\r\r"
            expect *
            send "pwd\r"
            expect *
            interact
		} 
		"(yes/no)?" {
			send "yes\r"
			expect "password:"
			send "Embe1mpls\r\r\r"
            expect *
            send "pwd\r"
			expect *
			interact
		}
	    "Password:" {
			send "Embe1mpls\r\r\r"
            expect *
            send "pwd\r"
            expect *
            interact
		}    
		"(yes/no/\[fingerprint\])?" {
			send "yes"
			expect "Password:"
			send "Embe1mpls\r\r\r"
            expect *
            send "pwd\r"
			expect *
			interact
		}
	    "or not known" {
			puts "This is not in englab domain"
		}
	} 
} error_msg

if {$error_msg ne ""} {
    puts "Error: $error_msg"
    exit 1
}


