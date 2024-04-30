----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 10:36:23 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
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

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture Behavioral of controller_fsm is
    type sm_cycle is (s_A_input, s_B_input, s_Result, s_Off);
    signal f_Q : sm_cycle;
begin
    f_Q <= s_A_input when (i_adv = '1' and f_Q = s_Off) else
           s_B_input when (i_adv = '1' and f_Q = s_A_input) else
           s_Result when (i_adv = '1' and f_Q = s_B_input) else
           s_Off when (i_adv = '1' and f_Q = s_Result)
           else s_Result;
    with f_Q select
        o_cycle <= 
            "0001" when s_A_input,
            "0010" when s_B_input,
            "0100" when s_Result,
            "1000" when s_Off,
            "0100" when others;
end Behavioral;
