To whom this may concern,

attached in the Parking Permit Machine (PPM) folder you will find a project of mine
from when I was studying at UC Irvine. This project was to create a Finite State Machine
representing a PPM with restricted inputs and limited outputs to focus on the 
fundamentals of working with VHDL within the Xilinx software.

I revised the Structural file I included within this folder, as I remembered that the
Boolean Equations could have been reduced but I didn't bother to when originally
creating this project. Dissatisfied upon re-opening the Structural file and seeing the
Boolean Equations in how large/messy they appeared, I updated their respective portions.

The restricted inputs are as follows:
    000: no inputs recorded by the user
    001: user inputted $5
    010: user inputted $10
    100: user inputted $15
    111: user has requested cancellation of the transaction

The files included are described below:
    FSM Drawing:            diagram of Finite State Machine to describe functionality of PPM
    lab2b:                  behavior representation of PPM Finite State Machine
    lab2s:                  digital circuit representation of PPM using AND and OR logic gates
    lab2s_revised:          updated version of the Structural file using reduced Boolean Equations
    lab2s_report - revised: includes Truth Table of Finite State Machine, Boolean Equations to 
                            NextState logic, and extra info with regards to the project
    lab2s Graphs:           included the original graph photos from testing in case of interest
                            in seeing the results