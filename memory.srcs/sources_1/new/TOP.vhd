library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
--  Port ( );
end TOP;

architecture Behavioral of TOP is
-- Signals
    signal Clk, Rst, Btnc : std_logic := '0'; -- Clock, Reset, and Button signals
    signal sw_i : std_logic_vector(15 downto 0) := (others => '0'); -- Input switches
    signal MemoryData : std_logic_vector(159 downto 0); -- Memory output
    signal led_o : std_logic_vector(15 downto 0); -- LED output;
    signal anode_activate : std_logic_vector (3 downto 0);
    signal seg_o : std_logic_vector(6 downto 0);
    signal tableau : STD_LOGIC_VECTOR (15 downto 0);
    signal reset_aff : STD_LOGIC;
    signal ten_second_counter: unsigned (27 downto 0);-- counter for generating 1-second clock enable
    signal ten_second_enable: std_logic; -- one second enable for counting numbers pour le clignotement
    signal indice: integer; 
    
    component Memory
        Port (
            Rst : in STD_LOGIC;
            sw_i : in STD_LOGIC_VECTOR(15 downto 0);
            MemoryData : out STD_LOGIC_VECTOR(159 downto 0);
            led_o : out std_logic_vector(15 downto 0);
            Btnc : in STD_LOGIC
        );
    end component;
    
    component affichage is
    Port ( switches : in STD_LOGIC_VECTOR (15 downto 0);
           clock_100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           Anode_activate : out STD_LOGIC_VECTOR (3 downto 0);
           seg_o : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

begin

MEM: Memory port map (
        Rst => Rst,
        sw_i => sw_i,
        MemoryData => MemoryData,
        led_o => led_o,
        Btnc => Btnc
    );
    
 AFF: Affichage port map (
        switches => tableau,
        clock_100Mhz => Clk,
        reset => reset_aff,
        Anode_activate => anode_activate,
        seg_o => seg_o
    );
    
 process(Clk, rst)
begin
        if(rst='1') then
            ten_second_counter <= (others => '0');
        elsif(rising_edge(clk)) then
            if(ten_second_counter>=10*x"5F5E0FF") then
                ten_second_counter <= (others => '0');
            else
                ten_second_counter <= ten_second_counter + "0000001";
            end if;
        end if;
end process;


---pour ne pas avoir en continu mais led apres led qui s'allume dans un delai de 1s chacun
ten_second_enable <= '1' when ten_second_counter=10*x"5F5E0FF" else '0';
process(clk, rst)
begin
        if(rst='1') then
            indice <= 0;
        elsif(rising_edge(clk)) then
             if(ten_second_enable='1') then
                if indice < 9 then indice <= indice + 1;
                else indice <= 0;
                end if;
             end if;
        end if;
end process;

process (indice,tableau,MemoryData)
begin
    if indice > -1 then
        tableau(15 downto 0) <= MemoryData(159-indice*16 downto 159-(indice+1)*16+1);
    end if;
end process;
end Behavioral;
