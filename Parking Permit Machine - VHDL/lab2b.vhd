----------------------------------------------------------------------
-- EECS31L Assignment 2
-- FSM Behavioral Model
----------------------------------------------------------------------
-- Student First Name : Daniel
-- Student Last Name : Guerra-Rojas
-- Student ID : 14372295
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Lab2b_FSM is
    Port ( Input : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
           Clk : in  STD_LOGIC;
           Permit : out  STD_LOGIC;
           ReturnChange : out  STD_LOGIC);
end Lab2b_FSM;

architecture Behavioral of Lab2b_FSM is

-- DO NOT modify any signals, ports, or entities above this line
-- Recommendation: Create 2 processes (one for updating state status and the other for describing transitions and outputs)
-- Figure out the appropriate sensitivity list of both the processes.
-- Use CASE statements and IF/ELSE/ELSIF statements to describe your processes.
-- add your code here
	type Statetype is 
		(Initial, five, ten, fifteen, twenty, five_wait, ten_wait, fifteen_wait, cancel,
			 twenty_plus);
	signal current_state, next_state: Statetype;

	begin
		CombLogic: Process(Input, current_state)
		begin
			case current_state is
				when Initial =>
					Permit <= '0';
					ReturnChange <= '0';
					if(Input = "001") then
						next_state <= five;
					elsif(Input = "010") then
						next_state <= ten;
					elsif(Input = "100") then
						next_state <= twenty;
					else
						next_state <= Initial;
					end if;

				when five =>
					Permit <= '0';
					ReturnChange <= '0';
					next_state <= five_wait;

				when ten =>
					Permit <= '0';
					ReturnChange <= '0';
					next_state <= ten_wait;

				when fifteen =>
					Permit <= '0';
					ReturnChange <= '0';
					next_state <= fifteen_wait;

				when twenty =>
					Permit <= '1';
					ReturnChange <= '0';
					next_state <= Initial;

				when twenty_plus =>
					Permit <= '1';
					ReturnChange <= '1';
					next_state <= Initial;

				when cancel =>
					Permit <= '0';
					ReturnChange <= '1';
					next_state <= Initial;

				when five_wait =>
					Permit <= '0';
					ReturnChange <= '0';
					if(Input = "001") then
						next_state <= ten;
					elsif(Input = "010") then
						next_state <= fifteen;
					elsif(Input = "100") then
						next_state <= twenty_plus;
					elsif(Input = "111") then
						next_state <= cancel;
					else
						next_state <= five_wait;
					end if;

				when ten_wait =>
					Permit <= '0';
					ReturnChange <= '0';
					if(Input = "001") then
						next_state <= fifteen;
					elsif(Input = "010") then
						next_state <= twenty;
					elsif(Input = "100") then
						next_state <= twenty_plus;
					elsif(Input = "111") then
						next_state <= cancel;
					else
						next_state <= ten_wait;
					end if;

				when fifteen_wait =>
					Permit <= '0';
					ReturnChange <= '0';
					if(Input = "001") then
						next_state <= twenty;
					elsif(Input = "010") then
						next_state <= twenty_plus;
					elsif(Input = "100") then
						next_state <= twenty_plus;
					elsif(Input = "111") then
						next_state <= cancel;
					else
						next_state <= fifteen_wait;
					end if;

			end case;
		end Process CombLogic;

		StateRegister: Process(Clk)
		begin
			if(Clk = '1' and Clk'EVENT) then
				current_state <= next_state;
			end if;
		end Process StateRegister;

END Behavioral;