----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2017 11:41:32 AM
-- Design Name: 
-- Module Name: lab7_divider - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
ENTITY adder IS
    PORT(
        a: IN STD_LOGIC;
        b: IN STD_LOGIC;
        cin: IN STD_LOGIC;
        cout: OUT STD_LOGIC;
        s: OUT STD_LOGIC
        );
END adder;

ARCHITECTURE behavioural OF adder IS
    BEGIN
    s <= (a XOR b) XOR cin;
    cout <= (a AND b) OR (a AND cin) OR (cin AND b);
END behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

--entity subtract is
--    port(
--        a1: in STD_LOGIC_VECTOR(7 downto 0);
--        a2: in STD_LOGIC_VECTOR(7 downto 0);
--        b: out STD_LOGIC_VECTOR(7 downto 0)--;
--        --comp: out STD_LOGIC
--    );
--end subtract;

--ARCHITECTURE behavioural of subtract is
--	signal carry: STD_LOGIC_VECTOR(7 downto 0);
--	signal first_carry: STD_LOGIC;
--	signal c: STD_LOGIC_VECTOR(7 downto 0);
--	signal d: STD_LOGIC_VECTOR(7 downto 0);
--	BEGIN
--	first_carry<='1';
--	b<=d;
--	c<=not(a2);
--	first: ENTITY WORK.adder(behavioural)
--		PORT MAP(
--			a=>a1(0),
--			b=>c(0),
--			cin=>first_carry,
--			cout=>carry(0),
--			s=>d(0));
--	ADD1TO7: for i in 1 to 7 generate
--		ADDi: ENTITY WORK.adder(behavioural)
--			PORT MAP(
--				a=>a1(i),
--				b=>c(i),
--				cin=>carry(i-1),
--				cout=>carry(i),
--				s=>d(i)
--				);
--	end generate;
--	--comp <= not(d(7));
--end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity division is
        port(
            divisor: in STD_LOGIC_VECTOR(7 downto 0);
            dividend: in STD_LOGIC_VECTOR(7 downto 0);
            quotient: out STD_LOGIC_VECTOR(7 downto 0);
            remainder: out STD_LOGIC_VECTOR(7 downto 0);
            load_inputs:in STD_LOGIC;
            input_invalid:out STD_LOGIC;
            output_valid: out STD_LOGIC
        );
end division;

ARCHITECTURE behavioural of division is
    --signal r: STD_LOGIC_VECTOR(127 downto 0);
   -- signal d: STD_LOGIC_VECTOR(7 downto 0);
    --signal s: STD_LOGIC_VECTOR(63 downto 0);
    --signal rema: STD_LOGIC_VECTOR(7 downto 0);
    --signal quo: STD_LOGIC_VECTOR(7 downto 0);
--    signal answer_quotient: STD_LOGIC_VECTOR(7 downto 0);
--    signal answer_remainder: STD_LOGIC_VECTOR(7 downto 0);
    --signal q: STD_LOGIC_VECTOR(7 downto 0):="00000000";
    --signal temp_div: STD_LOGIC_VECTOR(15 downto 0);
    begin
        --quotient<=q;
        process(load_inputs,divisor,dividend)
            variable r: STD_LOGIC_VECTOR(15 downto 0);
            variable d: STD_LOGIC_VECTOR(7 downto 0);
--            variable answer_q : STD_LOGIC_VECTOR(7 downto 0);
--            variable answer_r : STD_LOGIC_VECTOR(7 downto 0);
            variable dividendneg: std_logic;
            variable divisorneg: std_logic;
            begin
            if (load_inputs='1' AND divisor/="00000000") then
                output_valid<='1';
                input_invalid<='0';
                --q<="00000000";
                if (dividend(7)='1') then 
                    r:="00000000"&(not(dividend) + "00000001");
                    dividendneg:='1';
                else dividendneg:='0'; r:="00000000"&dividend;
                end if;
                
                if (divisor(7)='1') then 
                    d:=not(divisor) + "00000001"; 
                    divisorneg:='1';
                else divisorneg:='0'; d:=divisor;
                end if;
                
                for i in 0 to 7 loop
                    r:= r(14 downto 0) & '0';
                    if (d<=r(15 downto 8)) then
                        r(15 downto 8) := r(15 downto 8) - d;
                        r := r + "00000001"; 
                    end if;
                end loop;
                
                if (divisorneg='0' and dividendneg='0')  then 
                    quotient <= r(7 downto 0);
                    remainder <= r(15 downto 8);  
                elsif (dividendneg='1' and divisorneg='0')  then 
                    quotient <= not(r(7 downto 0)) + "00000001";
                    remainder <= not(r(15 downto 8)) + "00000001"; 
                elsif (dividendneg='0' and divisorneg='1')  then 
                    quotient <= not(r(7 downto 0)) + "00000001";
                    remainder <= r(15 downto 8); 
                elsif (dividendneg='1' and divisorneg='1')  then 
                    quotient <= r(7 downto 0);
                    remainder <= not(r(15 downto 8)) + "00000001";                     
                end if;
                
            elsif (divisor="00000000") then 
                input_invalid<='1';
                output_valid<='0';
            else output_valid<='0'; input_invalid<='1';
            end if;
        end process;
        --r(15 downto 0) <= temp_div(14 downto 0) & '0';
--        ADD0: ENTITY WORK.subtract(behavioural)
--            PORT MAP(
--                a1=>r(15 downto 8),
--                a2=>d,
--                b=>s(7 downto 0));
        --r(31 downto 16)<= s(6 downto 0) & r(7 downto 0) & '1' when s(7)='0' else r(14 downto 0) & '0';
        --q<=q(6 downto 0) & '1' when s(7)='0' else q(6 downto 0)&'0';
--        ADD1TO7: for i in 1 to 7 generate
--            r(16*i + 15 downto 16*i) <= s(8*i-2 downto 8*(i-1)) & r(16*i-9 downto 16*(i-1)) & '1' when s(8*i-1)='0' else r(16*i-2 downto 16*(i-1)) & '0';
--            ADDi: ENTITY WORK.subtract(behavioural)
--                PORT MAP(
--                    a1=>r(16*i + 15 downto 16*i+8),
--                    a2=>d,
--                    b=>s(8*i-1 downto 8*(i-1)));
            --r(15 downto 8)<= s when s(7)='0';
--            --q<=q(6 downto 0) & '1' when s(7)='0' else q(6 downto 0)&'0';
--        end generate;
--        rema <= s(63 downto 56) when s(63)='0' else r(127 downto 120);
--        quo <= r(118 downto 112) & '1' when s(63)='0' else r(118 downto 112) & '0';
--        quotient <= not(quo) + "0000001" when ((fpositive='1' and spositive='0') or (fpositive='0' and spositive='1')) else quo;
--        remainder <= not(quo) + "0000001" when ((fpositive='1' and spositive='0') or (fpositive='0' and spositive='1')) else quo;
        
end behavioural;

-----------------------
---------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;
entity FTC_HXILINX_lab4_seven_segment_display is
    generic(INIT : bit := '0');
    port(
    Q   : out STD_LOGIC := '0';
    C   : in STD_LOGIC;
    CLR : in STD_LOGIC;
    T   : in STD_LOGIC
    );
end FTC_HXILINX_lab4_seven_segment_display;

architecture Behavioral of FTC_HXILINX_lab4_seven_segment_display is
signal q_tmp : std_logic := TO_X01(INIT);
begin

process(C, CLR)
begin
  if (CLR='1') then
    q_tmp <= '0';
  elsif (C'event and C = '1') then
    if(T='1') then
      q_tmp <= not q_tmp;
    end if;
  end if;  
end process;

Q <= q_tmp;

end Behavioral;

----- CELL CB16CE_HXILINX_lab4_seven_segment_display -----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CB16CE_HXILINX_lab4_seven_segment_display is
port (
    CEO : out STD_LOGIC;
    Q   : out STD_LOGIC_VECTOR(15 downto 0);
    TC  : out STD_LOGIC;
    C   : in STD_LOGIC;
    CE  : in STD_LOGIC;
    CLR : in STD_LOGIC
    );
end CB16CE_HXILINX_lab4_seven_segment_display;

architecture Behavioral of CB16CE_HXILINX_lab4_seven_segment_display is

  signal COUNT : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
  constant TERMINAL_COUNT : STD_LOGIC_VECTOR(15 downto 0) := (others => '1');
  
begin

process(C, CLR)
begin
  if (CLR='1') then
    COUNT <= (others => '0');
  elsif (C'event and C = '1') then
    if (CE='1') then 
      COUNT <= COUNT+1;
    end if;
  end if;
end process;

TC  <= '1' when (COUNT = TERMINAL_COUNT) else '0';
CEO <= '1' when ((COUNT = TERMINAL_COUNT) and CE='1') else '0';
Q   <= COUNT;

end Behavioral;

----- CELL D2_4E_HXILINX_lab4_seven_segment_display -----
  
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity D2_4E_HXILINX_lab4_seven_segment_display is
  
port(
    D0  : out std_logic;
    D1  : out std_logic;
    D2  : out std_logic;
    D3  : out std_logic;

    A0  : in std_logic;
    A1  : in std_logic;
    E   : in std_logic
  );
end D2_4E_HXILINX_lab4_seven_segment_display;

architecture D2_4E_HXILINX_lab4_seven_segment_display_V of D2_4E_HXILINX_lab4_seven_segment_display is
  signal d_tmp : std_logic_vector(3 downto 0);
begin
  process (A0, A1, E)
  variable sel   : std_logic_vector(1 downto 0);
  begin
    sel := A1&A0;
    if( E = '0') then
    d_tmp <= "0000";
    else
      case sel is
      when "00" => d_tmp <= "0001";
      when "01" => d_tmp <= "0010";
      when "10" => d_tmp <= "0100";
      when "11" => d_tmp <= "1000";
      when others => NULL;
      end case;
    end if;
  end process; 

    D3 <= d_tmp(3);
    D2 <= d_tmp(2);
    D1 <= d_tmp(1);
    D0 <= d_tmp(0);

end D2_4E_HXILINX_lab4_seven_segment_display_V;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity clocking_MUSER_lab4_seven_segment_display is
   port ( clock : in    std_logic; 
          a0    : out   std_logic; 
          a1    : out   std_logic; 
          a2    : out   std_logic; 
          a3    : out   std_logic);
end clocking_MUSER_lab4_seven_segment_display;

architecture BEHAVIORAL of clocking_MUSER_lab4_seven_segment_display is
   attribute HU_SET     : string ;
   attribute BOX_TYPE   : string ;
   signal XLXN_2  : std_logic;
   signal XLXN_3  : std_logic;
   signal XLXN_5  : std_logic;
   signal XLXN_6  : std_logic;
   signal XLXN_7  : std_logic;
   signal XLXN_8  : std_logic;
   signal XLXN_9  : std_logic;
   signal XLXN_10 : std_logic;
   signal XLXN_11 : std_logic;
   signal XLXN_13 : std_logic;
   component FTC_HXILINX_lab4_seven_segment_display
      generic( INIT : bit :=  '0');
      port ( C   : in    std_logic; 
             CLR : in    std_logic; 
             T   : in    std_logic; 
             Q   : out   std_logic);
   end component;
   
   component D2_4E_HXILINX_lab4_seven_segment_display
      port ( A0 : in    std_logic; 
             A1 : in    std_logic; 
             E  : in    std_logic; 
             D0 : out   std_logic; 
             D1 : out   std_logic; 
             D2 : out   std_logic; 
             D3 : out   std_logic);
   end component;
   
   component INV
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of INV : component is "BLACK_BOX";
   
   attribute HU_SET of XLXI_1 : label is "XLXI_1_0";
   attribute HU_SET of XLXI_2 : label is "XLXI_2_1";
   attribute HU_SET of XLXI_6 : label is "XLXI_6_2";
begin
   XLXN_2 <= '0';
   XLXN_3 <= '0';
   XLXN_7 <= '1';
   XLXN_13 <= '1';
   XLXI_1 : FTC_HXILINX_lab4_seven_segment_display
      port map (C=>clock,
                CLR=>XLXN_3,
                T=>XLXN_5,
                Q=>XLXN_6);
   
   XLXI_2 : FTC_HXILINX_lab4_seven_segment_display
      port map (C=>clock,
                CLR=>XLXN_2,
                T=>XLXN_13,
                Q=>XLXN_5);
   
   XLXI_6 : D2_4E_HXILINX_lab4_seven_segment_display
      port map (A0=>XLXN_5,
                A1=>XLXN_6,
                E=>XLXN_7,
                D0=>XLXN_11,
                D1=>XLXN_10,
                D2=>XLXN_9,
                D3=>XLXN_8);
   
   XLXI_8 : INV
      port map (I=>XLXN_8,
                O=>a3);
   
   XLXI_10 : INV
      port map (I=>XLXN_9,
                O=>a2);
   
   XLXI_11 : INV
      port map (I=>XLXN_10,
                O=>a1);
   
   XLXI_12 : INV
      port map (I=>XLXN_11,
                O=>a0);
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity four_to_seven_MUSER_lab4_seven_segment_display is
   port ( x0 : in    std_logic; 
          x1 : in    std_logic; 
          x2 : in    std_logic; 
          x3 : in    std_logic; 
          a  : out   std_logic; 
          b  : out   std_logic; 
          c  : out   std_logic; 
          d  : out   std_logic; 
          e  : out   std_logic; 
          f  : out   std_logic; 
          g  : out   std_logic);
end four_to_seven_MUSER_lab4_seven_segment_display;

architecture BEHAVIORAL of four_to_seven_MUSER_lab4_seven_segment_display is
   attribute BOX_TYPE   : string ;
   signal XLXN_1   : std_logic;
   signal XLXN_2   : std_logic;
   signal XLXN_3   : std_logic;
   signal XLXN_4   : std_logic;
   signal XLXN_22  : std_logic;
   signal XLXN_23  : std_logic;
   signal XLXN_24  : std_logic;
   signal XLXN_25  : std_logic;
   signal XLXN_83  : std_logic;
   signal XLXN_84  : std_logic;
   signal XLXN_85  : std_logic;
   signal XLXN_141 : std_logic;
   signal XLXN_143 : std_logic;
   signal XLXN_144 : std_logic;
   signal XLXN_145 : std_logic;
   signal XLXN_162 : std_logic;
   signal XLXN_163 : std_logic;
   signal XLXN_166 : std_logic;
   signal XLXN_176 : std_logic;
   signal XLXN_177 : std_logic;
   signal XLXN_178 : std_logic;
   signal XLXN_179 : std_logic;
   signal XLXN_194 : std_logic;
   signal XLXN_195 : std_logic;
   signal XLXN_196 : std_logic;
   component AND4B3
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             I3 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND4B3 : component is "BLACK_BOX";
   
   component AND4B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             I3 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND4B1 : component is "BLACK_BOX";
   
   component OR4
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             I3 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR4 : component is "BLACK_BOX";
   
   component AND3B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND3B1 : component is "BLACK_BOX";
   
   component AND3
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND3 : component is "BLACK_BOX";
   
   component AND4B2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             I3 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND4B2 : component is "BLACK_BOX";
   
   component OR3
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR3 : component is "BLACK_BOX";
   
   component AND2B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2B1 : component is "BLACK_BOX";
   
   component AND3B2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND3B2 : component is "BLACK_BOX";
   
   component AND3B3
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND3B3 : component is "BLACK_BOX";
   
begin
   XLXI_1 : AND4B3
      port map (I0=>x3,
                I1=>x2,
                I2=>x1,
                I3=>x0,
                O=>XLXN_1);
   
   XLXI_3 : AND4B1
      port map (I0=>x2,
                I1=>x3,
                I2=>x1,
                I3=>x0,
                O=>XLXN_3);
   
   XLXI_4 : AND4B1
      port map (I0=>x2,
                I1=>x3,
                I2=>x1,
                I3=>x0,
                O=>XLXN_4);
   
   XLXI_5 : OR4
      port map (I0=>XLXN_4,
                I1=>XLXN_3,
                I2=>XLXN_2,
                I3=>XLXN_1,
                O=>a);
   
   XLXI_6 : AND4B3
      port map (I0=>x0,
                I1=>x1,
                I2=>x3,
                I3=>x2,
                O=>XLXN_2);
   
   XLXI_7 : AND3B1
      port map (I0=>x0,
                I1=>x2,
                I2=>x1,
                O=>XLXN_23);
   
   XLXI_8 : AND3
      port map (I0=>x0,
                I1=>x1,
                I2=>x3,
                O=>XLXN_22);
   
   XLXI_9 : AND4B2
      port map (I0=>x0,
                I1=>x1,
                I2=>x3,
                I3=>x2,
                O=>XLXN_24);
   
   XLXI_10 : AND4B2
      port map (I0=>x1,
                I1=>x3,
                I2=>x2,
                I3=>x0,
                O=>XLXN_25);
   
   XLXI_11 : OR4
      port map (I0=>XLXN_25,
                I1=>XLXN_24,
                I2=>XLXN_22,
                I3=>XLXN_23,
                O=>b);
   
   XLXI_22 : AND4B3
      port map (I0=>x0,
                I1=>x2,
                I2=>x3,
                I3=>x1,
                O=>XLXN_83);
   
   XLXI_25 : OR3
      port map (I0=>XLXN_85,
                I1=>XLXN_84,
                I2=>XLXN_83,
                O=>c);
   
   XLXI_27 : AND3
      port map (I0=>x1,
                I1=>x2,
                I2=>x3,
                O=>XLXN_84);
   
   XLXI_28 : AND3B1
      port map (I0=>x0,
                I1=>x2,
                I2=>x3,
                O=>XLXN_85);
   
   XLXI_29 : AND4B3
      port map (I0=>x3,
                I1=>x2,
                I2=>x1,
                I3=>x0,
                O=>XLXN_141);
   
   XLXI_30 : AND4B3
      port map (I0=>x0,
                I1=>x1,
                I2=>x3,
                I3=>x2,
                O=>XLXN_143);
   
   XLXI_31 : AND4B2
      port map (I0=>x2,
                I1=>x0,
                I2=>x1,
                I3=>x3,
                O=>XLXN_144);
   
   XLXI_32 : AND3
      port map (I0=>x0,
                I1=>x1,
                I2=>x2,
                O=>XLXN_145);
   
   XLXI_33 : OR4
      port map (I0=>XLXN_145,
                I1=>XLXN_144,
                I2=>XLXN_143,
                I3=>XLXN_141,
                O=>d);
   
   XLXI_34 : AND2B1
      port map (I0=>x3,
                I1=>x0,
                O=>XLXN_162);
   
   XLXI_35 : AND3B2
      port map (I0=>x1,
                I1=>x3,
                I2=>x2,
                O=>XLXN_163);
   
   XLXI_36 : AND3B2
      port map (I0=>x1,
                I1=>x2,
                I2=>x0,
                O=>XLXN_166);
   
   XLXI_37 : OR3
      port map (I0=>XLXN_166,
                I1=>XLXN_163,
                I2=>XLXN_162,
                O=>e);
   
   XLXI_38 : AND3B2
      port map (I0=>x2,
                I1=>x3,
                I2=>x0,
                O=>XLXN_179);
   
   XLXI_39 : AND3B2
      port map (I0=>x2,
                I1=>x3,
                I2=>x1,
                O=>XLXN_176);
   
   XLXI_40 : AND3B1
      port map (I0=>x3,
                I1=>x1,
                I2=>x0,
                O=>XLXN_177);
   
   XLXI_41 : AND4B1
      port map (I0=>x1,
                I1=>x3,
                I2=>x2,
                I3=>x0,
                O=>XLXN_178);
   
   XLXI_42 : OR4
      port map (I0=>XLXN_178,
                I1=>XLXN_177,
                I2=>XLXN_176,
                I3=>XLXN_179,
                O=>f);
   
   XLXI_43 : AND3B3
      port map (I0=>x1,
                I1=>x2,
                I2=>x3,
                O=>XLXN_194);
   
   XLXI_46 : AND4B2
      port map (I0=>x0,
                I1=>x1,
                I2=>x3,
                I3=>x2,
                O=>XLXN_195);
   
   XLXI_47 : AND4B1
      port map (I0=>x3,
                I1=>x0,
                I2=>x1,
                I3=>x2,
                O=>XLXN_196);
   
   XLXI_48 : OR3
      port map (I0=>XLXN_196,
                I1=>XLXN_195,
                I2=>XLXN_194,
                O=>g);
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity multiplexer_16_MUSER_lab4_seven_segment_display is
   port ( a0 : in    std_logic; 
          a1 : in    std_logic; 
          a2 : in    std_logic; 
          a3 : in    std_logic; 
          x0 : in    std_logic; 
          x1 : in    std_logic; 
          x2 : in    std_logic; 
          x3 : in    std_logic; 
          o  : out   std_logic);
end multiplexer_16_MUSER_lab4_seven_segment_display;

architecture BEHAVIORAL of multiplexer_16_MUSER_lab4_seven_segment_display is
   attribute BOX_TYPE   : string ;
   signal XLXN_11 : std_logic;
   signal XLXN_12 : std_logic;
   signal XLXN_13 : std_logic;
   signal XLXN_14 : std_logic;
   signal XLXN_18 : std_logic;
   signal XLXN_19 : std_logic;
   signal XLXN_20 : std_logic;
   signal XLXN_21 : std_logic;
   component INV
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of INV : component is "BLACK_BOX";
   
   component AND2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2 : component is "BLACK_BOX";
   
   component OR4
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             I3 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR4 : component is "BLACK_BOX";
   
begin
   XLXI_9 : INV
      port map (I=>a0,
                O=>XLXN_11);
   
   XLXI_10 : INV
      port map (I=>a1,
                O=>XLXN_12);
   
   XLXI_11 : INV
      port map (I=>a2,
                O=>XLXN_13);
   
   XLXI_12 : INV
      port map (I=>a3,
                O=>XLXN_14);
   
   XLXI_13 : AND2
      port map (I0=>XLXN_11,
                I1=>x0,
                O=>XLXN_18);
   
   XLXI_14 : AND2
      port map (I0=>XLXN_12,
                I1=>x1,
                O=>XLXN_19);
   
   XLXI_15 : AND2
      port map (I0=>XLXN_13,
                I1=>x2,
                O=>XLXN_20);
   
   XLXI_16 : AND2
      port map (I0=>XLXN_14,
                I1=>x3,
                O=>XLXN_21);
   
   XLXI_17 : OR4
      port map (I0=>XLXN_21,
                I1=>XLXN_20,
                I2=>XLXN_19,
                I3=>XLXN_18,
                O=>o);
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity lab4_seven_segment_display is
   port ( b          : in    std_logic_vector (15 downto 0); 
          clk        : in    std_logic; 
          pushbutton : in    std_logic; 
          anode      : out   std_logic_vector (3 downto 0); 
          cathode    : out   std_logic_vector (6 downto 0));
end lab4_seven_segment_display;

architecture BEHAVIORAL of lab4_seven_segment_display is
   attribute BOX_TYPE   : string ;
   attribute HU_SET     : string ;
   signal XLXN_43     : std_logic;
   signal XLXN_44     : std_logic;
   signal XLXN_45     : std_logic;
   signal XLXN_47     : std_logic;
   signal XLXN_56     : std_logic;
   signal XLXN_57     : std_logic;
   signal XLXN_58     : std_logic_vector (15 downto 0);
   signal XLXN_61     : std_logic;
   signal XLXN_62     : std_logic;
   signal XLXN_63     : std_logic;
   signal XLXN_67     : std_logic;
   signal anode_DUMMY : std_logic_vector (3 downto 0);
   component multiplexer_16_MUSER_lab4_seven_segment_display
      port ( a0 : in    std_logic; 
             a1 : in    std_logic; 
             a2 : in    std_logic; 
             a3 : in    std_logic; 
             o  : out   std_logic; 
             x0 : in    std_logic; 
             x1 : in    std_logic; 
             x2 : in    std_logic; 
             x3 : in    std_logic);
   end component;
   
   component four_to_seven_MUSER_lab4_seven_segment_display
      port ( a  : out   std_logic; 
             b  : out   std_logic; 
             c  : out   std_logic; 
             d  : out   std_logic; 
             e  : out   std_logic; 
             f  : out   std_logic; 
             g  : out   std_logic; 
             x0 : in    std_logic; 
             x1 : in    std_logic; 
             x2 : in    std_logic; 
             x3 : in    std_logic);
   end component;
   
   component AND2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2 : component is "BLACK_BOX";
   
   component CB16CE_HXILINX_lab4_seven_segment_display
      port ( C   : in    std_logic; 
             CE  : in    std_logic; 
             CLR : in    std_logic; 
             CEO : out   std_logic; 
             Q   : out   std_logic_vector (15 downto 0); 
             TC  : out   std_logic);
   end component;
   
   component OR2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR2 : component is "BLACK_BOX";
   
   component clocking_MUSER_lab4_seven_segment_display
      port ( a0    : out   std_logic; 
             a1    : out   std_logic; 
             a2    : out   std_logic; 
             a3    : out   std_logic; 
             clock : in    std_logic);
   end component;
   
   component INV
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of INV : component is "BLACK_BOX";
   
   attribute HU_SET of XLXI_22 : label is "XLXI_22_3";
begin
   XLXN_56 <= '0';
   XLXN_57 <= '1';
   anode(3 downto 0) <= anode_DUMMY(3 downto 0);
   XLXI_1 : multiplexer_16_MUSER_lab4_seven_segment_display
      port map (a0=>anode_DUMMY(0),
                a1=>anode_DUMMY(1),
                a2=>anode_DUMMY(2),
                a3=>anode_DUMMY(3),
                x0=>b(0),
                x1=>b(4),
                x2=>b(8),
                x3=>b(12),
                o=>XLXN_43);
   
   XLXI_4 : multiplexer_16_MUSER_lab4_seven_segment_display
      port map (a0=>anode_DUMMY(0),
                a1=>anode_DUMMY(1),
                a2=>anode_DUMMY(2),
                a3=>anode_DUMMY(3),
                x0=>b(1),
                x1=>b(5),
                x2=>b(9),
                x3=>b(13),
                o=>XLXN_44);
   
   XLXI_5 : multiplexer_16_MUSER_lab4_seven_segment_display
      port map (a0=>anode_DUMMY(0),
                a1=>anode_DUMMY(1),
                a2=>anode_DUMMY(2),
                a3=>anode_DUMMY(3),
                x0=>b(2),
                x1=>b(6),
                x2=>b(10),
                x3=>b(14),
                o=>XLXN_45);
   
   XLXI_6 : multiplexer_16_MUSER_lab4_seven_segment_display
      port map (a0=>anode_DUMMY(0),
                a1=>anode_DUMMY(1),
                a2=>anode_DUMMY(2),
                a3=>anode_DUMMY(3),
                x0=>b(3),
                x1=>b(7),
                x2=>b(11),
                x3=>b(15),
                o=>XLXN_47);
   
   XLXI_8 : four_to_seven_MUSER_lab4_seven_segment_display
      port map (x0=>XLXN_43,
                x1=>XLXN_44,
                x2=>XLXN_45,
                x3=>XLXN_47,
                a=>cathode(0),
                b=>cathode(1),
                c=>cathode(2),
                d=>cathode(3),
                e=>cathode(4),
                f=>cathode(5),
                g=>cathode(6));
   
   XLXI_9 : AND2
      port map (I0=>clk,
                I1=>pushbutton,
                O=>XLXN_61);
   
   XLXI_10 : AND2
      port map (I0=>XLXN_58(15),
                I1=>XLXN_67,
                O=>XLXN_62);
   
   XLXI_22 : CB16CE_HXILINX_lab4_seven_segment_display
      port map (C=>clk,
                CE=>XLXN_57,
                CLR=>XLXN_56,
                CEO=>open,
                Q(15 downto 0)=>XLXN_58(15 downto 0),
                TC=>open);
   
   XLXI_25 : OR2
      port map (I0=>XLXN_62,
                I1=>XLXN_61,
                O=>XLXN_63);
   
   XLXI_26 : clocking_MUSER_lab4_seven_segment_display
      port map (clock=>XLXN_63,
                a0=>anode_DUMMY(0),
                a1=>anode_DUMMY(1),
                a2=>anode_DUMMY(2),
                a3=>anode_DUMMY(3));
   
   XLXI_30 : INV
      port map (I=>pushbutton,
                O=>XLXN_67);
   
end BEHAVIORAL;

------------------
------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;


entity lab7_divider is
    port(
        divisor: in std_logic_vector(7 downto 0);
        dividend: in std_logic_vector(7 downto 0);
        output_valid: out std_logic;
        input_invalid: out std_logic;
        load_inputs: in std_logic;
        anode: out std_logic_vector(3 downto 0);
        cathode:out std_logic_vector(6 downto 0);
        clk: in std_logic;
        sim_mode: in std_logic
    );
end lab7_divider;

architecture Behavioral of lab7_divider is
signal show: std_logic_vector(15 downto 0):="0000000000000000";
signal q: std_logic_vector(7 downto 0):="00000000";
signal r: std_logic_vector(7 downto 0):="00000000";
begin
    show<= q & r;
    Seven_segment:
        ENTITY WORK.lab4_seven_segment_display(BEHAVIORAL)
        PORT MAP(
            b => show,
            clk => clk,
            pushbutton =>sim_mode,
            anode=> anode,
            cathode=>cathode);
   Dividing:
        ENTITY WORK.division(behavioural)
           PORT MAP(
               divisor => divisor,
               dividend => dividend,
               quotient =>q,
               remainder=> r,
               load_inputs=>load_inputs,
               input_invalid=> input_invalid,
               output_valid=> output_valid);

end Behavioral;
