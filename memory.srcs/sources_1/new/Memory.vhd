library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
    Port (
        Clk : in STD_LOGIC;
        Rst : in STD_LOGIC;
        sw_i : in STD_LOGIC_VECTOR(15 downto 0);
        MemoryData : out STD_LOGIC_VECTOR(159 downto 0);
        led_o : out std_logic_vector(15 downto 0);
        Btnc : in STD_LOGIC
    );
end Memory;

architecture Behavioral of Memory is
    type MemoryArray is array (0 to 9) of STD_LOGIC_VECTOR(15 downto 0);
    signal memory : MemoryArray;
    signal counter : integer := 0; -- compteur d'indice en fonction du bouton Btnc
    signal exit_process : boolean := false; -- signal pour controler la terminaison
    
begin
led_o <= sw_i;
    -- assignation des valeurs dans la mémoire en fonction des switches
    process(sw_i,rst,btnc)
    begin
        if rst = '1' then
            -- remise à zéro de la mémoire
            for i in 0 to 9 loop
                memory(i) <= (others => '0');
            end loop;
            counter <= 0; -- Reset counter
            exit_process <= false; -- Reset exit flag
        elsif Btnc = '1' then
            -- incrémentation du compteur
            counter <= counter + 1;
            if counter < 10 then
                memory(counter) <= sw_i;
            end if;
         end if;
    end process;

-- mémoire
    MemoryData <= memory(0) & memory(1) & memory(2) & memory(3) & memory(4) & memory(5) & memory(6) & memory(7) & memory(8) & memory(9);
end Behavioral;

