
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.ALL;


entity test_top is
end test_top;

architecture Behavioral of test_top is
    
    
  component uart_top 
  generic(
	clk_freq  :  integer := 50_000_000
);
      port (
              i_clk                :   in  std_logic;
              i_sys_rst            :   in  std_logic;
              switch               :   in std_logic_vector(2 downto 0);
              o_tx                 :   out std_logic; 
              i_rx                 :   in  std_logic 
              );
   end component;
 
        signal i_clk               : std_logic := '0';
        signal o_tx                : std_logic   := '0';
        signal i_rx                : std_logic   := '0';
        signal i_sys_rst           : std_logic ;
        signal switch              : std_logic_vector(2 downto 0):="011"; 
        signal clk_freq            : integer:=50_000_000;

        constant CLK_PERIOD 		   : time:=  1sec/ clk_freq;
        constant c_BIT_PERIOD 	   : time := 8680 ns;


procedure WRITE_BYTE( 
        byte_in       : in STD_LOGIC_VECTOR(7 downto 0);
        signal data_o : out STD_LOGIC
    ) is
    begin
    		data_o <= '1';
    		wait for c_BIT_PERIOD; 
        data_o <= '0';
        wait for c_BIT_PERIOD;
        for i in 0 to 7 loop 
            data_o <= byte_in(i);
            wait for c_BIT_PERIOD;
        end loop;
        data_o <= '1'; 
        wait for c_BIT_PERIOD;
    end procedure;
                        
begin


testbench_uart :  uart_top
        port map (
                i_clk            => i_clk,
                i_sys_rst        => i_sys_rst,
                switch           => switch,
                o_tx	           => o_tx,
                i_rx             => i_rx
      );
 
p_clk : process begin             
                 i_clk         <= '0';
                 wait for CLK_PERIOD/2;
                 i_clk         <= '1';
                 wait for CLK_PERIOD/2;    
end process p_clk;               
p_rst : process begin
                 i_sys_rst     <= '1';
                 wait for 10*CLK_PERIOD;
                 i_sys_rst     <= '0';
                 wait;
end process p_rst;

p_tx_test : process 
begin                               
 
  wait until rising_edge(i_clk);
  wait until rising_edge(i_clk);
  WRITE_BYTE(x"AA", i_rx);
	wait for 10*CLK_PERIOD;
  
   wait;
             
end process;      
end Behavioral;
