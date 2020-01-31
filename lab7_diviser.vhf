library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

ENTITY subtractor IS
    PORT(
        a: IN STD_LOGIC;
        b: IN STD_LOGIC;
        cin: IN STD_LOGIC;
        cout: OUT STD_LOGIC;
        s: OUT STD_LOGIC
        );
END subtractor;

ARCHITECTURE behavioural OF subtractor IS
    BEGIN
    s <= (a XOR b) XOR cin;
    cout <= ((NOT a) AND b) OR ((NOT a) AND cin) OR (cin AND b);
END behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity carry_propagate_subtractor is
    port(
        a1: in STD_LOGIC_VECTOR(7 downto 0);
        a2: in STD_LOGIC_VECTOR(7 downto 0);
        b: out STD_LOGIC_VECTOR(7 downto 0);
        cout: out STD_LOGIC
    );
end carry_propagate_subtractor;

ARCHITECTURE behavioural of carry_subtractor is
    signal carry: STD_LOGIC_VECTOR(7 downto 0);
    signal first_carry: STD_LOGIC;
    BEGIN
    first_carry<='0';
    first: ENTITY WORK.subtractor(behavioural)
        PORT MAP(
            a=>a1(0),
            b=>a2(0),
            cin=>first_carry,
            cout=>carry(0),
            s=>b(0));
    ADD1TO7: for i in 1 to 7 generate
        ADDi: ENTITY WORK.subtractor(behavioural)
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

