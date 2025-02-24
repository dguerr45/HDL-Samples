----------------------------------------------------------------------
-- EECurrent_State(3) and 1L Assignment 2
-- FSM Structural Model
----------------------------------------------------------------------
-- Student First Name : Daniel
-- Student Last Name : Guerra-Rojas
-- Student ID : Your 14372295
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Lab2s_FSM IS
     Port (Input : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
           Clk : in  STD_LOGIC;
           Permit : out  STD_LOGIC;
           ReturnChange : out  STD_LOGIC);
END Lab2s_FSM;

ARCHITECTURE Structural OF Lab2s_FSM IS

-- DO NOT modify any signals, ports, or entities above this line
-- Required - there are multiple ways to complete this FSM; however, you will be restricted to the following as a best practice:
-- Create 2 processes (one for updating state status and the other for describing transitions and outputs)
-- For the combinatorial process, use Boolean equations consisting of AND, OR, and NOT gates while expressing the delay in terms of the NAND gates. 
-- Remember to use your calculated delay from the lab handout.
-- For the state register process, use IF statements. Remember to use the calculated delay from the lab handout.
-- Figure out the appropriate sensitivity list of both the processes.
-- add your code here

subtype StateType IS STD_LOGIC_VECTOR (3 downto 0);
signal Current_State, Next_State: StateType := "0000";

begin
CombLogic: Process (Current_State, Input)
	begin

		Permit <= ( ( (not Current_State(3)) and Current_State(2) and Current_State(1) and Current_State(0) ) or 
			
			( Current_State(3) and (not Current_State(2)) and (not Current_State(1)) and (not Current_State(0)) )
			);

		ReturnChange <= ( Current_State(3) and (not Current_State(2)) and (not Current_State(1))
			);

		Next_State(3) <= ( ( ( (not Current_State(3)) and (not Current_State(0)) and ( ( Current_State(2) xor 
			Current_State(1) ) or ( Current_State(2) and Current_State(1) ) ) ) and 
			( Input(2) and Input(1) and Input(0) ) ) or 
			
			( (not Current_State(3)) and Current_State(2) and Current_State(1) and (not Current_State(0)) and
			( (not Input(2)) and Input(1) and (not Input(0)) ) ) or 
			
			( (not Current_State(3)) and Current_State(1) and (not Current_State(0)) and 
			( Input(2) and (not Input(1)) and (not Input(0)) ) )
			) after 5.6ns;

		Next_State(2) <= ( ( (not Current_State(3)) and (not Current_State(2)) and (not Current_State(1)) and 
			(not Current_State(0)) and 
			( Input(2) and (not Input(1)) and (not Input(0)) ) ) or

			( ( (not Current_State(3)) and (not Current_State(0)) and ( Current_State(2) xor Current_State(1) ) ) and 
			( (not Input(2)) and Input(1) and (not Input(0)) ) ) or

			( (not Current_State(3)) and Current_State(2) and (not Current_State(0)) and
			( (not Input(2)) and (not Input(1)) ) ) or

			( (not Current_State(3)) and Current_State(0) and ( Current_State(2) xor Current_State(1) ) )
			) after 5.6ns;

		Next_state(1) <= ( ( (not Current_State(3)) and (not Current_State(1)) and (not Current_State(0)) and
			( (not Input(2)) and Input(1) and (not Input(0)) ) ) or

			( (not Current_State(3)) and (not Current_State(2)) and (not Current_State(1)) and (not Current_State(0)) and
			( Input(2) and (not Input(1)) and (not Input(0)) ) ) or

			( (not Current_State(3)) and Current_State(1) and (not Current_State(0)) and
			( (not Input(2)) and (not Input(1)) ) ) or

			( (not Current_State(3)) and (not Current_State(2)) and Current_State(0) )
			) after 5.6ns;

		Next_State(0) <= ( ( (not Current_State(3)) and (not Current_State(0)) and
			( (not Input(2)) and (not Input(1)) and Input(0)) ) or

			( ( (not Current_State(3)) and (not Current_State(0)) and ( (not Current_State(2)) and (not Current_State(1))
			or ( Current_State(2) xor Current_State(1) ) ) ) and 
			( (not Input(2)) and Input(1) and (not Input(0)) ) ) or

			( (not Current_State(3)) and (not Current_State(2)) and (not Current_State(1)) (not Current_State(0)) and
			( Input(2) and (not Input(1)) and (not Input(0)) ) ) or

			( ( (not Current_State(3)) and (not Current_State(0)) ( Current_State(2) or Current_State(1) ) ) and
			( Input(2) and Input(1) and Input(0) ) )
			) after 5.6ns;

	end Process CombLogic;

StateRegister: Process (Clk)
	begin
	if(Clk = '1' and Clk'EVENT) then
		Current_State <= Next_State after 5ns;
		end if;
	end Process StateRegister;

END Structural;