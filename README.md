# devicelogin
# lnxbsd-login.exp - This expect script helps to login to router and vm hosts
#  shell-login.exp  - This expect script helps to login to router and vm hosts

To run the lnxbsd-login.exp, use "expect lnxbsd-login.exp". It ask for the device name, user name and password. Refer the on screen instruction to proceed, you should be able to login to the device.
After logout from the device, the device information like device name, username and password gets stored in a text file named "outputfile.txt". If you try to login to the same device again, this time login should be faster than first time.


