----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2024 08:14:23 AM
-- Design Name: 
-- Module Name: anode_MUX - Behavioral
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

entity anode_MUX is
    Port ( sign_on : in STD_LOGIC_VECTOR (3 downto 0);
           hund_on : in STD_LOGIC_VECTOR (3 downto 0);
           tens_on : in STD_LOGIC_VECTOR (3 downto 0);
           ones_on : in STD_LOGIC_VECTOR (3 downto 0);
           all_off1 : in STD_LOGIC_VECTOR (3 downto 0);
           all_off2 : in STD_LOGIC_VECTOR (3 downto 0);
           all_off3 : in STD_LOGIC_VECTOR (3 downto 0);
           all_off4 : in STD_LOGIC_VECTOR (3 downto 0);
           i_sel : in STD_LOGIC_VECTOR (2 downto 0);
           o_an : out STD_LOGIC_VECTOR (3 downto 0));
end anode_MUX;

architecture Behavioral of anode_MUX is

begin
    o_an <= sign_on when (i_sel = "011") else 
            hund_on when (i_sel = "010") else
            tens_on when (i_sel = "001") else
            ones_on when (i_sel = "000") else
            all_off1 when (i_sel = "100") else
            all_off2 when (i_sel = "101") else
            all_off3 when (i_sel = "110") else
            all_off4;

end Behavioral;
