----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 11:10:09 PM
-- Design Name: 
-- Module Name: twoToOneMUX - Behavioral
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

entity twoToOneMUX is
    Port ( i_sel : in STD_LOGIC;
           i_inputOne : in STD_LOGIC_VECTOR (7 downto 0);
           i_inputZero : in STD_LOGIC_VECTOR (7 downto 0);
           o_out : out STD_LOGIC_VECTOR (7 downto 0));
end twoToOneMUX;

architecture Behavioral of twoToOneMUX is

begin
    o_out <= i_inputOne when (i_sel = '1') else 
             i_inputZero when (i_sel = '0') else
             i_inputOne;


end Behavioral;
