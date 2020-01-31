library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.Vcomponents.all;

entity mini_project is
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
end mini_project;

architecture Behavioral of mini_project is
    signal notes_1: integer:= 99;
    signal notes_5: integer:=50;
    signal notes_10: integer:=99;
    signal notes_100: integer:=99;
    signal flag: std_logic := '0';
    --give ranges to integers to increase efficiency
    signal money_asked: integer := 0;
    signal error_signal : std_logic;
--    signal cur_1: integer:=0;
--    signal cur_5: integer:=0;
--    signal cur_10: integer:=0;
--    signal cur_100: integer:=0;
begin
    err <= error_signal;
    process(clk)
    variable cur_100: integer :=0;
    variable cur_10: integer :=0;
    variable cur_5: integer :=0;
    variable cur_1: integer :=0;
    variable highest:integer :=0;
    
    begin
    if (reset='1') then
        notes_1<= 99;
        notes_5 <= 50;
        notes_10 <= 99;
        notes_100 <= 99;
        flag<='0';
        error_signal<='0';
        show_type<="00";
        show_number<="10011001";
    elsif (clk='1' and clk'EVENT) then
        if (mode="00") then
            if (type_currency="00") then
                show_number(3 downto 0) <= std_logic_vector(to_unsigned(notes_1 mod 10,4));
                show_number(7 downto 4) <= std_logic_vector(to_unsigned((notes_1-(notes_1 mod 10))/10,4));
                show_type<="00";
            elsif (type_currency="01") then
                show_number(3 downto 0) <= std_logic_vector(to_unsigned(notes_5 mod 10,4));
                show_number(7 downto 4) <= std_logic_vector(to_unsigned((notes_5-(notes_5 mod 10))/10,4));
                show_type<="01";
            elsif (type_currency="10") then
                show_number(3 downto 0) <= std_logic_vector(to_unsigned(notes_10 mod 10,4));
                show_number(7 downto 4) <= std_logic_vector(to_unsigned((notes_10-(notes_10 mod 10))/10,4));
                show_type <= "10";
            elsif (type_currency="11") then
                show_number(3 downto 0) <= std_logic_vector(to_unsigned(notes_100 mod 10,4));
                show_number(7 downto 4) <= std_logic_vector(to_unsigned((notes_100-(notes_100 mod 10))/10,4));
                show_type <= "11";
            end if;
            --display mode
        elsif(mode="01" and error_signal='0') then
            money_asked <= to_integer(unsigned(specify_currency(11 downto 8)))*100 + to_integer(unsigned(specify_currency(7 downto 4)))*10 + to_integer(unsigned(specify_currency(3 downto 0)));
            if (confirm='1' AND flag='0' AND (((money_asked/100)>notes_100) or ((money_asked mod 100)/10 > notes_10) or (((money_asked mod 100)mod 10)/5 > notes_5) or ((((money_asked mod 100)mod 10)mod 5) > notes_1))) then
                highest := money_asked;
                if (highest/100 > notes_100) then
                    highest := highest - notes_100 * 100; 
                    notes_100 <= 0;
                else
                    notes_100 <= notes_100 - (highest/100);
                    highest := highest - ((highest/100) * 100);
                end if;
                if (highest/10 > notes_10) then
                    highest := highest - notes_10 * 10;
                    notes_10 <= 0;
                else
                    notes_10 <= notes_10 - (highest/10);
                    highest := highest - ((highest/10) * 10);
                end if;
                if (highest/5 > notes_5) then
                    highest := highest - notes_5 *5;
                    notes_5 <= 0;
                else
                    notes_5 <= notes_5 - (highest/5);
                    highest := highest - ((highest/5) * 5);
                end if;
                if (highest/1 > notes_1) then
                    highest := highest - notes_1 * 1;
                    notes_1 <= 0;
                else
                    notes_1 <= notes_1 - (highest/1);
                    highest := highest - ((highest/1) * 1);
                end if;
                if (highest>0) then 
                    notes_100<=notes_100;
                    notes_10<=notes_10;
                    notes_5<=notes_5;
                    notes_1<=notes_1;
                    error_signal<='1';
                else
                    error_signal<='0';
                end if;
                flag<='1';
                               
            elsif (confirm='1' and flag='0') then
                notes_100 <= notes_100 - (money_asked/100);
                notes_10 <= notes_10 - ((money_asked mod 100)/10);
                notes_5 <= notes_5 - ((money_asked mod 100)mod 10)/5;
                notes_1 <= notes_1 - (((money_asked mod 100)mod 10)mod 5);
                flag<='1';
            end if;
            --auto mode
        elsif(mode="10" and error_signal='0') then
             money_asked <= to_integer(unsigned(specify_currency(11 downto 8)))*100 + to_integer(unsigned(specify_currency(7 downto 4)))*10 + to_integer(unsigned(specify_currency(3 downto 0)));
                   if (confirm='1' AND flag='0' AND (((money_asked/100)>notes_100) or ((money_asked mod 100)/10 > notes_10) or (((money_asked mod 100)mod 10)/5 > notes_5) or ((((money_asked mod 100)mod 10)mod 5) > notes_1))) then
                       error_signal<='1';
                       flag<='1';             
                   elsif (confirm='1' and flag='0') then
                       notes_100 <= notes_100 - (money_asked/100);
                       notes_10 <= notes_10 - ((money_asked mod 100)/10);
                       notes_5 <= notes_5 - ((money_asked mod 100)mod 10)/5;
                       notes_1 <= notes_1 - (((money_asked mod 100)mod 10)mod 5);
                       flag<='1';
                   end if;
            --highest denomination mode
        elsif(mode="11" and error_signal='0') then
            if (confirm='1' and type_currency="00" and flag='0') then
                if ((to_integer(unsigned(specify_currency(11 downto 8)))*10 + to_integer(unsigned(specify_currency(7 downto 4)))) > notes_1) then
                    error_signal<='1';
                else
                    notes_1 <= notes_1 - (to_integer(unsigned(specify_currency(11 downto 8)))*10 + to_integer(unsigned(specify_currency(7 downto 4))));
                end if;
                flag<='1';
            elsif (confirm='1' and type_currency="01" and flag='0') then
                if ((to_integer(unsigned(specify_currency(11 downto 8)))*10 + to_integer(unsigned(specify_currency(7 downto 4)))) > notes_5) then
                    error_signal<='1';
                else
                    notes_5 <= notes_5 - (to_integer(unsigned(specify_currency(11 downto 8)))*10 + to_integer(unsigned(specify_currency(7 downto 4))));              
                end if;
                flag<='1';
            elsif (confirm='1' and type_currency="10" and flag='0') then
                if ((to_integer(unsigned(specify_currency(11 downto 8)))*10 + to_integer(unsigned(specify_currency(7 downto 4)))) > notes_10) then
                    error_signal<='1';
                else
                    notes_10 <= notes_10 - (to_integer(unsigned(specify_currency(11 downto 8)))*10 + to_integer(unsigned(specify_currency(7 downto 4))));
                end if;
                flag<='1';
            elsif (confirm='1' and type_currency="11" and flag='0') then
                if ((to_integer(unsigned(specify_currency(11 downto 8)))*10 + to_integer(unsigned(specify_currency(7 downto 4)))) > notes_100) then
                    error_signal<='1';
                else
                    notes_100 <= notes_100 - (to_integer(unsigned(specify_currency(11 downto 8)))*10 + to_integer(unsigned(specify_currency(7 downto 4))));
                end if;
                flag<='1';
            end if;
            --specify mode
        end if;
        if (confirm='0' and flag='1') then flag<='0';
        end if;
        if (back='1') then error_signal<='0';
        end if;
    end if;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
ENTITY status_display_block IS
PORT (
        show_type: IN std_logic_vector(1 downto 0);
        show_number: IN std_logic_vector(7 downto 0); -- bcd representation of number
        cathode: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0);
        clk: IN STD_LOGIC
     );
END ENTITY status_display_block;

architecture behavioral of status_display_block is

    signal refresh_counter: STD_LOGIC_VECTOR (20 downto 0):="000000000000000000000"; 
    signal LED_activating_counter: std_logic_vector(1 downto 0);
    signal is_number: std_logic; -- 1 for floor
    signal LED_SHOW_TYPE: STD_LOGIC_VECTOR (1 downto 0);
    signal LED_SHOW_NUMBER: STD_LOGIC_VECTOR (3 downto 0); 
    signal first: STD_LOGIC;
begin
    process(LED_SHOW_TYPE,LED_SHOW_NUMBER,is_number,first)
    begin
        if (is_number='1') then
            case LED_SHOW_NUMBER is
                when "0000" => cathode <= "0000001"; -- "0"     
                when "0001" => cathode <= "1001111"; -- "1" 
                when "0010" => cathode <= "0010010"; -- "2" 
                when "0011" => cathode <= "0000110"; -- "3" 
                when "0100" => cathode <= "1001100"; -- "4" 
                when "0101" => cathode <= "0100100"; -- "5" 
                when "0110" => cathode <= "0100000"; -- "6" 
                when "0111" => cathode <= "0001111"; -- "7" 
                when "1000" => cathode <= "0000000"; -- "8"     
                when "1001" => cathode <= "0000100"; -- "9" 
                when others => cathode <= "1111111";
                end case;
        else
            if (first='1') then
                case LED_SHOW_TYPE is
                    when "00" => cathode <= "0000001"; -- "o"     
                    when "01" => cathode <= "0111000"; -- "f" 
                    when "10" => cathode <= "1110000"; -- "t" 
                    when "11" => cathode <= "1101000"; -- "h" 
                    when others => cathode <= "1111111";
                    end case;
            else
                case LED_SHOW_TYPE is
                    when "00" => cathode <= "1101010"; -- "n"     
                    when "01" => cathode <= "1001111"; -- "i" 
                    when "10" => cathode <= "0010000"; -- "e" 
                    when "11" => cathode <= "1000001"; -- "u" 
                    when others => cathode <= "1111111";
                    end case;
            end if;
        end if;
    end process;

    process(clk)
    begin 
        if(clk'EVENT and clk='1') then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    LED_activating_counter <= refresh_counter(20 downto 19);

    process(LED_activating_counter)
    begin
        case LED_activating_counter is
        when "00" =>
            anode <= "0111"; 
            -- activate LED1 and Deactivate LED2, LED3, LED4
            LED_SHOW_TYPE <= show_type;
            first<='1';
            is_number <= '0';
            -- the first hex digit of the 16-bit number
        when "01" =>
            anode <= "1011"; 
            -- activate LED2 and Deactivate LED1, LED3, LED4
            LED_SHOW_TYPE <= show_type;
            first<='0';
            is_number <= '0';
            -- the second hex digit of the 16-bit number
        when "10" =>
            anode <= "1101"; 
            -- activate LED3 and Deactivate LED2, LED1, LED4
            LED_SHOW_NUMBER <= show_number(7 downto 4);
            is_number <= '1';
            -- the third hex digit of the 16-bit number
        when "11" =>
            anode <= "1110"; 
            is_number <= '1';
            -- activate LED4 and Deactivate LED2, LED3, LED1
            LED_SHOW_NUMBER <= show_number(3 downto 0);
            -- the fourth hex digit of the 16-bit number    
        when others=> anode<="1110";
        end case;
    end process;
end architecture ; -- behavioral

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
ENTITY main_entity IS
PORT (
        mode: IN std_logic_vector(1 downto 0);
        specify_currency: IN std_logic_vector(11 downto 0);
        type_currency: IN std_logic_vector(1 downto 0);
        confirm : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        reset: IN std_logic;
        err: OUT STD_LOGIC;
        back: IN STD_LOGIC;
        cathode: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0)
     );
END ENTITY main_entity;

architecture behavioral of main_entity is

    signal show_type: std_logic_vector(1 downto 0);
    signal show_number: std_logic_vector(7 downto 0);
    
begin
    mini_project: Entity Work.mini_project(Behavioral)
    PORT MAP(
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
    
    status_display_block: Entity Work.status_display_block(behavioral)
        PORT MAP(
            show_type => show_type,
            show_number => show_number,
            cathode => cathode,
            anode => anode,
            clk => clk
        );

end architecture ;