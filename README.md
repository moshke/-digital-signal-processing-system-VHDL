# -digital-signal-processing-system-VHDL

VHDL implementation of a digital signal processing system, with components for a finite state machine (FSM), a row buffer, a filter, a ROM, and a RAM.
The top-level entity has four ports, including clk (clock), rst (reset), start, and done. These ports are used to communicate with the FSM component, which controls the system's operation.
The row buffer component stores and shifts rows of data, which are passed to the filter component.
The filter applies a specific digital signal processing filter to the input data, and the resulting processed row is then written to the RAM.
The ROM and RAM components are used for storing and retrieving data, and are controlled by the FSM.
The code also includes several constant and signal declarations, as well as generic declarations for the ROM and RAM components.
The code designed to implement a specific digital signal processing algorithm, a smoothe filter:
The filter takes in three rows of data, prev_row, curr_row, and next_row, and applies a smoothing filter to each pixel in the rows. The filtered row is output as proc_row.
The filter operates by taking a 3x3 pixel window centered on each pixel in the input rows, and computing the average of the nine pixels in the window. The resulting value is then assigned to the corresponding pixel in the output row.
The code uses a process block with a clock and reset signal as its sensitivity list. Inside the process block, the code first initializes a temporary variable called tmp to all zeros. Then, for each pixel in the input rows, the code extracts the 3x3 pixel window centered on the pixel, concatenates the pixels into a 45-bit vector called data_9_pixels, and passes this vector to the "smooth" function. The resulting smoothed value is assigned to the corresponding pixel in the tmp variable.
After all pixels have been processed, the contents of tmp are assigned to the output signal proc_row.
