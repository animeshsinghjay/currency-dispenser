library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;


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

entity carry_propagate_adder is
    port(
        a1: in STD_LOGIC_VECTOR(7 downto 0);
        a2: in STD_LOGIC_VECTOR(7 downto 0);
        b: out STD_LOGIC_VECTOR(7 downto 0);
        cout: out STD_LOGIC
    );
end carry_propagate_adder;

ARCHITECTURE behavioural of carry_propagate_adder is
	signal carry: STD_LOGIC_VECTOR(7 downto 0);
	signal first_carry: STD_LOGIC;
	BEGIN
	first_carry<='0';
	first: ENTITY WORK.adder(behavioural)
		PORT MAP(
			a=>a1(0),
			b=>a2(0),
			cin=>first_carry,
			cout=>carry(0),
			s=>b(0));
	ADD1TO7: for i in 1 to 7 generate
		ADDi: ENTITY WORK.adder(behavioural)
			PORT MAP(
				a=>a1(i),
				b=>a2(i),
				cin=>carry(i-1),
				cout=>carry(i),
				s=>b(i)
				);
	end generate;
	cout <= carry(7);
end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity multiplier1 is
    port(
        in1: in STD_LOGIC_VECTOR(7 downto 0);
        in2: in STD_LOGIC_VECTOR(7 downto 0);
        b: out STD_LOGIC_VECTOR(15 downto 0)
    );
end multiplier1;

ARCHITECTURE behavioural of multiplier1 is
	signal p: STD_LOGIC_VECTOR(63 downto 0);
	signal sum: STD_LOGIC_VECTOR(55 downto 0);
	signal pshift: STD_LOGIC_VECTOR(55 downto 0);
	signal carry: STD_LOGIC_VECTOR(6 downto 0);
	signal temp1: STD_LOGIC_VECTOR(7 downto 0);
	BEGIN
	
	A0to7: for i in 0 to 7 generate
	   B0to7: for j in 0 to 7 generate
	      p(i + j*8) <= in1(i) and in2(j);
	   end generate;
    end generate;
    pshift(7 downto 0) <= '0'& p(7 downto 1);
        first: ENTITY WORK.carry_propagate_adder(behavioural)
            PORT MAP(
                a1=>pshift(7 downto 0),
                a2=>p(15 downto 8),
                b=>sum(7 downto 0),
                cout=>carry(0)
                );
        ADD1TO7: for i in 1 to 6 generate
            pshift(8*i+7 downto 8*i)<=carry(i-1) & sum(8*(i-1)+7 downto 8*(i-1)+1);
            ADDi: ENTITY WORK.carry_propagate_adder(behavioural)
                PORT MAP(
                            a1=>pshift(8*i+7 downto 8*i),
                            a2=>p(8*(i+1)+7 downto 8*(i+1)),
                            b=>sum(8*(i)+7 downto 8*(i)),
                            cout=>carry(i)
                         );
        end generate;
    b(0)<=p(0);
    b(1)<=sum(0);
    b(2)<=sum(8);
    b(3)<=sum(16);              
    b(4)<=sum(24);
    b(5)<=sum(32);
    b(6)<=sum(40);
    b(14 downto 7) <= sum(55 downto 48);
    b(15) <= carry(6); 
end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity carry_save_adder is
    port(
        a1: in STD_LOGIC_VECTOR(7 downto 0);
        a2: in STD_LOGIC_VECTOR(7 downto 0);
        a3: in STD_LOGIC_VECTOR(6 downto 0);
        b: out STD_LOGIC_VECTOR(7 downto 0);
        carry: out STD_LOGIC_VECTOR(7 downto 0)
    );
end carry_save_adder;

ARCHITECTURE behavioural of carry_save_adder is
	signal first_carry: STD_LOGIC;
	BEGIN
	first_carry<='0';
	first: ENTITY WORK.adder(behavioural)
		PORT MAP(
			a=>a1(0),
			b=>a2(0),
			cin=>first_carry,
			cout=>carry(0),
			s=>b(0));
	ADD1TO7: for i in 1 to 7 generate
		ADDi: ENTITY WORK.adder(behavioural)
			PORT MAP(
				a=>a1(i),
				b=>a2(i),
				cin=>a3(i-1),
				cout=>carry(i),
				s=>b(i)
				);
	end generate;
end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity multiplier2 is
    port(
        in1: in STD_LOGIC_VECTOR(7 downto 0);
        in2: in STD_LOGIC_VECTOR(7 downto 0);
        b: out STD_LOGIC_VECTOR(15 downto 0)
    );
end multiplier2;

ARCHITECTURE behavioural of multiplier2 is
	signal p: STD_LOGIC_VECTOR(63 downto 0);
	signal sum: STD_LOGIC_VECTOR(55 downto 0);
	signal csignal: STD_LOGIC_VECTOR(55 downto 0);
	signal pshift: STD_LOGIC_VECTOR(55 downto 0);
	signal last_carry: STD_LOGIC; 
	BEGIN
	
	A0to7: for i in 0 to 7 generate
	   B0to7: for j in 0 to 7 generate
	      p(i + j*8) <= in1(i) and in2(j);
	   end generate;
    end generate;
    
    pshift(7 downto 0) <= '0'& p(7 downto 1);
    
    first: ENTITY WORK.carry_save_adder(behavioural)
        PORT MAP(
            a1=>pshift(7 downto 0),
            a2=>p(15 downto 8),
            a3=>p(22 downto 16),
            b=>sum(7 downto 0),
            carry=>csignal(7 downto 0)
            );
            
    ADD1TO7: for i in 1 to 5 generate
        pshift(8*i+7 downto 8*i)<=p(8*(i+1)+7) & sum(8*(i-1)+7 downto 8*(i-1)+1);
        ADDi: ENTITY WORK.carry_save_adder(behavioural)
            PORT MAP(
                        a1=>pshift(8*i+7 downto 8*i),
                        a2=>csignal(8*i-1 downto 8*(i-1)),
                        a3=>p(8*(i+2)+6 downto 8*(i+2)),
                        b=>sum(8*(i)+7 downto 8*(i)),
                        carry=>csignal(8*(i)+7 downto 8*(i))
                     );
    end generate;
    pshift(55 downto 48) <= p(63) & sum(47 downto 41);
    last: ENTITY WORK.carry_propagate_adder(behavioural)
        PORT MAP(
            a1=>pshift(55 downto 48),
            a2=>csignal(47 downto 40),
            b=>sum(55 downto 48),
            cout=>last_carry
            );
            
    b(0)<=p(0);
    b(1)<=sum(0);
    b(2)<=sum(8);
    b(3)<=sum(16);              
    b(4)<=sum(24);
    b(5)<=sum(32);
    b(6)<=sum(40);
    b(14 downto 7) <= sum(55 downto 48);
    b(15) <= last_carry; 
end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity cla is
    port(
        c0,a0,b0,a1,b1,a2,b2,a3,b3: in STD_LOGIC;
        c4,s0,s1,s2,s3: out STD_LOGIC
    );
end cla;

ARCHITECTURE behavioural of cla is
signal p0,g0,p1,g1,p2,g2,p3,g3,c1,c2,c3: STD_LOGIC;
begin
    p0<= a0 or b0;
    p1<= a1 or b1;
    p2<= a2 or b2;
    p3<= a3 or b3;
    g0<= a0 and b0;
    g1<= a1 and b1;
    g2<= a2 and b2;
    g3<= a3 and b3;
    c1 <= (p0 and c0) or g0;
    c2 <= (p1 and p0 and c0) or (p1 and g0) or g1;
    c3 <= (p2 and p1 and p0 and c0) or (p2 and p1 and g0) or (p2 and g1) or g2;
    c4 <= (p3 and p2 and p1 and p0 and c0) or (p3 and p2 and p1 and g0) or (p3 and p2 and g1) or (p3 and g2) or g3;
    s0 <= (a0 XOR b0) XOR c0;
    s1 <= (a1 XOR b1) XOR c1;
    s2 <= (a2 XOR b2) XOR c2;
    s3 <= (a3 XOR b3) XOR c3;
end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity multiplier3 is
    port(
        in1: in STD_LOGIC_VECTOR(7 downto 0);
        in2: in STD_LOGIC_VECTOR(7 downto 0);
        b: out STD_LOGIC_VECTOR(15 downto 0)
    );
end multiplier3;

ARCHITECTURE behavioural of multiplier3 is
	signal p: STD_LOGIC_VECTOR(63 downto 0);
	signal sum: STD_LOGIC_VECTOR(55 downto 0);
	signal csignal: STD_LOGIC_VECTOR(55 downto 0);
	signal pshift: STD_LOGIC_VECTOR(55 downto 0);
	signal zero: STD_LOGIC;
	signal prop: STD_LOGIC;
	signal cout: STD_LOGIC;
	BEGIN
	zero<='0';
	A0to7: for i in 0 to 7 generate
	   B0to7: for j in 0 to 7 generate
	      p(i + j*8) <= in1(i) and in2(j);
	   end generate;
    end generate;
    
    pshift(7 downto 0) <= '0'& p(7 downto 1);
    
    first: ENTITY WORK.carry_save_adder(behavioural)
        PORT MAP(
            a1=>pshift(7 downto 0),
            a2=>p(15 downto 8),
            a3=>p(22 downto 16),
            b=>sum(7 downto 0),
            carry=>csignal(7 downto 0)
            );
            
    ADD1TO7: for i in 1 to 5 generate
        pshift(8*i+7 downto 8*i)<=p(8*(i+1)+7) & sum(8*(i-1)+7 downto 8*(i-1)+1);
        ADDi: ENTITY WORK.carry_save_adder(behavioural)
            PORT MAP(
                        a1=>pshift(8*i+7 downto 8*i),
                        a2=>csignal(8*i-1 downto 8*(i-1)),
                        a3=>p(8*(i+2)+6 downto 8*(i+2)),
                        b=>sum(8*(i)+7 downto 8*(i)),
                        carry=>csignal(8*(i)+7 downto 8*(i))
                     );
    end generate;
    pshift(55 downto 48) <= p(63) & sum(47 downto 41);
    last2: ENTITY WORK.cla(behavioural)
            PORT MAP(
                
                a3=>pshift(51),
                a2=>pshift(50),
                a1=>pshift(49),
                a0=>pshift(48),
                b3=>csignal(43),
                b2=>csignal(42),
                b1=>csignal(41),
                b0=>csignal(40),
                c0=>zero,
                s0=>sum(48),
                s1=>sum(49),
                s2=>sum(50),
                s3=>sum(51),
                c4 =>prop
                );

    last1: ENTITY WORK.cla(behavioural)
        PORT MAP(
            a3=>pshift(55),
            a2=>pshift(54),
            a1=>pshift(53),
            a0=>pshift(52),
            b3=>csignal(47),
            b2=>csignal(46),
            b1=>csignal(45),
            b0=>csignal(44),
            c0=>prop,
            s0=>sum(52),
            s1=>sum(53),
            s2=>sum(54),
            s3=>sum(55),
            c4 =>cout
         );
    b(0)<=p(0);
    b(1)<=sum(0);
    b(2)<=sum(8);
    b(3)<=sum(16);              
    b(4)<=sum(24);
    b(5)<=sum(32);
    b(6)<=sum(40);
    b(14 downto 7) <= sum(55 downto 48);
    b(15) <= cout; 
end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

ENTITY mux IS
	PORT(	
        m1 : in STD_LOGIC_VECTOR(15 downto 0);
        m2 : in STD_LOGIC_VECTOR(15 downto 0);
        m3 : in STD_LOGIC_VECTOR(15 downto 0);
        s : in STD_LOGIC_VECTOR(1 downto 0);
        o : out STD_LOGIC_VECTOR(15 downto 0)
		);
END mux;

ARCHITECTURE behavioural OF mux IS
BEGIN
	PROCESS(s,m1,m2,m3)
	BEGIN
	if s="00" then o <=m1;
	elsif s="01" then o <=m2;
	else o <=m3;
	end if;
	END PROCESS;
END behavioural;



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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

ENTITY lab6_multiplier IS
	PORT(	
        clk : in STD_LOGIC;
        in1 : in STD_LOGIC_VECTOR(7 downto 0);
        in2 : in STD_LOGIC_VECTOR(7 downto 0);
        display_button : in STD_LOGIC;
        multiplier_select : in STD_LOGIC_VECTOR(1 downto 0);
        anode: out STD_LOGIC_VECTOR(3 downto 0);
        cathode: out STD_LOGIC_VECTOR(6 downto 0);
        product: out STD_LOGIC_VECTOR(15 downto 0)
		);
END lab6_multiplier;

ARCHITECTURE behavioural OF lab6_multiplier IS
signal selected: STD_LOGIC_VECTOR(15 downto 0);
signal selected1: STD_LOGIC_VECTOR(15 downto 0);
signal selected2: STD_LOGIC_VECTOR(15 downto 0);
signal selected3: STD_LOGIC_VECTOR(15 downto 0);
BEGIN
    product<=selected;
	Seven_segment:
			ENTITY WORK.lab4_seven_segment_display(BEHAVIORAL)
			PORT MAP(
				b => selected,
				clk => clk,
				pushbutton =>display_button,
				anode=> anode,
				cathode=>cathode);
    MUX1:
        ENTITY WORK.mux(BEHAVIOURAL)
            PORT MAP(m1=>selected1,
                    m2=>selected2,
                    m3=>selected3,
                    s=> multiplier_select,
                    o=>selected
            );
    Multiplier1:
        ENTITY WORK.multiplier1(BEHAVIOURAL)
                PORT MAP(in1=>in1,
                in2=>in2,
                b=>selected1
                );
     Multiplier2:
           ENTITY WORK.multiplier2(BEHAVIOURAL)
                   PORT MAP(in1=>in1,
                   in2=>in2,
                   b=>selected2
                   );
       Multiplier3:
            ENTITY WORK.multiplier3(BEHAVIOURAL)
                  PORT MAP(in1=>in1,
                  in2=>in2,
                  b=>selected3
                  );
END behavioural;

