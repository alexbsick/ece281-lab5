----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 11:12:49 PM
-- Design Name: 
-- Module Name: aluFourToOneMUX - Behavioral
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

entity aluFourToOneMUX is
    Port ( i_op : in STD_LOGIC_VECTOR (1 downto 0);
           i_inOne : in STD_LOGIC_VECTOR (7 downto 0);
           i_inTwo : in STD_LOGIC_VECTOR (7 downto 0);
           i_inThree : in STD_LOGIC_VECTOR (7 downto 0);
           i_inFour : in STD_LOGIC_VECTOR (7 downto 0);
           i_out : out STD_LOGIC_VECTOR (7 downto 0));
end aluFourToOneMUX;

architecture Behavioral of aluFourToOneMUX is

begin


end Behavioral;
