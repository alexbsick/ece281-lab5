----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 11:08:18 PM
-- Design Name: 
-- Module Name: 2to1MUX - Behavioral
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

entity 2to1MUX is
    Port ( i_sel : in STD_LOGIC;
           i_InOne : in STD_LOGIC_VECTOR (7 downto 0);
           i_InTwo : in STD_LOGIC_VECTOR (7 downto 0);
           i_out : out STD_LOGIC_VECTOR (7 downto 0));
end 2to1MUX;

architecture Behavioral of 2to1MUX is

begin


end Behavioral;
