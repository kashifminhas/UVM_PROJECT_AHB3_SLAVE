cd /home/runner
export PATH=/usr/bin:/bin:/tool/pandora64/bin:/apps/vcsmx/vcs/Q-2020.03-SP1-1//bin
export VCS_VERSION=Q-2020.03-SP1-1
export VCS_PATH=/apps/vcsmx/vcs/Q-2020.03-SP1-1//bin
export LM_LICENSE_FILE=5280@10.128.113.200
export VCS_HOME=/apps/vcsmx/vcs/Q-2020.03-SP1-1/
export HOME=/home/runner
export UVM_HOME=/apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2
vcs -licqueue '-timescale=1ns/1ns' '+vcs+flush+all' '+warn=all' '-sverilog' +incdir+$UVM_HOME/src $UVM_HOME/src/uvm.sv $UVM_HOME/src/dpi/uvm_dpi.cc -CFLAGS -DVCS design.sv testbench.sv  && ./simv +vcs+lic+wait  ; echo 'Creating result.zip...' && zip -r /tmp/tmp_zip_file_123play.zip . && mv /tmp/tmp_zip_file_123play.zip result.zip