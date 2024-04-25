library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Affichage is
    Port ( switches : in STD_LOGIC_VECTOR (15 downto 0);
           clock_100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           Anode_activate : out STD_LOGIC_VECTOR (3 downto 0);
           seg_o : out STD_LOGIC_VECTOR (6 downto 0));
end Affichage;

architecture Behavioral of Affichage is

signal refresh_counter: unsigned (19 downto 0); -- creating 10.5ms refresh period
signal one_second_counter: unsigned (27 downto 0);-- counter for generating 1-second clock enable
signal one_second_enable: std_logic; -- one second enable for counting numbers pour le clignotement
signal compteur_serie: unsigned(1 downto 0);

signal LED_BCD: STD_LOGIC_VECTOR (3 downto 0); --4 bits (des 16 valeurs de la serie) a afficher
signal LED_activating_counter: unsigned(1 downto 0); -- count 0 to 3 to activate LED1 to LED4
---- signal memoire: std_logic_vector(159 downto 0);

begin
---------------BEGIN BEHAVIORAL

process(LED_BCD) --pour le led_bcd (les 4 des 16 bits a afficher)
begin
    case LED_BCD is
    when "0000" => seg_o <= "0000001"; -- "0"    
    when "0001" => seg_o  <= "1001111"; -- "1"
    when "0010" => seg_o  <= "0010010"; -- "2"
    when "0011" => seg_o  <= "0000110"; -- "3"
    when "0100" => seg_o  <= "1001100"; -- "4"
    when "0101" => seg_o  <= "0100100"; -- "5"
    when "0110" => seg_o  <= "0100000"; -- "6"
    when "0111" => seg_o  <= "0001111"; -- "7"
    when "1000" => seg_o  <= "0000000"; -- "8"    
    when "1001" => seg_o  <= "0000100"; -- "9"
    when "1010" => seg_o  <= "0000010"; -- a
    when "1011" => seg_o <= "1100000"; -- b
    when "1100" => seg_o <= "0110001"; -- C
    when "1101" => seg_o <= "1000010"; -- d
    when "1110" => seg_o <= "0110000"; -- E
    when "1111" => seg_o <= "0111000"; -- F
    end case;
end process;
 
process(LED_activating_counter)
begin
    case LED_activating_counter is
    when "00" =>
        Anode_Activate <= "0111";
        -- activate LED1 and Deactivate LED2, LED3, LED4
        LED_BCD <= switches(15 downto 12);
    when "01" =>
        Anode_Activate <= "1011";
        -- activate LED2 and Deactivate LED1, LED3, LED4
        LED_BCD <= switches(11 downto 8);
    when "10" =>
        Anode_Activate <= "1101";
        -- activate LED3 and Deactivate LED2, LED1, LED4
        LED_BCD <= switches(7 downto 4);
    when "11" =>
        Anode_Activate <= "1110";
        -- activate LED4 and Deactivate LED2, LED3, LED1
        LED_BCD <= switches(3 downto 0);
    end case;
end process;

-- Counting the number to be displayed on 4-digit 7-segment Display on Basys 3 FPGA board
process(clock_100Mhz, reset)
begin
        if(reset='1') then
            one_second_counter <= (others => '0');
        elsif(rising_edge(clock_100Mhz)) then
            if(one_second_counter>=x"5F5E0FF") then
                one_second_counter <= (others => '0');
            else
                one_second_counter <= one_second_counter + "0000001";
            end if;
        end if;
end process;


---pour ne pas avoir en continu mais led apres led qui s'allume dans un delai de 1s chacun
one_second_enable <= '1' when one_second_counter=x"5F5E0FF" else '0';
process(clock_100Mhz, reset)
begin
        if(reset='1') then
            LED_activating_counter <= "00";
        elsif(rising_edge(clock_100Mhz)) then
             if(one_second_enable='1') then
                if LED_activating_counter < 3 then LED_activating_counter <= LED_activating_counter + 1;
                else LED_activating_counter <= "00";
                end if;
             end if;
        end if;
end process;

end Behavioral;
