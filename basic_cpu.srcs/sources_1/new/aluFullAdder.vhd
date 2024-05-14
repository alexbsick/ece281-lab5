----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2024 10:15:48 AM
-- Design Name: 
-- Module Name: aluFullAdder - Behavioral
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

--code for multiple-bit full adder from: https://www.engineersgarage.com/vhdl-tutorial-21-designing-an-8-bit-full-adder-circuit-using-vhdl/

entity aluFullAdder is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_Cin : in STD_LOGIC;
           o_S : out STD_LOGIC_VECTOR (7 downto 0);
           o_Cout : out STD_LOGIC);
end aluFullAdder;

architecture Behavioral of aluFullAdder is

signal carry: std_logic_vector(6 downto 0);

component oneBitFullAdder is
    port(
        A: in std_logic;
        B: in std_logic;
        Cin: in std_logic;
        S: out std_logic;
        Cout: out std_logic
        );
    end component;

begin
    fullA0: oneBitFullAdder
        port map (
            A => i_A(0),
            B => i_B(0),
            Cin => i_Cin,
            S => o_S(0),
            Cout => carry(0)
            );
     fullA1: oneBitFullAdder
        port map (
            A => i_A(1),
            B => i_B(1),
            Cin => carry(0),
            S => o_S(1),
            Cout => carry(1)
            );
     fullA2: oneBitFullAdder
        port map (
            A => i_A(2),
            B => i_B(2),
            Cin => carry(1),
            S => o_S(2),
            Cout => carry(2)
            );
     fullA3: oneBitFullAdder
        port map (
            A => i_A(3),
            B => i_B(3),
            Cin => carry(2),
            S => o_S(3),
            Cout => carry(3)
            );
     fullA4: oneBitFullAdder
        port map (
            A => i_A(4),
            B => i_B(4),
            Cin => carry(3),
            S => o_S(4),
            Cout => carry(4)
            );
     fullA5: oneBitFullAdder
        port map (
            A => i_A(5),
            B => i_B(5),
            Cin => carry(4),
            S => o_S(5),
            Cout => carry(5)
            );
     fullA6: oneBitFullAdder
        port map (
            A => i_A(6),
            B => i_B(6),
            Cin => carry(5),
            S => o_S(6),
            Cout => carry(6)
            );
     fullA7: oneBitFullAdder
        port map (
            A => i_A(7),
            B => i_B(7),
            Cin => carry(6),
            S => o_S(7),
            Cout => o_Cout
            );
end Behavioral;
