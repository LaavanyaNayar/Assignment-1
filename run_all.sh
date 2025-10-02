#!/bin/bash
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m"

#Ensure output exists and is empty
if [ ! -d output_files ];then
	mkdir -p output_files
else
	rm output_files/*
fi

for trace_file in input_files/trace_testcase_*.txt; do

	#get the test case name from the trace input	
	base_name=$(basename "$trace_file" .txt | sed 's/trace_//')
	
	# make output file name according to test case name
	output_file="output_files/execution_${base_name}.txt"
	
	# print which test case we are on
	echo -e "${YELLOW}---> Running test case: ${NC} $trace_file ${CYAN}->${NC} $output_file"
	
	
	# try to run the interrupts simulation and catch exit stauts
	if ./bin/interrupts "$trace_file" vector_table.txt device_table.txt; then
		if [ -f execution.txt ];then
			# move the output ot the output folder
			mv execution.txt "$output_file"
			echo -e "${GREEN}===>Succes:${NC} Results in $output_file"
		else
			echo -e "${RED}==> === ERROR:${NC} execution.txt not found for $trace_file"
		fi
	else
		echo -e "${RED}==> === ERROR:${NC} SImultaor failed to run $trace_file"
	fi
	echo
done
echo -e "${GREEN}==>> All test cases processed results in output_files"
