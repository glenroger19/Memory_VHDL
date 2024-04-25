library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory_TB is
end Memory_TB;

architecture Behavioral of Memory_TB is
    -- Constants
    constant CLK_PERIOD : time := 10 ns; -- Clock period
    
    -- Signals
    signal Clk, Rst, Btnc : std_logic := '0'; -- Clock, Reset, and Button signals
    signal sw_i : std_logic_vector(15 downto 0) := (others => '0'); -- Input switches
    signal MemoryData : std_logic_vector(159 downto 0); -- Memory output
    signal led_o : std_logic_vector(15 downto 0); -- LED output
    
    -- Instantiate the Memory entity
    component Memory
        Port (
            Clk : in STD_LOGIC;
            Rst : in STD_LOGIC;
            sw_i : in STD_LOGIC_VECTOR(15 downto 0);
            MemoryData : out STD_LOGIC_VECTOR(159 downto 0);
            led_o : out std_logic_vector(15 downto 0);
            Btnc : in STD_LOGIC
        );
    end component;
    
begin
    -- Instantiate the Memory entity
    DUT: Memory port map (
        Clk => Clk,
        Rst => Rst,
        sw_i => sw_i,
        MemoryData => MemoryData,
        led_o => led_o,
        Btnc => Btnc
    );

    -- Testbench process
    process
    begin
        Rst <= '1';
        wait for CLK_PERIOD;
        Rst <= '0';
        
        wait for CLK_PERIOD;
        sw_i <= "1010101010101010";
        Btnc <= '1';
        wait for CLK_PERIOD;
        Btnc <= '0';
        wait for CLK_PERIOD;

        sw_i <= "1100110011001100";
        Btnc <= '1';
        wait for CLK_PERIOD;
        Btnc <= '0';
        wait for CLK_PERIOD;

        wait for 100 ns;
        wait;
    end process;
    
end Behavioral;

