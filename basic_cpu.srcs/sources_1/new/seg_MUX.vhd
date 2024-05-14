----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2024 10:19:45 AM
-- Design Name: 
-- Module Name: seg_MUX - Behavioral
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

entity seg_MUX is
    Port ( i_neg : in STD_LOGIC_VECTOR (6 downto 0);
           i_norm : in STD_LOGIC_VECTOR (6 downto 0);
           i_sel : in STD_LOGIC_VECTOR (1 downto 0);
           o_seg : out STD_LOGIC_VECTOR (6 downto 0));
end seg_MUX;

architecture Behavioral of seg_MUX is

begin
    o_seg <= i_neg when (i_sel = "11") else
             i_norm;


end Behavioral;
