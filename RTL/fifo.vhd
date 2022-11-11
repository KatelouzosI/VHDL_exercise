library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity async_fifo is
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
end entity async_fifo;

architecture rtl of async_fifo is
type data_type is array (0 to 4) of std_logic;
signal fifo_data_q  : data_type;

signal fifo_full    : std_logic;
signal fifo_empty   : std_logic;

signal wr_bin_cnt_d : std_logic_vector(2 downto 0);
signal wr_bin_cnt_q : std_logic_vector(2 downto 0);

signal rd_bin_cnt_d : std_logic_vector(2 downto 0);
signal rd_bin_cnt_q : std_logic_vector(2 downto 0);

begin
w_clk_proc: process (i_wclk, i_rstn, wr_bin_cnt_d) 
begin
    if (rising_edge(i_wclk)) then 
        if (i_rstn = '0') then
            wr_bin_cnt_q        <= "000";
        else
            wr_bin_cnt_q        <= wr_bin_cnt_d;
        end if;
    end if;
end process;
w_clk_proc_no_reset: process (i_wclk, i_wdata) 
begin
    if (rising_edge(i_wclk)) then 
        fifo_data_q(conv_integer( wr_bin_cnt_q))    <= i_wdata;
    end if;
end process;
r_clk_proc: process (i_rclk, i_rd_en, rd_bin_cnt_d) 
begin
    if (rising_edge(i_rclk) and i_rd_en ='1' ) then 
        if (i_rstn = '0') then
            rd_bin_cnt_q        <= "000";
        else
            rd_bin_cnt_q        <= rd_bin_cnt_d;
        end if;
    end if;
end process;

process(rd_bin_cnt_q)   
begin
        case rd_bin_cnt_q is      
            when "000"   => rd_bin_cnt_d <= "001"; 
            when "001"   => rd_bin_cnt_d <= "010";
            when "010"   => rd_bin_cnt_d <= "011";
            when "011"   => rd_bin_cnt_d <= "100";
            when others => rd_bin_cnt_d <= "000";
        end case;
end process;
process(wr_bin_cnt_q)   
begin
        case wr_bin_cnt_q is      
            when "000"   => wr_bin_cnt_d <= "001"; 
            when "001"   => wr_bin_cnt_d <= "010";
            when "010"   => wr_bin_cnt_d <= "011";
            when "011"   => wr_bin_cnt_d <= "100";
            when others => wr_bin_cnt_d <= "000";
        end case;
end process;


fifo_full       <= '1' when wr_bin_cnt_q = rd_bin_cnt_q else '0';
fifo_empty      <= '1' when wr_bin_cnt_q = rd_bin_cnt_q else '0';

o_err_wOnFull   <= fifo_full;
o_err_rOnEmpty  <= fifo_empty;

o_rdata         <= fifo_data_q(conv_integer(rd_bin_cnt_d));

end rtl;