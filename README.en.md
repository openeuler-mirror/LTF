# Linux-Test-Framework

Linux automated testing framework
https://gitee.com/openeuler/LTF
	
一. Running tests

1. To run these tests on your local machine :

1.1 Execute "./Run.sh -f XML file" in the terminal, Multiple serial numbers should be separated by colons.

1.2 Execute "./ltfMenu.sh" in the terminal, flexibly combine and select the serial numbers before the test modules according to the need, multiple numbers can be separated by spaces, and then enter the character "r" to run.

1.2.1 Performance Testing Method

When executing ./ltfMenu.sh, you can enter "s" in the menu option interface to customize the performance testing tools. Select the serial numbers before the tools, multiple numbers can be separated by spaces. Customize the xml name for this test according to the prompt, and then press Enter to return to the menu option interface to select the serial number corresponding to the xml name. "y" indicates to check the execution environment of the performance test item, such as whether the dependent packages are installed. "n" indicates not to check the execution environment of the performance test item. Press Enter and execute "r" to start running the test item.

二. Writing tests

  Feel free to add the test modules you want to make. For example, the "Linux Command" test. You can create the "commands" folder in the testcases directory. And add the corresponding xml file in the config directory.
    
  There is an xml parsing script in the lib folder. Use "source xmlParse.sh" if necessary
