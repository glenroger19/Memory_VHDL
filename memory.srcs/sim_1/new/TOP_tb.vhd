library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_tb is
end TOP_tb;

architecture Behavioral of TOP_tb is
    -- Component declaration for the unit under test (UUT)
    component TOP
        Port (
            Clk : in std_logic;
            Rst : in std_logic;
            Btnc : in std_logic;
            sw_i : in std_logic_vector(15 downto 0);
            MemoryData : out std_logic_vector(159 downto 0);
            led_o : out std_logic_vector(15 downto 0);
            anode_activate : out std_logic_vector(3 downto 0);
            seg_o : out std_logic_vector(6 downto 0);
            reset_aff : out std_logic
        );
    end component;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

    -- Signals for test bench
    signal Clk_tb : std_logic := '0';
    signal Rst_tb : std_logic := '1';  -- Reset active high
    signal Btnc_tb : std_logic := '0';
    signal sw_i_tb : std_logic_vector(15 downto 0) := (others => '0');
    signal MemoryData_tb : std_logic_vector(159 downto 0);
    signal led_o_tb : std_logic_vector(15 downto 0);
    signal anode_activate_tb : std_logic_vector(3 downto 0);
    signal seg_o_tb : std_logic_vector(6 downto 0);
    signal reset_aff_tb : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: TOP port map (
        Clk => Clk_tb,
        Rst => Rst_tb,
        Btnc => Btnc_tb,
        sw_i => sw_i_tb,
        MemoryData => MemoryData_tb,
        led_o => led_o_tb,
        anode_activate => anode_activate_tb,
        seg_o => seg_o_tb,
        reset_aff => reset_aff_tb
    );

    -- Clock process definitions
    Clk_process: process
    begin
        while now < 500 ns loop  -- Run the clock for 500 ns
            Clk_tb <= '0';
            wait for clk_period / 2;
            Clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process for reset signal
    Stimulus_process: process
    begin
        Rst_tb <= '1';  -- Assert reset
        wait for 10 ns;
        Rst_tb <= '0';  -- De-assert reset
        wait;
    end process;

    -- Stimulus process for input switches
    Stimulus_switches: process
    begin
        wait for 20 ns; -- Wait for a few cycles before changing input switches
        sw_i_tb <= "1010101010101010"; -- Sample data for input switches
        wait for 100 ns;
        sw_i_tb <= "0101010101010101"; -- Another sample data for input switches
        wait;
    end process;

    -- Process to monitor outputs
    Monitor_process: process
    begin
        wait for 50 ns; -- Wait for initial stabilization
        while true loop
            -- Report outputs to console
            report "LEDs: " & to_string(led_o_tb);
            report "Anode activate: " & to_string(anode_activate_tb);
            report "Segment output: " & to_string(seg_o_tb);
            wait for 10 ns;
        end loop;
    end process;

end Behavioral;
