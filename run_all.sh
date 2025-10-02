#!/bin/bash

LOGFILE="run_log.txt"
exec > >(tee >(sed 's/\x1b\[[0-9;]*m//g' > "$LOGFILE")) 2>&1

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

total_scores=0
total_cases=0


for trace_file in input_files/trace_testcase_*.txt; do

	#get the test case name from the trace input	
	base_name=$(basename "$trace_file" .txt | sed 's/trace_//')
	
	# make output file name according to test case name
	output_file="output_files/execution_${base_name}.txt"
	
	# get expected files name based on trace
	expected_file="expected_output_files/expected_${base_name}.txt"
	
	
	# print which test case we are on
	echo -e "${YELLOW}---> Running test case: ${NC} $trace_file ${CYAN}->${NC} $output_file"
	
	
	# try to run the interrupts simulation and catch exit stauts
	if ./bin/interrupts "$trace_file" vector_table.txt device_table.txt; then
		if [ -f execution.txt ];then
		
			# move the output ot the output folder
			mv execution.txt "$output_file"
			
			correct_lines=$(diff -y --suppress-common-lines "$output_file" "$expected_file" | wc -l)
			total_lines=$(wc -l < "$expected_file") 
			matched=$(( total_lines - correct_lines))
			
			if [ "$total_lines" -gt 0 ];then
				percent=$((matched * 100 /total_lines))
			else
				percent=100
			fi
			
			echo -e "	${CYAN} Expected:${NC} $expected_file"
			echo -e "	${GREEN} Correct:${NC} $percent%"
			
			total_scores=$((total_scores + percent))
			total_cases=$((total_cases+1))
				
		else
			echo -e "${RED}==> === ERROR:${NC} execution.txt not found for $trace_file"
		fi
	else
		echo -e "${RED}==> === ERROR:${NC} Simultaor failed to run $trace_file"
	fi
	echo "----------------------------------------------------------------------------"
done

if [ "$total_cases" -gt 0 ];then
	overall=$(( total_scores / total_cases))
	if [ "$overall" -lt 100 ];then
		echo -e "${RED}==> !!WARNING: ${NC} ${NC} Overall correctness: ${CYAN} $overall% ${NC} across ${CYAN} $total_cases ${NC} cases. All test cases processed results in output_files"
		
	else 
		echo -e "${GREEN}==>> SUCCESS: ${NC} Overall correctness: ${CYAN} $overall% ${NC} across ${CYAN} $total_cases ${NC}cases. All test cases processed results in output_files"
		
	fi
else
	echo -e "${RED}==> === ERROR: ${NC} No test cases were fully processed :("
fi
	
	
	
	
