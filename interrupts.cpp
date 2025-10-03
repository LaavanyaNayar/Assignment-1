/**
 *
 * @file interrupts.cpp
 * @author Laavanya Nayar, Kartik Dewan
 *
 */

#include <interrupts.hpp>

int main(int argc, char** argv) {

    //vectors is a C++ std::vector of strings that contain the address of the ISR
    //delays  is a C++ std::vector of ints that contain the delays of each device
    //the index of these elemens is the device number, starting from 0
    auto [vectors, delays] = parse_args(argc, argv);
    std::ifstream input_file(argv[1]);

    std::string trace;      //!< string to store single line of trace file
    std::string execution;  //!< string to accumulate the execution output

    /******************ADD YOUR VARIABLES HERE*************************/
    int current_time = 0; // to keep track of current time
    int context_save_time = 10; // context save time value
    int isr_activity_time= 40; // ISR exuction time


    /******************************************************************/

    //parse each line of the input trace file
    while(std::getline(input_file, trace)) {
        auto [activity, duration_intr] = parse_trace(trace);

        /******************ADD YOUR SIMULATION CODE HERE*************************/
	
	// CPU Burst Handler 
	if (activity == "CPU"){
		// store execution event
		execution += std::to_string(current_time) +", "+std::to_string(duration_intr)+ ", CPU burst\n";
		// update time
		current_time += duration_intr;
	}
	// SYSCALL Hamdler
	else if (activity == "SYSCALL") {
	
		auto [exec_boiler, updated_time] = intr_boilerplate(current_time,duration_intr,context_save_time,vectors);
		execution += exec_boiler;
		current_time = updated_time;
		
		execution += std::to_string(current_time) + ", 1, Obtain ISR address\n";
		current_time++;
		// times for each step.
		int isr_time = delays.at(duration_intr);
		int step_1_time = isr_time*0.1;
		int step_2_time = isr_time*0.6;
		int step_3_time = isr_time*0.2;
		int step_4_time = isr_time-(step_1_time+step_2_time+step_3_time);
		
		//new isr body steps... still needs improvement
		//todo: reserach timeing for ISRs
		
		execution += std::to_string(current_time) + ", "+ std::to_string(step_1_time) + ", call device driver\n";
		current_time += step_1_time;
		
		execution += std::to_string(current_time) + ", "+ std::to_string(step_2_time) + ", device I/O \n";
		current_time += step_2_time;
		
		execution += std::to_string(current_time) + ", "+ std::to_string(step_3_time) + ", update OS tables and status \n";
		current_time += step_3_time;
		
		execution += std::to_string(current_time) + ", "+ std::to_string(step_4_time) + ", schedule process \n";
		current_time += step_4_time;
		
		
		execution += std:: to_string(current_time)+ ", 1, IRET\n";
		current_time++;

	}

        /************************************************************************/

    }

    input_file.close();

    write_output(execution);

    return 0;
}
