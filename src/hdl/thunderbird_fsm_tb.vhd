--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : thunderbird_fsm_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner
--| CREATED       : 03/2017
--| DESCRIPTION   : This file tests the thunderbird_fsm modules.
--|
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : thunderbird_fsm_enumerated.vhd, thunderbird_fsm_binary.vhd, 
--|				   or thunderbird_fsm_onehot.vhd
--|
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
  
entity thunderbird_fsm_tb is
end thunderbird_fsm_tb;

architecture test_bench of thunderbird_fsm_tb is 
	
	-- component declaration for the unit under test (UUT)
	
	component thunderbird_fsm is 
	  port(
          i_clk, i_reset  : in    std_logic;
          i_left, i_right : in    std_logic;
          o_lights_L      : out   std_logic_vector(2 downto 0);
          o_lights_R      : out   std_logic_vector(2 downto 0)
	  );
    end component thunderbird_fsm;        

	-- test I/O signals
	
	-- inputs
	signal w_clk   : std_logic := '0';
	signal w_reset : std_logic := '0';
	signal w_left  : std_logic := '0';
	signal w_right : std_logic := '0';
	
	-- outputs
	signal w_lights_L  : std_logic_vector(2 downto 0)  := "000";
	signal w_lights_R  : std_logic_vector(2 downto 0)  := "000";
	
	-- signal w_thunderbird   :   std_logic_vector(2 downto 0) := "000";
	
	-- constants
	constant k_clk_period  : time := 10 ns;
	
	
begin
	-- PORT MAPS ----------------------------------------
	--Instantiate the unit under test (UUT)
	uut: thunderbird_fsm port map (
        i_clk => w_clk,
        i_reset => w_reset,
        i_left => w_left,
        i_right => w_right,
        o_lights_L => w_lights_L,
        o_lights_R => w_lights_R
	);
	-----------------------------------------------------
	
	-- PROCESSES ----------------------------------------	
    -- Clock process ------------------------------------
    clk_proc : process
    begin
        w_clk <= '0';
        wait for k_clk_period/2;
        w_clk <= '1';
        wait for k_clk_period/2;
    end process;
	-----------------------------------------------------
	
	-- Test Plan Process --------------------------------
	tp_proc: process
	begin
	
        -- sequential timing
        -- Check if reset works by asserting the L and R states should be 000 after reset
        w_reset <= '1';
        wait for k_clk_period*1;
           assert w_lights_L = "000" report "bad reset" severity failure;
           assert w_lights_R = "000" report "bad reset" severity failure;
        w_reset <= '0';
        wait for k_clk_period*1;
        
       -- turn on left turn signal
        w_left <= '1'; w_right <= '0';
        -- check if first signal fires for left turn
        wait for k_clk_period;
           assert w_lights_L = "001" report "1st stage of left turn signal failed" severity failure;
           assert w_lights_R = "000" report "1st stage of right output from left turn signal failed" severity failure;
        -- check if second signal fires for left turn
        wait for k_clk_period;
           assert w_lights_L = "011" report "2nd stage of left turn signal failed" severity failure;
           assert w_lights_R = "000" report "2nd stage of right output from left turn signal failed" severity failure;
        -- check if third signal fires for left turn
        wait for k_clk_period;
           assert w_lights_L = "111" report "3rd stage of left turn signal failed" severity failure;
           assert w_lights_R = "000" report "3rd stage of right output from left turn signal failed" severity failure;
        -- check if left turn lights reset after third signal fires
        wait for k_clk_period;
           assert w_lights_L = "000" report "final stage / reset of left turn signal failed" severity failure;
           assert w_lights_R = "000" report "final stage / reset of left turn signal failed" severity failure;            
       
        -- turn on right turn signal
        w_left <= '0'; w_right <= '1';
        -- check if first signal fires for right turn
        wait for k_clk_period;
           assert w_lights_L = "000" report "1st stage of left output from right turn signal failed" severity failure;
           assert w_lights_R = "001" report "1st stage of right turn signal failed" severity failure;
        -- check if second signal fires for right turn
        wait for k_clk_period;
           assert w_lights_L = "000" report "2nd stage of left output from right turn signal failed" severity failure;
           assert w_lights_R = "011" report "2nd stage of right turn signal failed" severity failure;
        -- check if third signal fires for right turn
        wait for k_clk_period;
           assert w_lights_L = "000" report "3rd stage of left output from right turn signal failed" severity failure;
           assert w_lights_R = "111" report "3rd stage of right turn signal failed" severity failure;
        -- check if right turn lights reset after third signal fires
        wait for k_clk_period;
           assert w_lights_L = "000" report "final stage / reset of left turn signal failed" severity failure;
           assert w_lights_R = "000" report "final stage / reset of left turn signal failed" severity failure;     
       
       -- turn on hazards 
       w_left <= '1'; w_right <= '1';
       -- check if all lights turn on for hazards
       wait for k_clk_period;
           assert w_lights_L = "111" report "left lights failed to light up during hazards stage" severity failure;
           assert w_lights_R = "111" report "right lights failed to light up during hazards stage" severity failure;
       -- check if all lights turn off for second stage of hazards
       wait for k_clk_period;
           assert w_lights_L = "000" report "left lights failed to turn off during hazards stage" severity failure;
           assert w_lights_R = "000" report "right lights failed to turn off during hazards stage" severity failure;
           
           wait;
       end process;
	-----------------------------------------------------	
	
end test_bench;
