library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Main_TB is
end Main_TB;

architecture behavioral of Main_TB is

component async_fifo is
    port (
        i_rstn          : in std_logic;
        i_rclk          : in std_logic;
        i_rd_en         : in std_logic;
        o_rdata         : out std_logic;
        i_wclk          : in std_logic;
        i_wdata         : in std_logic;
        o_err_wOnFull   : out std_logic;
        o_err_rOnEmpty  : out std_logic

    );
end component;


signal rd_clk_period    : time := 20 ns;
signal wr_clk_period    : time := 25 ns;
signal rd_clk           : std_logic;
signal wr_clk           : std_logic;
signal reset            : std_logic;
signal enable           : std_logic;
signal rd_data          : std_logic;
signal wr_data          : std_logic;
signal full             : std_logic;
signal empty            : std_logic;

signal counter_q        : std_logic_vector(3 downto 0);
signal counter_d        : std_logic_vector(3 downto 0);

begin 


    DUT : async_fifo port map(
        i_rstn          => reset,
        i_rclk          => rd_clk,
        i_rd_en         => enable,
        o_rdata         => rd_data,
        i_wclk          => wr_clk,
        i_wdata         => wr_data,
        o_err_wOnFull   => full,
        o_err_rOnEmpty  => empty
    );

    rd_clk_process :process
    begin
        rd_clk        <= '1';
        wait for rd_clk_period/2; 
        rd_clk        <= '0';
        wait for rd_clk_period/2; 
    end process; 
    wr_clk_process :process
    begin
        wr_clk        <= '1';
        wait for wr_clk_period/2; 
        wr_clk        <= '0';
        wait for wr_clk_period/2;
    end process; 
    rst_process :process
    begin
        reset       <= '0';
        wait for 100 ns;  
        reset       <= '1';
        enable      <= '1';
    end process; 

    counter_proc: process
    begin
        wait until rising_edge(wr_clk);
        counter_q   <= counter_d;
    end process;

    counter_d       <= counter_q + 1  when reset = '1' else '0';
    wr_data         <= counter_q(0);
end;
