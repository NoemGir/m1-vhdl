---------------------------------------
-- Pulse generator test architecture
--
-- For GHDL users:
-- ghdl -a --ieee=synopsys -fexplicit pulse_gen.vhd test_pulse_gen.vhd
-- ghdl -e --ieee=synopsys -fexplicit test_pulse_gen
-- ghdl -r --ieee=synopsys -fexplicit test_pulse_gen --wave=test_pulse_gen.ghw
-- gtkwave test_pulse_gen.ghw
--
-- F.Thiebolt
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- component definition
entity test_pulse_gen is
end test_pulse_gen;

-- architecture definition
architecture behaviour of test_pulse_gen is

    -- constant defintions
	constant TIMEOUT 	: time := 2500 ms; -- simulation timeout
    constant clkpulse   : time := 500 ns; -- 1/2 periode horloge

    -- types/subtypes definitions

    -- signal definitions
    signal E_CLK,E_P    : std_logic; -- on creer des signaux 
    signal E_RST        : std_logic; -- active low

begin

--------------------------
-- definition de l'horloge
P_E_CLK: process -- 
begin
	E_CLK <= '1';
	wait for clkpulse;
	E_CLK <= '0';
	wait for clkpulse;
end process P_E_CLK;

-----------------------------------------
-- definition du timeout de la simulation
P_TIMEOUT: process -- très important !! sinon ca ne s'arrète jamais, le faire quand il y a une clock
begin
	wait for TIMEOUT;
	assert FALSE report "SIMULATION TIMEOUT!!!" severity FAILURE;
end process P_TIMEOUT;

--------------------------------------------------
-- instantiation et mapping du composant registres
pgen0 : entity work.pulse_gen(behaviour)
			generic map (10) -- veux dire que max-cpt = 10 pour pas vraiment attendre 1 s. 
			-- attention le prof fait expres de le mettre en commentaire
			port map (MCLK => E_CLK, -- assigne signaux ( MCLOCK, RST, P ) a un port ( E_CLK, E_RST, E_P) définis avant
                        RST => E_RST, -- dans pulse_gen on va voir MCLK et RST et P 
                        P => E_P);

-----------------------------
-- Test process
P_TEST: process -- pas de liste de sensibilité donc demmare tout de suite 
begin

	-- initialisations
	E_RST <= '0';
--  E_CLK <= '0'; -- DON'T DO THAT ... because un meme signal est drivé par different process et que tous les deux envoient en meme temps une valeur forte
-- attention si deux process ecrivent dans le meme signal, possible si un des deux fait un ADR <= (others => 'Z') 
-- met valeur faible a ADR donc l'autre peut l'utiliser ??

	-- sequence RESET
	E_RST <= '0';
	wait for clkpulse*3;
	E_RST <= '1';
	wait for clkpulse/2;

    -- wait for pulse output
	wait until (E_P='1'); 
	-- wait until fait deux choses :
		-- 1) attend qu'il y ait un evenement sur le signal,
		-- 2) puis vérifie la condition

    -- wait for pulse output
	wait until (E_P='1');

	-- ADD NEW SEQUENCE HERE

	-- LATEST COMMAND (NE PAS ENLEVER !!!)
	wait until (E_CLK='0'); wait for clkpulse*3;
	assert FALSE report "FIN DE SIMULATION" severity FAILURE;

end process P_TEST;

end behaviour;

