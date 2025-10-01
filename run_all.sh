#!/bin/bash
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
	echo "Running test case: $trace_file -> $output_file"
	
	# run the interrupts simulation
	./bin/interrupts "$trace_file" vector_table.txt device_table.txt
	
	# move the output ot the output folder
	mv execution.txt "$output_file"
done
echo "All test cases processe. Results in  output_files"
