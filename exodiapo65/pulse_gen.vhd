--------------------------------------------------------------------------------
-- Pulse generator
-- F.Thiebolt
--------------------------------------------------------------------------------

-- library definitions
library ieee;

-- library uses
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


-- Component definition
entity pulse_gen is
	generic( MAX_CPT : natural := 1E6 ); -- 1 exposant 6 = 1 000 000
	port (
		RST, MCLK: in std_logic;
        P : out std_logic
    );

end pulse_gen;

-- architecture definition
architecture behaviour of pulse_gen is

begin

ppulse: process(MCLK) --RST et MCLK dans la liste de sensibilité ( = process evalué quand un des deux est changé ) 
    variable cpt: natural range 0 to MAX_CPT - 1 ; -- cpt est un entier qui va avoir comme valeur entre 0 et  999 999 ( inclu ) 
begin
    if rising_edge(MCLK) then
        if( RST='0' ) then
            cpt:=0;
            P <= '0';
        else
    	   p <= '0'; -- si on le ne met pas dans tous les cas alors ca va creer un latch pour se rappeler de la valeur qu'il avait avant
            if cpt = 0 then 
                P <= '1';
            end if;
            if cpt = MAX_CPT -1 then
                cpt := 0;
            else
                cpt := cpt + 1;
            end if;
        end if;
	end if;
end process ppulse;

end behaviour;

