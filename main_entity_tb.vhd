--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:57:17 09/07/2017
-- Design Name:   
-- Module Name:   C:/Users/diksha/multiplier/lab6_multiplier_tb.vhd
-- Project Name:  multiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lab6_multiplier
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY mini_project_tb IS
END mini_project_tb;
 
ARCHITECTURE behavior OF mini_project_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component mini_project is
	port(
	    mode: IN std_logic_vector(1 downto 0);
	    specify_currency: IN std_logic_vector(11 downto 0);
	    type_currency: IN std_logic_vector(1 downto 0);
	    -- 00 FOR 1
	    -- 01 FOR 5
	    -- 10 FOR 10
	    -- 11 FOR 100
	    confirm : IN STD_LOGIC;
	    clk : IN STD_LOGIC;
	    reset: IN std_logic;
	    show_type: OUT std_logic_vector(1 downto 0);
	    err: OUT STD_LOGIC;
	    back: IN STD_LOGIC;
	    show_number: OUT std_logic_vector(7 downto 0) -- bcd representation of number
	);
    end component;
-- Custom Types
	type display_output is array (0 to 15) of std_logic_vector(6 downto 0);
	type anode_output_array is array(0 to 3) of std_logic_vector(3 downto 0);

   --Inputs
   signal mode : std_logic_vector(1 downto 0) := "00";
   signal specify_currency : std_logic_vector(11 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal confirm : std_logic := '0';
   signal type_currency : std_logic_vector(1 downto 0) := (others => '0');
   signal reset : std_logic := '0';
   signal back : std_logic := '0';

 	--Outputs
   signal show_type : std_logic_vector(1 downto 0) := "00";
   signal show_number : std_logic_vector(7 downto 0):= "10011001";
   signal err : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   signal err_cnt_signal : integer := 1;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mini_project PORT MAP (
          mode => mode,
          specify_currency => specify_currency,
          type_currency => type_currency,
          confirm => confirm,
          clk => clk,
          reset => reset,
          show_type => show_type,
          err => err,
          back => back,
          show_number => show_number
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
		variable err_cnt : INTEGER := 0;
   begin		
     
		------------------------------------------------------------
      --------------------- pre-case 0 ---------------------------
		------------------------------------------------------------
		
		-- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication
		reset <= '1';

		wait for clk_period;

		reset <='0';

		wait for clk_period*2;
		-- Set inputs
		
      -------------------------------------------------------------
		---------------------  case  1-------------------------------
		-------------------------------------------------------------
	
		-------------------------add more test cases---------------------------------------------
		report "Testbench Sequential Steps Set-1";
		report "1. Specify Mode - hu: 94, te: 89, fi: 40, on: 49";
		report "2. Highest Denomination Mode - 700";
		report "3. Auto Mode - 702, 700";
		 
		report "Testing Display Mode (00)";
		
		--case 1
		if (show_number /= "10011001") then 
		err_cnt := err_cnt + 1;
		report "Number of one reported wrong";
		end if;
		
		--case 2
		type_currency<="01";
		wait for clk_period;
		
		if (show_number /= "01010000") then err_cnt := err_cnt + 1;
        report "Error count increased to " & integer'image(err_cnt);
        report "Number of five notes reported wrong";
        end if;
        
        --case 3
        type_currency<="10";
		wait for clk_period;
		
		if (show_number /= "10011001") then 
        err_cnt := err_cnt + 1;
        report "Number of ten reported wrong";
        end if;
        
        --case 4
        type_currency<="11";
        wait for clk_period;
                
		if (show_number /= "10011001") then 
        err_cnt := err_cnt + 1;
        report "Number of hundred reported wrong";
        end if;
        wait for clk_period;
        report "Testing of Display Mode (00) successfully completed";
        
        report "Testing Specify Mode (11)";
        
        mode <= "11";
        wait for clk_period;
        
        --case 5
        type_currency <= "11";
        specify_currency(11 downto 4) <= "10010100";
        wait for clk_period;
        
        confirm <='1';
        wait for clk_period;
        
        confirm<='0';
        mode<="00";
        wait for clk_period;
        
        if (show_number /= "00000101") then
        err_cnt := err_cnt + 1;
        report "Number of hundred reported wrong in mode 11";
        end if;
        wait for clk_period;
        
        mode <= "11";
        wait for clk_period;
        
        --case 6
        type_currency <= "10";
        specify_currency(11 downto 4) <= "10001001";
        wait for clk_period;
        
        confirm <='1';
        wait for clk_period;
        
        confirm<='0';
        mode<="00";
        wait for clk_period;
        
        if (show_number /= "00010000") then
        err_cnt := err_cnt + 1;
        report "Number of ten reported wrong in mode 11";
        end if;
        wait for clk_period;
        
        mode <= "11";
        wait for clk_period;
        
        --case 7
        type_currency <= "01";
        specify_currency(11 downto 4) <= "01000000";
        wait for clk_period;
        
        confirm <='1';
        wait for clk_period;
        
        confirm<='0';
        mode<="00";
        wait for clk_period;
        
        if (show_number /= "00010000") then
        err_cnt := err_cnt + 1;
        report "Number of five reported wrong in mode 11";
        end if;
        wait for clk_period;
        
        mode <= "11";
        wait for clk_period;
        
        --case 8
        type_currency <= "00";
        specify_currency(11 downto 4) <= "01001001";
        wait for clk_period;
        
        confirm <='1';
        wait for clk_period;
        
        confirm<='0';
        mode<="00";
        wait for clk_period;
        
        if (show_number /= "01010000") then
        err_cnt := err_cnt + 1;
        report "Number of ten reported wrong in mode 11";
        end if;
        wait for clk_period;
        
        report "Testing of Specify Mode (11) successfully completed";
        
        mode <= "10";
        wait for clk_period;
        
        --case 9
        specify_currency <= "011100000000";
        wait for clk_period;
        
        confirm<='1';
        wait for clk_period;
        
        confirm<='0';
        if (err/='1') then report "Error in highest denomination"; err_cnt := err_cnt + 1; end if;
        wait for clk_period;
        
        back<='1';
        wait for clk_period;
        back<='0';
        
         report "Testing of Highest Denomination Mode (10) successfully completed";
        
        mode <= "01";
        wait for clk_period;
        
        --case 10
        specify_currency <= "011100000010";
        wait for clk_period;
        
        confirm<='1';
        wait for clk_period;
        
        confirm<='0';
        if (err/='1') then report "Error in highest denomination"; err_cnt := err_cnt + 1; end if;
        wait for clk_period;
        
        back<='1';
        wait for clk_period;
        back<='0';
        wait for clk_period;
        
        --case 11
        specify_currency <= "011100000000";
        wait for clk_period;
        confirm <= '1';
        wait for clk_period;
        confirm<='0';
        mode <= "00";
        type_currency <= "00";
        wait for clk_period;
        
        if (show_number /= "00000000") then 
        err_cnt := err_cnt + 1;
        report "Number of one reported wrong";
        end if;
        
        --case 12
        type_currency<="01";
        wait for clk_period;
        
        if (show_number /= "00000000") then err_cnt := err_cnt + 1;
        report "Number of five notes reported wrong";
        end if;
        
        --case 13
        type_currency<="10";
        wait for clk_period;
        
        if (show_number /= "00000000") then 
        err_cnt := err_cnt + 1;
        report "Number of ten reported wrong";
        end if;
        
        --case 14
        type_currency<="11";
        wait for clk_period;
                
        if (show_number /= "00000000") then 
        err_cnt := err_cnt + 1;
        report "Number of hundred reported wrong";
        end if;
        wait for clk_period;
        
         report "Testing of Auto Mode (01) successfully completed";
         
        -------------------------end of case 1---------------------------------------------
        
        reset <= '1';
        
        wait for clk_period;

        reset <='0';

        wait for clk_period*2;
-------------------------------------------------------------
   ---------------------  case  2-------------------------------
   -------------------------------------------------------------

   report "Testbench Sequential Steps Set-2";
   report "1. Highest Denomination Mode - 345";
   report "2. Specify Mode - hu: 96, te: 95, fi: 50, on: 00";
   report "3. Auto Mode - 344";
    
   report "Testing Display Mode (00)";
   
   --case 15
   if (show_number /= "10011001") then 
   err_cnt := err_cnt + 1;
   report "Number of one reported wrong";
   end if;
   
   --case 16
   type_currency<="01";
   wait for clk_period;
   
   if (show_number /= "01010000") then err_cnt := err_cnt + 1;
   report "Error count increased to " & integer'image(err_cnt);
   report "Number of five notes reported wrong";
   end if;
   
   --case 17
   type_currency<="10";
   wait for clk_period;
   
   if (show_number /= "10011001") then 
   err_cnt := err_cnt + 1;
   report "Number of ten reported wrong";
   end if;
   
   --case 18
   type_currency<="11";
   wait for clk_period;
           
   if (show_number /= "10011001") then 
   err_cnt := err_cnt + 1;
   report "Number of hundred reported wrong";
   end if;
   wait for clk_period;
   report "Testing of Display Mode (00) successfully completed";
   
   report "Testing of Highest Denomination Mode (10)";
   mode <= "10";
  wait for clk_period;
  
  --case 19
  specify_currency <= "001101000101";
  wait for clk_period;
  
  confirm<='1';
  wait for clk_period;
  
  confirm<='0';
  
  mode<="00";type_currency<="11";
 wait for clk_period;
 
    if (show_number /= "10010110") then
    err_cnt := err_cnt + 1;
    report "Number of hundred reported wrong in mode 10";
    end if;
    wait for clk_period;
  report "Testing of Highest Denomination Mode (10) successfully completed";
  
   report "Testing Specify Mode (11)";
   mode <= "11";
   wait for clk_period;
  
  --case 20 
   type_currency <= "11";
   specify_currency(11 downto 4) <= "10010110";
   wait for clk_period;
   
   confirm <='1';
   wait for clk_period;
   
   confirm<='0';
   mode<="00"; 
   wait for clk_period;
   
   if (show_number /= "00000000") then
   err_cnt := err_cnt + 1;
   report "Number of hundred reported wrong in mode 11";
   end if;
   wait for clk_period;
 
   mode <= "11";
   wait for clk_period;
 
 --case 21  
   type_currency <= "10";
   specify_currency(11 downto 4) <= "10010101";
   wait for clk_period;
   
   confirm <='1';
   wait for clk_period;
   
   confirm<='0';
   mode<="00";
   wait for clk_period;
   
   if (show_number /= "00000000") then
   err_cnt := err_cnt + 1;
   report "Number of ten reported wrong in mode 11";
   end if;
   wait for clk_period;
   
   mode <= "11";
   wait for clk_period;
   
   --case 22
   type_currency <= "01";
   specify_currency(11 downto 4) <= "01010000";
   wait for clk_period;
   
   confirm <='1';
   wait for clk_period;
   
   confirm<='0';
   if (err/='1') then report "Error not shown in specify mode"; 
   err_cnt := err_cnt + 1; 
   end if;
   wait for clk_period;
   
   back<='1';
   wait for clk_period;
   
   back<='0';
   
   mode <= "01";
   wait for clk_period;
   
   --case 23
   specify_currency <= "001101000100";
   wait for clk_period;
   
   confirm <='1';
   wait for clk_period;
   
   confirm<='0';
   mode<="00"; type_currency<="00";
   wait for clk_period;
   
   if (show_number /= "00000000") then
   err_cnt := err_cnt + 1;
   report "Number of ten reported wrong in mode 11";
   end if;
   wait for clk_period;
   
   report "Testing of Auto Mode (01) successfully completed";
    
--   -------------------------end of case 2---------------------------------------------
		err_cnt_signal <= err_cnt;		
		-- summary of all the tests
		if (err_cnt=0) then
			 assert false
			 report "All cases tested successfully"
			 severity note;
		else
			 assert false
			 report "Something wrong, try again"
			 severity error;
		end if;

      -- end of tb 
		wait for clk_period*100;

      wait;
   end process;


END;
