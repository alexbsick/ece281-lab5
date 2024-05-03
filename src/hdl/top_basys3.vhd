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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port (
        clk: in std_logic;
        btnU: in std_logic;
        btnC: in std_logic;
        sw: in std_logic_vector(7 downto 0);
        led :   out std_logic_vector(15 downto 0);
        -- 7-segment display segments (active-low cathodes)
        seg :   out std_logic_vector(6 downto 0);
        -- 7-segment display active-low enables (anodes)
        an  :   out std_logic_vector(3 downto 0)
        );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
component controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           i_clk: in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component ALU is
    port ( i_op: in std_logic_vector(2 downto 0);
           i_A: in std_logic_vector(7 downto 0);
           i_B: in std_logic_vector(7 downto 0);
           o_result: out std_logic_vector(7 downto 0);
           o_flags: out std_logic_vector(3 downto 0)
    );
end component;

component TopBasysMUX is
    Port ( i_cycle : in STD_LOGIC_VECTOR (3 downto 0);
           i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_off : in STD_LOGIC_VECTOR (7 downto 0);
           i_result : in STD_LOGIC_VECTOR (7 downto 0);
           o_bin : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component twoscomp_decimal is
    port (
        i_binary: in std_logic_vector(7 downto 0);
        o_negative: out std_logic;
        o_hundreds: out std_logic_vector(3 downto 0);
        o_tens: out std_logic_vector(3 downto 0);
        o_ones: out std_logic_vector(3 downto 0)
    );
end component;

component TDM4 is
    generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
    Port ( i_clk		: in  STD_LOGIC;
           i_reset		: in  STD_LOGIC; -- asynchronous
           i_D3 		: in  STD_LOGIC;
		   i_D2 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D1 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D0 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   o_data		: out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   o_sel		: out STD_LOGIC_VECTOR (1 downto 0)	-- binary encoding
	);
end component;

--this is the normal one
component sevenSegDecoder is
    Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
           o_S : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component clock_divider is
    generic ( constant k_DIV : natural := 2	); -- How many clk cycles until slow clock toggles									   -- Effectively, you divide the clk double this 
	--In the instance, the k_DIV should be 80000 to account for twice as many
	--anodes as in Lab 4 and only changing on the rising edge	
											   -- number (e.g., k_DIV := 2 --> clock divider of 4)
	port ( 	i_clk    : in std_logic;
			i_reset  : in std_logic;		   -- asynchronous
			o_clk    : out std_logic		   -- divided (slow) clock
	);
end component;

component anode_MUX is
    port (
           sign_on : in STD_LOGIC_VECTOR (3 downto 0);
           hund_on : in STD_LOGIC_VECTOR (3 downto 0);
           tens_on : in STD_LOGIC_VECTOR (3 downto 0);
           ones_on : in STD_LOGIC_VECTOR (3 downto 0);
           all_off1 : in STD_LOGIC_VECTOR (3 downto 0);
           all_off2 : in STD_LOGIC_VECTOR (3 downto 0);
           all_off3 : in STD_LOGIC_VECTOR (3 downto 0);
           all_off4 : in STD_LOGIC_VECTOR (3 downto 0);
           i_sel : in STD_LOGIC_VECTOR (2 downto 0);
           o_an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component sevenSegDecoder_neg is
    port (
        i_D: in std_logic_vector(3 downto 0);
        o_S: out std_logic_vector(6 downto 0)
        );
end component;

component seg_MUX is
    Port ( i_neg : in STD_LOGIC_VECTOR (6 downto 0);
           i_norm : in STD_LOGIC_VECTOR (6 downto 0);
           i_sel : in STD_LOGIC_VECTOR (1 downto 0);
           o_seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component wire_Register is
    port (
        i_clk: in std_logic;
        i_Sw: in std_logic_vector(7 downto 0);
        i_reset: in std_logic;
        o_wire: out std_logic_vector(7 downto 0)
        );
end component;

signal w_cycle: std_logic_vector(3 downto 0);
signal w_clk: std_logic;
signal w_A: std_logic_vector(7 downto 0);
signal w_B: std_logic_vector(7 downto 0);
signal op_bits: std_logic_vector(2 downto 0);
signal w_flags: std_logic_vector(3 downto 0);
signal w_result: std_logic_vector(7 downto 0);
signal w_bin: std_logic_vector(7 downto 0);
signal w_negative: std_logic;
signal w_hund: std_logic_vector(3 downto 0);
signal w_tens: std_logic_vector(3 downto 0);
signal w_ones: std_logic_vector(3 downto 0);
signal w_data: std_logic_vector(3 downto 0);
signal not_w_cycle3: std_logic;
signal w_sel: std_logic_vector(1 downto 0);
--signal w_sign: std_logic_vector(3 downto 0);
signal w_neg_seg: std_logic_vector(6 downto 0);
signal w_norm_seg: std_logic_vector(6 downto 0);

--anode_MUX stuff
signal w_sign_on: std_logic_vector(3 downto 0);
signal w_hund_on: std_logic_vector(3 downto 0);
signal w_tens_on: std_logic_vector(3 downto 0);
signal w_ones_on: std_logic_vector(3 downto 0);
signal w_all_off: std_logic_vector(3 downto 0);
signal w_fsm_clk: std_logic;
  
begin
	-- PORT MAPS ----------------------------------------
    controller_fsm_inst: controller_fsm
        port map (
            i_reset => btnU,
            i_adv => btnC,
            o_cycle => w_cycle,
            i_clk => w_fsm_clk
            );
    clock_divider_inst: clock_divider
        generic map ( k_DIV => 80000)
        port map (
            i_clk => clk,
            i_reset => btnU,
            o_clk => w_clk
            );
            
    register_A_inst: wire_Register
        port map (
            i_clk => w_cycle(0),
            i_reset => btnU,
            i_Sw => sw,
            o_wire => w_A
            );
    
    register_B_inst: wire_Register
        port map (
            i_clk => w_cycle(1),
            i_reset => btnU,
            i_Sw => sw,
            o_wire => w_B
            );
    
    ALU_inst: ALU
        port map (
            i_A => w_A,
            i_B => w_B,
            i_op => op_bits,
            o_flags => w_flags,
            o_result => w_result
            );
    
    TopBasysMUX_inst: TopBasysMUX
        port map (
            i_cycle => w_cycle,
            i_A => sw,
            i_B => sw,
            i_result => w_result,
            i_off => "00000000",
            o_bin => w_bin
            );
            
    twoscomp_decimal_inst: twoscomp_decimal
        port map (
            i_binary => w_bin,
            o_negative => w_negative,
            o_hundreds => w_hund,
            o_tens => w_tens,
            o_ones => w_ones
            );
    
    TDM4_inst: TDM4
        port map (
            i_clk => w_clk,
            i_reset => btnU,
            i_D3 => w_negative,
            i_D2 => w_hund,
            i_D1 => w_tens,
            i_D0 => w_ones,
            o_data => w_data,
            o_sel => w_sel
            );
    
    sevenSegDecoder_inst: sevenSegDecoder
        port map (
            i_D => w_data,
            o_S => w_norm_seg
            );
    
    anode_MUX_inst: anode_MUX
        port map (
            sign_on => w_sign_on,
            hund_on => w_hund_on,
            tens_on => w_tens_on,
            ones_on => w_ones_on,
            all_off1 => w_all_off,
            all_off2 => w_all_off,
            all_off3 => w_all_off,
            all_off4 => w_all_off,
            i_sel(2) => w_cycle(3),
            i_sel(1) => w_sel(1),
            i_sel(0) => w_sel(0),
            o_an => an
            );
    
    sevenSegDecoder_neg_inst: sevenSegDecoder_neg
        port map (
            i_D => w_data,
            o_S => w_neg_seg
            );
    
    seg_MUX_inst: seg_MUX
        port map (
            i_neg => w_neg_seg,
            i_norm => w_norm_seg,
            i_sel => w_sel,
            o_seg => seg
            );
    controller_clk_div_inst: clock_divider
      	    generic map ( k_DIV => 12500000 )
      	    port map (
      	    i_clk => clk,
      	    i_reset => btnU,
      	    o_clk => w_fsm_clk
      	    );
	
	-- CONCURRENT STATEMENTS ----------------------------
	--anode_MUX signals
	
	
	w_sign_on <= "0111";
	w_hund_on <= "1011";
	w_tens_on <= "1101";
	w_ones_on <= "1110";
	w_all_off <= "1111";
	led(3 downto 0) <= w_cycle;
	led(15 downto 12) <= w_flags when (w_cycle = "0100") else "0000";
	op_bits <= sw(2 downto 0);
	led(11 downto 4) <= "00000000";
end top_basys3_arch;
