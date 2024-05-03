--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|     OR      001
--|     AND     010
--|     LEFT    011
--|     SUB     100
--|     OR      101
--|     AND     110
--|     RIGHT   111
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
    port ( i_op: in std_logic_vector(2 downto 0);
           i_A: in std_logic_vector(7 downto 0);
           i_B: in std_logic_vector(7 downto 0);
           o_result: out std_logic_vector(7 downto 0);
           o_flags: out std_logic_vector(3 downto 0)
    );
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
component twoToOneMUX is
    port (
        i_sel : in STD_LOGIC;
        i_inputOne : in STD_LOGIC_VECTOR (7 downto 0);
        i_inputZero : in STD_LOGIC_VECTOR (7 downto 0);
        o_out : out STD_LOGIC_VECTOR (7 downto 0));  
end component;

component aluFullAdder is
    port (
        i_A : in STD_LOGIC_VECTOR (7 downto 0);
        i_B : in STD_LOGIC_VECTOR (7 downto 0);
        i_Cin : in STD_LOGIC;
        o_S : out STD_LOGIC_VECTOR (7 downto 0);
        o_Cout : out STD_LOGIC);
end component;

component aluFourToOneMUX is
    Port ( i_op : in STD_LOGIC_VECTOR (1 downto 0);
           i_inOne : in STD_LOGIC_VECTOR (7 downto 0);
           i_inTwo : in STD_LOGIC_VECTOR (7 downto 0);
           i_inThree : in STD_LOGIC_VECTOR (7 downto 0);
           i_inFour : in STD_LOGIC_VECTOR (7 downto 0);
           o_out : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal w_adder_operand: std_logic_vector(7 downto 0);
signal not_i_B: std_logic_vector(7 downto 0);
signal adder_output: std_logic_vector(7 downto 0);
signal w_Cout: std_logic;
signal w_left_shift: std_logic_vector(7 downto 0);
signal w_right_shift: std_logic_vector(7 downto 0);
signal w_shift_amt: std_logic_vector(2 downto 0);
signal w_shift_result: std_logic_vector(7 downto 0);
signal w_OR: std_logic_vector(7 downto 0);
signal w_AND: std_logic_vector(7 downto 0);
signal w_alu_result: std_logic_vector(7 downto 0);
signal w_over1: std_logic;
signal w_over2: std_logic;
signal w_op: std_logic_vector(2 downto 0);
  
begin
	-- PORT MAPS ----------------------------------------
    adder_MUX_inst : twoToOneMUX
        port map (
            i_sel => i_op(2),
            i_inputOne => not_i_B,
            i_inputZero => i_B,
            o_out => w_adder_operand
            );
    fullAdder_inst : aluFullAdder
        port map (
            i_A => i_A,
            i_B => w_adder_operand,
            i_Cin => i_op(2),
            o_S => adder_output,
            o_Cout => w_Cout
            );
    shiftMUX_inst: twoToOneMUX
        port map (
            i_sel => i_op(2),
            i_inputOne => w_right_shift,
            i_inputZero => w_left_shift,
            o_out => w_shift_result
            );
    fourToOneMUX_inst: aluFourToOneMUX
        port map (
             i_op(1) => i_op(1),
             i_op(0) => i_op(0),
             i_inOne => adder_output,
             i_inTwo => w_OR,
             i_inThree => w_AND,
             i_inFour => w_shift_result,
             o_out => w_alu_result
             );
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	not_i_B <= not i_B;
	w_shift_amt(2) <= i_B(2);
	w_shift_amt(1) <= i_B(1);
	w_shift_amt(0) <= i_B(0);
	w_op <= i_op;
	--Documentation for the left and right shift functions were found
	--here: https://nandland.com/shift-left-shift-right/
	--I also had some odd errors that ChatGPT fixed in terms of syntax
    w_left_shift <= std_logic_vector(shift_left(unsigned(i_A), to_integer(unsigned(w_shift_amt))));
    w_right_shift <= std_logic_vector(shift_right(unsigned(i_A), to_integer(unsigned(w_shift_amt))));
    w_OR <= i_A or i_B;
    w_AND <= i_A and i_B;
    o_result <= w_alu_result;
    w_over1 <= w_alu_result(7) and not i_A(7) and not i_B(7);
    w_over2 <= i_A(7) and i_B(7) and not w_alu_result(7);
    o_flags(3) <= w_alu_result(7); --Negative
    o_flags(2) <= '1' when (w_alu_result = "00000000") else -- Zero
                   '0';
    o_flags(1) <= w_Cout and not w_op(1) and not w_op(0); --Carryout
    o_flags(0) <= (w_over1 xor w_over2) when (i_op(1 downto 0) = "00"); 
end behavioral;
