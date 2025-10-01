/**
 *
 * @file interrupts.cpp
 * @author Laavanya Nayar
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
		execution += std::to_string(current_time) +","+std::to_string(duration_intr)+ ", CPU burst\n";
		// update time
		current_time += duration_intr;
	}
	
	
        /************************************************************************/

    }

    input_file.close();

    write_output(execution);

    return 0;
}
