----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2024 10:10:09 PM
-- Design Name: 
-- Module Name: ALU_tb - Behavioral
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

entity ALU_tb is
    Port ( i_op : in STD_LOGIC_VECTOR (2 downto 0);
           i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU_tb;

architecture test_bench of ALU_tb is
    component ALU is
        Port ( i_op : in STD_LOGIC_VECTOR (2 downto 0);
               i_A : in STD_LOGIC_VECTOR (7 downto 0);
               i_B : in STD_LOGIC_VECTOR (7 downto 0);
               o_result : out STD_LOGIC_VECTOR (7 downto 0);
               o_flags : out STD_LOGIC_VECTOR (3 downto 0));
   end component;
   
   signal w_op : std_logic_vector (2 downto 0) := "000";
   signal w_A : std_logic_vector (7 downto 0) := "00000000";
   signal w_B : std_logic_vector (7 downto 0) := "00000000";
   signal w_flags : std_logic_vector (3 downto 0) := "0000";
   signal w_result : std_logic_vector (7 downto 0) := "00000000";
   
   constant k_clk_period : time := 10 ns;

begin

    uut: ALU port map (
        i_op => w_op,
        i_A => w_A,
        i_B => w_B,
        o_result => w_result,
        o_flags => w_flags
    );
    
    sim_proc: process
    begin
        w_A <= "00000011"; w_B <= "00000110";
        w_op <= "000"; wait for k_clk_period;
            assert w_result = "00001001" report "bad addition 1" severity failure;
            assert w_flags = "0000" report "bad add flags 1" severity failure;
        w_op <= "001"; wait for k_clk_period;
            assert w_result = "00000111" report "bad OR 1" severity failure;
            assert w_flags = "0000" report "bad OR flags 1" severity failure;
        w_op <= "010"; wait for k_clk_period;
            assert w_result = "00000010" report "bad AND 1" severity failure;
            assert w_flags = "0000" report "bad AND flags 1" severity failure;
        w_op <= "011"; wait for k_clk_period;
            assert w_result = "11000000" report "bad left shift 1" severity failure;
            assert w_flags = "1000" report "bad left shift flags 1" severity failure;
        w_op <= "100"; wait for k_clk_period;
            assert w_result = "11111101" report "bad subtraction 1" severity failure;
            assert w_flags = "1001" report "bad sub flags 1" severity failure;
        w_op <= "101"; wait for k_clk_period;
            assert w_result = "00000111" report "bad OR 1" severity failure;
            assert w_flags = "0000" report "bad OR flags 1" severity failure;
        w_op <= "110"; wait for k_clk_period;
            assert w_result = "00000010" report "bad AND 1" severity failure;
            assert w_flags = "0000" report "bad AND flags 1" severity failure;
        w_op <= "111"; wait for k_clk_period;
            assert w_result = "00000000" report "bad right shift 1" severity failure;
            assert w_flags = "0100" report "bad right shift flags 1" severity failure;
            
    --These will be the experiments for 2 negative numbers (-64 and -123)
        w_A <= "11000000"; w_B <= "10000101";
        w_op <= "000"; wait for k_clk_period;
            assert w_result = "01000101" report "bad addition 2" severity failure;
            assert w_flags = "0011" report "bad add flags 2" severity failure;
        w_op <= "001"; wait for k_clk_period;
            assert w_result = "11000101" report "bad OR 2" severity failure;
            assert w_flags = "1000" report "bad OR flags 2" severity failure;
        w_op <= "010"; wait for k_clk_period;
            assert w_result = "10000000" report "bad AND 2" severity failure;
            assert w_flags = "1000" report "bad AND flags 2" severity failure;
        w_op <= "011"; wait for k_clk_period;
            assert w_result = "00000000" report "bad left shift 2" severity failure;
            assert w_flags = "0100" report "bad left shift flags 2" severity failure;
        w_op <= "100"; wait for k_clk_period;
            assert w_result = "00111011" report "bad subtraction 2" severity failure;
            assert w_flags = "0011" report "bad sub flags 2" severity failure;
        w_op <= "101"; wait for k_clk_period;
            assert w_result = "11000101" report "bad OR 2" severity failure;
            assert w_flags = "1000" report "bad OR flags 2" severity failure;
        w_op <= "110"; wait for k_clk_period;
            assert w_result = "10000000" report "bad AND 2" severity failure;
            assert w_flags = "1000" report "bad AND flags 2" severity failure;
        w_op <= "111"; wait for k_clk_period;
            assert w_result = "00000110" report "bad right shift 2" severity failure;
            assert w_flags = "0000" report "bad right shift flags 2" severity failure;
    wait;
    end process;
end test_bench;
