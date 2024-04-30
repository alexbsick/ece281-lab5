----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 11:05:32 PM
-- Design Name: 
-- Module Name: TopBasysMUX - Behavioral
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

entity TopBasysMUX is
    Port ( i_cycle : in STD_LOGIC_VECTOR (3 downto 0);
           i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_off : in STD_LOGIC_VECTOR (7 downto 0);
           i_result : in STD_LOGIC_VECTOR (7 downto 0);
           o_bin : out STD_LOGIC_VECTOR (7 downto 0));
end TopBasysMUX;

architecture Behavioral of TopBasysMUX is

begin
    o_bin <= i_A when (i_cycle = "0001") else 
             i_B when (i_cycle = "0010") else
             i_result when (i_cycle = "0100") else
             i_off when (i_cycle = "1000") else
             i_A;
end Behavioral;
