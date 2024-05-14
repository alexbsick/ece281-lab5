----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2024 07:46:53 AM
-- Design Name: 
-- Module Name: wire_Register - Behavioral
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

entity wire_Register is
    Port ( i_Sw : in STD_LOGIC_VECTOR (7 downto 0);
           i_clk : in STD_LOGIC;
           o_wire : out STD_LOGIC_VECTOR (7 downto 0);
           i_reset : in STD_LOGIC);
end wire_Register;

architecture Behavioral of wire_Register is

signal f_Q, f_Q_next: std_logic_vector(7 downto 0);

begin
    f_Q_next <= i_Sw;
    o_wire <= f_Q;
    
    register_process: process (i_reset, i_clk)
        begin
            if (i_reset = '1') then
                f_Q <= "00011000";
            else
            if (falling_edge(i_clk)) then
                f_Q <= f_Q_next;
                else
                f_Q <= f_Q;
            end if;
            end if;
    end process register_process;
end Behavioral;
