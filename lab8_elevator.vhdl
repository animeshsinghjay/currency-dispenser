library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
--This is the main entity of the elevator. On giving the reset the entire lift will go to a known state. Every floor has
--an up and down switch that can tell the lift to go up and down. These switches exist on the top and the bottom floor but
--will not trigger any action. 
ENTITY lab8_elevator_control IS
    PORT(
        up_request: in STD_LOGIC_VECTOR(3 downto 0);
        down_request: in STD_LOGIC_VECTOR(3 downto 0);
        up_request_indicator: out STD_LOGIC_VECTOR(3 downto 0);
        down_request_indicator: out STD_LOGIC_VECTOR(3 downto 0);
        reset: in STD_LOGIC;
        cathode: out STD_LOGIC_VECTOR(6 downto 0);
        anode: out STD_LOGIC_VECTOR(3 downto 0);
        door_open: in STD_LOGIC_VECTOR(1 downto 0);
        door_closed: in STD_LOGIC_VECTOR(1 downto 0);
        clk: in STD_LOGIC;
        lift1_floor: in STD_LOGIC_VECTOR(3 downto 0);
        lift2_floor: in STD_LOGIC_VECTOR(3 downto 0);
        lift1_floor_indicator: out STD_LOGIC_VECTOR(3 downto 0);
        lift2_floor_indicator: out STD_LOGIC_VECTOR(3 downto 0);
        sim_mode: in STD_LOGIC
        );
END lab8_elevator_control;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

-- This entity handles all the requests for the lift. It takes as input the floor on which the lift is currently and
-- also the state ie. if it is going up or down. If it is going in the direction needed, with preference to lift1 the 
-- request is given. The lift controller is only given correct requests. The go-to signal for each lift is given the destinations.
ENTITY request_handler IS
PORT (
		reset: IN std_logic;
		up_request: IN std_logic_vector(3 downto 0);
		down_request: IN std_logic_vector(3 downto 0);
		lift1_status_state: IN std_logic_vector(1 downto 0);
		-- STATUS STATE IS DEFINED AS
		-- 00 - UP GOING LIFT
		-- 01 - DOWN GOING LIFT
		-- 10 - HALTED WITH DOOR CLOSED
		-- 11 - HALTED WITH DOOR OPENED
		lift1_status_floor: IN std_logic_vector(1 downto 0);
		lift2_status_state: IN std_logic_vector(1 downto 0);
		lift2_status_floor: IN std_logic_vector(1 downto 0);
		lift1_state:IN STD_LOGIC_VECTOR(1 downto 0);
		-- STATE IS DEFINED AS
		-- 00 - reqUp
		-- 01 - reqDown
		-- 10 - idle
		lift2_state: IN STD_LOGIC_VECTOR(1 downto 0);
		lift1_goto: OUT std_logic_vector(3 downto 0);
		lift2_goto: OUT std_logic_vector(3 downto 0);
		clk : IN STD_LOGIC   -- Clocking for the process to work
		up_output: OUT std_logic_vector(3 downto 0); -- LED Output
		down_output: OUT std_logic_vector(3 downto 0) -- LED Output
     );
END ENTITY request_handler;

architecture Behavioral of request_handler is

	signal up_done: std_logic_vector(3 downto 0);
	signal down_done: std_logic_vector(3 downto 0);
	signal up: std_logic_vector(3 downto 0);
	signal down: std_logic_vector(3 downto 0);
begin
	--for i in 0 to 3 generate 
	--	if (up_request(i)=='1') then 
	--		up(i)<='1';
	--	end if;
	--	if (down_request(i)=='1') then 
	--		down(i)<='1';
	--	end if;
	--end generate;
	process(clk)
	begin
		if (clk='1' and clk'EVENT) then

			-- LOGGING OF REQUESTS
			if (up_request(0)='1') then 
				up(0)<='1';
				up_done(0)<='1';
			end if;
			if (up_request(1)='1') then 
				up(1)<='1';
				up_done(0)<='1';
			end if;
			if (up_request(2)='1') then 
				up(2)<='1';
				up_done(0)<='1';
			end if;
			-- Do LED's need to work?
			if (down_request(1)='1') then 
				down(1)<='1';
				down_done(1)<='1';
			end if;
			if (down_request(2)='1') then 
				down(2)<='1';
				down_done(2)<='1';
			end if;
			if (down_request(3)='1') then 
				down(3)<='1';
				down_done(3)<='1';
			end if;


			-- LIFT 1 is idle
			if (lift1_state="10") then
				-- Checking for UPreqUP
				if (lift1_status_floor < "01" and up_done(1)='1') then -- Thought about the lift logic(should go with which up request if two uprequp come(closer one first))
					lift1_goto(1)<='1';
					up_done(1)<='0';
				elsif (lift1_status_floor < "10" and up_done(2)='1') then
					lift1_goto(2)<='1';
					up_done(2)<='0';

				-- Checking for UpReqDown
				elsif (lift1_status_floor < "11" and down_done(3)='1') then -- Same thoughts
					lift1_goto(3)<='1';
					down_done(3)<='0';
				elsif (lift1_status_floor < "10" and down_done(2)='1') then
					lift1_goto(2)<='1';
					down_done(2)<='0';
				elsif (lift1_status_floor < "01" and down_done(1)='1') then
					lift1_goto(1)<='1';	
					down_done(1)<='0';
				-- Checking for DownReqUp
				elsif (lift1_status_floor > "10" and up_done(2)='1') then
					lift1_goto(2)<='1';
					up_done(2)<='0';
				elsif (lift1_status_floor > "01" and up_done(1)='1') then
					lift1_goto(1)<='1';
					up_done(1)<='0';
				elsif (lift1_status_floor > "00" and up_done(0)='1') then
					lift1_goto(0)<='1';
					up_done(0)<='0';
				-- Checking for DownReqDown
				elsif (lift1_status_floor > "10" and down_done(2)='1') then -- Thought about the lift logic(should go with which up request if two uprequp come(closer one first))
					lift1_goto(2)<='1';
					down_done(2)<='0';
				elsif (lift1_status_floor > "01" and down_done(1)='1') then
					lift1_goto(1)<='1';
					down_done(1)<='0';
				end if;

			-- Lift 2 is Idle
			elsif (lift2_state="10") then
				-- Checking for UPreqUP
				if (lift2_status_floor < "01" and up_done(1)='1') then -- Thought about the lift logic(should go with which up request if two uprequp come(closer one first))
					lift2_goto(1)<='1';
					up_done(1)<='0';
				elsif (lift2_status_floor < "10" and up_done(2)='1') then
					lift2_goto(2)<='1';
					up_done(2)<='0';

				-- Checking for UpReqDown
				elsif (lift2_status_floor < "11" and down_done(3)='1') then -- Same thoughts
					lift2_goto(3)<='1';
					down_done(3)<='0';
				elsif (lift2_status_floor < "10" and down_done(2)='1') then
					lift2_goto(2)<='1';
					down_done(2)<='0';
				elsif (lift2_status_floor < "01" and down_done(1)='1') then
					lift2_goto(1)<='1';	
					down_done(1)<='0';
				-- Checking for DownReqUp
				elsif (lift2_status_floor > "10" and up_done(2)='1') then
					lift2_goto(2)<='1';
					up_done(2)<='0';
				elsif (lift2_status_floor > "01" and up_done(1)='1') then
					lift2_goto(1)<='1';
					up_done(1)<='0';
				elsif (lift2_status_floor > "00" and up_done(0)='1') then
					lift2_goto(0)<='1';
					up_done(0)<='0';	
				-- Checking for DownReqDown
				elsif (lift2_status_floor > "10" and down_done(2)='1') then -- Thought about the lift logic(should go with which up request if two uprequp come(closer one first))
					lift2_goto(2)<='1';
					down_done(2)<='0';
				elsif (lift2_status_floor > "01" and down_done(1)='1') then
					lift2_goto(1)<='1';
					down_done(1)<='0';
				end if;
			else -- No lift is idle
				-- ASSIGNMENT OF REQUESTS TO LIFTS (UpReqUp)
				if (up_done(2)='1' and lift1_status_floor < "10" and lift1_state="00") then
					lift1_goto(2)<='1';
					up_done(2)<='0';
				elsif (up_done(2)='1' and lift2_status_floor < "10" and lift2_state="00") then
					lift2_goto(2)<='1';
					up_done(2)<='0';
				end if;
				if (up_done(1)='1' and lift1_status_floor < "01" and lift1_state="00") then
					lift1_goto(1)<='1';
					up_done(1)<='0';
				elsif (up_done(1)='1' and lift2_status_floor < "01" and lift2_state="00") then
					lift2_goto(1)<='1';
					up_done(1)<='0';
				end if;
				-- ASSIGNMENT OF REQUESTS TO LIFTS (DownReqDown)
				if (down_done(2)='1' and lift1_status_floor > "10" and lift1_state="01") then
					lift1_goto(2)<='1';
					down_done(2)<='0';
				elsif (down_done(2)='1' and lift2_status_floor > "10" and lift2_state="01") then
					lift2_goto(2)<='1';
					down_done(2)<='0';
				end if;
				if (down_done(1)='1' and lift1_status_floor > "01" and lift1_state="01") then
					lift1_goto(1)<='1';
					down_done(1)<='0';
				elsif (down_done(1)='1' and lift2_status_floor > "01" and lift2_state="01") then
					lift2_goto(1)<='1';
					down_done(1)<='0';
				end if;
			end if;

			-- Up Request Fulfilled (Lift 1)
			-- Logic needs to be improved considering there are two lifts (probably will work)
			-- Do we need to keep the different lifts in the same elsif??
			if (lift1_status_state="11" and lift1_floor="00" and lift1_state/="01" and up(0)='1') then
				up(0)<='0';
				lift1_goto(0)<='0';
			elsif (lift1_status_state="11" and lift1_floor="01" and lift1_state/="01" and up(1)='1') then
				up(1)<='0';
				lift1_goto(1)<='0';
			elsif (lift1_status_state="11" and lift1_floor="10" and lift1_state/="01" and up(2)='1') then
				up(2)<='0';
				lift1_goto(2)<='0';
			end if; 

			-- Down Request Fulfilled (Lift 1)
			if (lift1_status_state="11" and lift1_floor="01" and lift1_state/="00" and down(1)='1') then
				down(1)<='0';
				lift1_goto(1)<='0';
			elsif (lift1_status_state="11" and lift1_floor="10" and lift1_state/="00" and down(2)='1') then
				down(2)<='0';
				lift1_goto(2)<='0';
			elsif (lift1_status_state="11" and lift1_floor="11" and lift1_state/="00" and down(3)='1') then
				down(3)<='0';
				lift1_goto(3)<='0';
			end if;

			-- Up Request Fulfilled (Lift 2)
			if (lift2_status_state="11" and lift2_floor="00" and lift2_state/="01" and up(0)='1') then
				up(0)<='0';
				lift2_goto(0)<='0';
			elsif (lift2_status_state="11" and lift2_floor="01" and lift2_state/="01" and up(1)='1') then
				up(1)<='0';
				lift2_goto(1)<='0';
			elsif (lift2_status_state="11" and lift2_floor="10" and lift2_state/="01" and up(2)='1') then
				up(2)<='0';
				lift2_goto(2)<='0';
			end if; 

			-- Down Request Fulfilled (Lift 2)
			if (lift2_status_state="11" and lift2_floor="01" and lift2_state/="00" and down(1)='1') then
				down(1)<='0';
				lift2_goto(1)<='0';
			elsif (lift2_status_state="11" and lift2_floor="10" and lift2_state/="00" and down(2)='1') then
				down(2)<='0';
				lift2_goto(2)<='0';
			elsif (lift2_status_state="11" and lift2_floor="11" and lift2_state/="00" and down(3)='1') then
				down(3)<='0';
				lift2_goto(3)<='0';
			end if; 
		end if;
	end process ; -- d architecture; -- Behavioral
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

-- These are the controllers of the lift. It moves the lift around and defines the floor it is currently and the state 
-- that is if it is going up or down or is idle and hence can take new requests.
ENTITY lift1_controller IS
PORT (
		lift1_floor: IN std_logic_vector(3 downto 0);
		lift1_goto: IN std_logic_vector(3 downto 0);
		lift1_status_state: OUT std_logic_vector(1 downto 0);
		lift1_status_floor: OUT std_logic_vector(1 downto 0);
		lift1_state: OUT std_logic_vector(1 downto 0);
		clk: in STD_LOGIC
     );
END lift1_controller;

architecture behavioral of lift1_controller is
	signal dest_pressed: std_logic_vector(3 downto 0);
	signal dest_pressed_done: std_logic_vector(3 downto 0);
	signal target: STD_LOGIC_VECTOR(3 downto 0); --Where the lift will go
	signal counter_up: integer := 0;
	signal counter_close: integer := 0;
	signal counter_open: integer := 0;
begin
	process(clk)
	-- on reset lift will be in idle state
		if (clk='1' and clk'EVENT)
			if (lift1_goto(0)='1') then
				target(0)<='1';
			end if;
			if (lift1_goto(1)='1') then
				target(1)<='1';
			end if;
			if (lift1_goto(2)='1') then
				target(2)<='1';
			end if;
			if (lift1_goto(3)='1') then
				target(3)<='1';
			end if;
			if (lift1_floor(0)='1' and lift1_status_floor/="00") then
				dest_pressed(0)<='1';
				dest_pressed_done(0)<='1';
			end if;
			if (lift1_floor(1)='1'  and lift1_status_floor/="01") then
				dest_pressed(1)<='1';
				dest_pressed_done(1)<='1';
			end if;
			if (lift1_floor(2)='1' and lift1_status_floor/="10") then
				dest_pressed(2)<='1';
				dest_pressed_done(2)<='1';
			end if;
			if (lift1_floor(3)='1' and lift1_status_floor/="11") then
				dest_pressed(3)<='1';
				dest_pressed_done(3)<='1'; 
			end if;

	-- if lift is idle, first change its state(idle to going up or down)
			if (lift1_state="10" and lift1_status_floor="00") then
				if (dest_pressed_done(1)='1' or dest_pressed_done(2)='1' or dest_pressed_done(3)='1') then
					lift1_state = "00";
				elsif (target(1) ='1' or target(2) ='1' or target(3) ='1') then
					lift1_state = "00";
				end if;
			elsif (lift1_state="10" and lift1_status_floor="01") then
				if (dest_pressed_done(2)='1' or dest_pressed_done(3)='1') then
					lift1_state = "00";
				elsif (dest_pressed_done(0)='1') then
					lift1_state = "01";
				elsif (target(2)='1' or target(3)='1') then
					lift1_state = "00";
				elsif (target(0)='1') then
					lift1_state = "01";
				end if;
			elsif (lift1_state="10" and lift1_status_floor="10") then
				if (dest_pressed_done(3)='1') then
					lift1_state = "00";
				elsif (dest_pressed_done(0)='1' or dest_pressed_done(1)='1') then
					lift1_state = "01";
				elsif (target(3)='1') then
					lift1_state = "00";
				elsif (target(0)='1' or target(1)='1') then
					lift1_state = "01";
				end if;
			elsif (lift1_state="10" and lift1_status_floor="11") then
				if (dest_pressed_done(0)='1' or dest_pressed_done(1)='1' or dest_pressed_done(2)='1') then
					lift1_state = "01";
				elsif (target(0)='1' or target(1)='1' or target(2)='1') then
					lift1_state = "01";
				end if;
			elsif (lift1_state="00") then
				if (lift1_status_state="11") -- open state
					--wait for 1.5s using a counter
					if (counter_open<100000000) then
						counter_open := counter_open + 1;
					elsif (counter_open<150000000) then
						counter_open := counter_open + 1;
						if (lift1_status_floor = "00" and target(3 downto 1)="000" and dest_pressed_done(3 downto 1)="000") then
							lift1_state = "10";
						elsif (lift1_status_floor = "01" and target(3 downto 2)="00" and dest_pressed_done(3 downto 2)="00") then
							lift1_state = "10";
						elsif (lift1_status_floor = "10" and target(3)='0' and dest_pressed_done(3)='0') then
							lift1_state = "10";
						elsif (lift1_status_floor = "11") then
							lift1_state = "10";
						end if;
					else
						counter_open := 0;
						lift1_status_state = "00";
					end if;
					--counter overridden by door-close(??)
					-- goes to up state
					--checks if any left
				elsif (lift1_status_state="10") then -- closed state
					-- wait for 0.5s
					-- goes to open state
					if (lift1_status_floor="00" and dest_pressed_done(0)='1') then
						dest_pressed_done(0)<='0';
						dest_pressed(0)<='0';
					elsif (lift1_status_floor="01" and dest_pressed_done(1)='1') then
						dest_pressed_done(1)<='0';
						dest_pressed(1)<='0';
					elsif (lift1_status_floor="10" and dest_pressed_done(2)='1') then
						dest_pressed_done(2)<='0';
						dest_pressed(2)<='0';
					elsif (lift1_status_floor="11" and dest_pressed_done(3)='1') then
						dest_pressed_done(3)<='0';
						dest_pressed(3)<='0';
					end if ;
					if (counter_close<50000000) then
						counter_close := counter_close + 1;
					else
						counter_close := 0;
						lift1_status_state = "11";
					end if ;
				elsif (lift1_status_state="00") then -- up state
					-- wait for 2s
					-- goes to next floor
					-- goes to closed state
					if (counter_up<200000000) then
						counter_up := counter_up + 1;
					else
						counter_up := 0;
						lift1_status_floor <= lift1_status_floor + 1;
						lift1_status_state <= "10";
					end if ;
				end if;
			elsif (lift1_state="01") then
				if (lift1_status_state="11") -- open state
					--wait for 1.5s using a counter
					if (counter_open<100000000) then
						counter_open := counter_open + 1;
					elsif (counter_open<150000000) then
						counter_open := counter_open + 1;
						if (lift1_status_floor = "11" and target(2 downto 0)="000" and dest_pressed_done(2 downto 0)="000") then
							lift1_state = "10";
						elsif (lift1_status_floor = "10" and target(1 downto 0)="00" and dest_pressed_done(1 downto 0)="00") then
							lift1_state = "10";
						elsif (lift1_status_floor = "01" and target(0)='0' and dest_pressed_done(0)='0') then
							lift1_state = "10";
						elsif (lift1_status_floor = "00") then
							lift1_state = "10";
						end if;
					else
						counter_open := 0;
						lift1_status_state <= "01";
					end if;
					--counter overridden by door-close(??)
					-- goes to up state
					--checks if any left
				elsif (lift1_status_state="10") then -- closed state
					-- wait for 0.5s
					-- goes to open state
					if (lift1_status_floor="00" and dest_pressed_done(0)='1') then
						dest_pressed_done(0)<='0';
						dest_pressed(0)<='0';
					elsif (lift1_status_floor="01" and dest_pressed_done(1)='1') then
						dest_pressed_done(1)<='0';
						dest_pressed(1)<='0';
					elsif (lift1_status_floor="10" and dest_pressed_done(2)='1') then
						dest_pressed_done(2)<='0';
						dest_pressed(2)<='0';
					elsif (lift1_status_floor="11" and dest_pressed_done(3)='1') then
						dest_pressed_done(3)<='0';
						dest_pressed(3)<='0';
					end if ;
					if (counter_close<50000000) then
						counter_close := counter_close + 1;
					else
						counter_close := 0;
						lift1_status_state = "11";
					end if ;
				elsif (lift1_status_state="01") then -- down state
					-- wait for 2s
					-- goes to next floor
					-- goes to closed state
					if (counter_up<200000000) then
						counter_up := counter_up + 1;
					else
						counter_up :=0;
						lift1_status_floor <= lift1_status_floor - 1;
						lift1_status_state <= "10";
					end if ;
				end if;
			end if;

		end if;
	end process;
end architecture ; -- behavioral

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

ENTITY lift2_controller IS
PORT (
		lift2_floor: IN std_logic_vector(3 downto 0);
		lift2_goto: IN std_logic_vector(3 downto 0);
		lift2_status_state: OUT std_logic_vector(1 downto 0);
		lift2_status_floor: OUT std_logic_vector(1 downto 0);
		idle_2:OUT STD_LOGIC
     );
END ENTITY lift2_controller;

architecture behavioral of lift2_controller is
	signal dest_pressed: std_logic_vector(3 downto 0);
	signal dest_pressed_done: std_logic_vector(3 downto 0);
	signal target: STD_LOGIC_VECTOR(3 downto 0); --Where the lift will go
	signal counter_up: integer := 0;
	signal counter_close: integer := 0;
	signal counter_open: integer := 0;
begin
	process(clk)
	-- on reset lift will be in idle state
		if (clk='1' and clk'EVENT)
			if (lift2_goto(0)='1') then
				target(0)<='1';
			end if;
			if (lift2_goto(1)='1') then
				target(1)<='1';
			end if;
			if (lift2_goto(2)='1') then
				target(2)<='1';
			end if;
			if (lift2_goto(3)='1') then
				target(3)<='1';
			end if;
			if (lift2_floor(0)='1' and lift2_status_floor/="00") then
				dest_pressed(0)<='1';
				dest_pressed_done(0)<='1';
			end if;
			if (lift2_floor(1)='1'  and lift2_status_floor/="01") then
				dest_pressed(1)<='1';
				dest_pressed_done(1)<='1';
			end if;
			if (lift2_floor(2)='1' and lift2_status_floor/="10") then
				dest_pressed(2)<='1';
				dest_pressed_done(2)<='1';
			end if;
			if (lift2_floor(3)='1' and lift2_status_floor/="11") then
				dest_pressed(3)<='1';
				dest_pressed_done(3)<='1'; 
			end if;

	-- if lift is idle, first change its state(idle to going up or down)
			if (lift2_state="10" and lift2_status_floor="00") then
				if (dest_pressed_done(1)='1' or dest_pressed_done(2)='1' or dest_pressed_done(3)='1') then
					lift2_state = "00";
				elsif (target(1) ='1' or target(2) ='1' or target(3) ='1') then
					lift2_state = "00";
				end if;
			elsif (lift2_state="10" and lift2_status_floor="01") then
				if (dest_pressed_done(2)='1' or dest_pressed_done(3)='1') then
					lift2_state = "00";
				elsif (dest_pressed_done(0)='1') then
					lift2_state = "01";
				elsif (target(2)='1' or target(3)='1') then
					lift2_state = "00";
				elsif (target(0)='1') then
					lift2_state = "01";
				end if;
			elsif (lift2_state="10" and lift2_status_floor="10") then
				if (dest_pressed_done(3)='1') then
					lift2_state = "00";
				elsif (dest_pressed_done(0)='1' or dest_pressed_done(1)='1') then
					lift2_state = "01";
				elsif (target(3)='1') then
					lift2_state = "00";
				elsif (target(0)='1' or target(1)='1') then
					lift2_state = "01";
				end if;
			elsif (lift2_state="10" and lift2_status_floor="11") then
				if (dest_pressed_done(0)='1' or dest_pressed_done(1)='1' or dest_pressed_done(2)='1') then
					lift2_state = "01";
				elsif (target(0)='1' or target(1)='1' or target(2)='1') then
					lift2_state = "01";
				end if;
			elsif (lift2_state="00") then
				if (lift2_status_state="11") -- open state
					--wait for 1.5s using a counter
					if (counter_open<100000000) then
						counter_open := counter_open + 1;
					elsif (counter_open<150000000) then
						counter_open := counter_open + 1;
						if (lift2_status_floor = "00" and target(3 downto 1)="000" and dest_pressed_done(3 downto 1)="000") then
							lift2_state = "10";
						elsif (lift2_status_floor = "01" and target(3 downto 2)="00" and dest_pressed_done(3 downto 2)="00") then
							lift2_state = "10";
						elsif (lift2_status_floor = "10" and target(3)='0' and dest_pressed_done(3)='0') then
							lift2_state = "10";
						elsif (lift2_status_floor = "11") then
							lift2_state = "10";
						end if;
					else
						counter_open := 0;
						lift2_status_state = "00";
					end if;
					--counter overridden by door-close(??)
					-- goes to up state
					--checks if any left
				elsif (lift2_status_state="10") then -- closed state
					-- wait for 0.5s
					-- goes to open state
					if (lift2_status_floor="00" and dest_pressed_done(0)='1') then
						dest_pressed_done(0)<='0';
						dest_pressed(0)<='0';
					elsif (lift2_status_floor="01" and dest_pressed_done(1)='1') then
						dest_pressed_done(1)<='0';
						dest_pressed(1)<='0';
					elsif (lift2_status_floor="10" and dest_pressed_done(2)='1') then
						dest_pressed_done(2)<='0';
						dest_pressed(2)<='0';
					elsif (lift2_status_floor="11" and dest_pressed_done(3)='1') then
						dest_pressed_done(3)<='0';
						dest_pressed(3)<='0';
					end if ;
					if (counter_close<50000000) then
						counter_close := counter_close + 1;
					else
						counter_close := 0;
						lift2_status_state = "11";
					end if ;
				elsif (lift2_status_state="00") then -- up state
					-- wait for 2s
					-- goes to next floor
					-- goes to closed state
					if (counter_up<200000000) then
						counter_up := counter_up + 1;
					else
						counter_up := 0;
						lift2_status_floor <= lift2_status_floor + 1;
						lift2_status_state <= "10";
					end if ;
				end if;
			elsif (lift2_state="01") then
				if (lift2_status_state="11") -- open state
					--wait for 1.5s using a counter
					if (counter_open<100000000) then
						counter_open := counter_open + 1;
					elsif (counter_open<150000000) then
						counter_open := counter_open + 1;
						if (lift2_status_floor = "11" and target(2 downto 0)="000" and dest_pressed_done(2 downto 0)="000") then
							lift2_state = "10";
						elsif (lift2_status_floor = "10" and target(1 downto 0)="00" and dest_pressed_done(1 downto 0)="00") then
							lift2_state = "10";
						elsif (lift2_status_floor = "01" and target(0)='0' and dest_pressed_done(0)='0') then
							lift2_state = "10";
						elsif (lift2_status_floor = "00") then
							lift2_state = "10";
						end if;
					else
						counter_open := 0;
						lift2_status_state <= "01";
					end if;
					--counter overridden by door-close(??)
					-- goes to up state
					--checks if any left
				elsif (lift2_status_state="10") then -- closed state
					-- wait for 0.5s
					-- goes to open state
					if (lift2_status_floor="00" and dest_pressed_done(0)='1') then
						dest_pressed_done(0)<='0';
						dest_pressed(0)<='0';
					elsif (lift2_status_floor="01" and dest_pressed_done(1)='1') then
						dest_pressed_done(1)<='0';
						dest_pressed(1)<='0';
					elsif (lift2_status_floor="10" and dest_pressed_done(2)='1') then
						dest_pressed_done(2)<='0';
						dest_pressed(2)<='0';
					elsif (lift2_status_floor="11" and dest_pressed_done(3)='1') then
						dest_pressed_done(3)<='0';
						dest_pressed(3)<='0';
					end if ;
					if (counter_close<50000000) then
						counter_close := counter_close + 1;
					else
						counter_close := 0;
						lift2_status_state = "11";
					end if ;
				elsif (lift2_status_state="01") then -- down state
					-- wait for 2s
					-- goes to next floor
					-- goes to closed state
					if (counter_up<200000000) then
						counter_up := counter_up + 1;
					else
						counter_up :=0;
						lift2_status_floor <= lift2_status_floor - 1;
						lift2_status_state <= "10";
					end if ;
				end if;
			end if;

		end if;
	end process;
end architecture ; -- behavioral
-- This will be the entity which will drivew the seven segment display. It will slow the clock down and show u, d, o ,c
-- on appropriate states.
ENTITY status_display_block IS
PORT (
		lift1_status_state: IN std_logic_vector(1 downto 0);
		lift1_status_floor: IN std_logic_vector(1 downto 0);
		lift2_status_state: IN std_logic_vector(1 downto 0);
		lift2_status_floor: IN std_logic_vector(1 downto 0);
		cathode: out std_logic_vector(6 downto 0);
		anode: out std_logic_vector(3 downto 0)
     );
END ENTITY status_display_block;

architecture behavioral of lab8_elevator_control is

	signal lift1_goto: std_logic_vector(3 downto 0);
	signal lift2_goto: std_logic_vector(3 downto 0);
	signal lift1_status_floor: std_logic_vector(1 downto 0);
	signal lift1_status_state: std_logic_vector(1 downto 0);
	signal lift2_status_floor: std_logic_vector(1 downto 0);
	signal lift2_status_state: std_logic_vector(1 downto 0);

begin
	request_handler: work.request_handler
	PORT MAP();

	
end architecture ; -- behavioral