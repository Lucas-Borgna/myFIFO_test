----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2018 01:46:09 PM
-- Design Name: 
-- Module Name: FIFO - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is
--  Port ( ); 
    GENERIC (
        CONSTANT DATA_WIDTH : POSITIVE := 8;
        CONSTANT FIFO_DEPTH : POSITIVE := 256;
    );
    PORT (
        CLK         : IN STD_LOGIC;
        RST         : IN STD_LOGIC;
        WriteEn     : IN STD_LOGIC; -- Write enable sometimes also called the strobe
        DataIn      : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
        ReadEn      : IN STD_LOGIC;
        DataOut     : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
        Empty       : OUT STD_LOGIC;
        Full        : OUT STD_LOGIC
    );
    
end FIFO;

architecture Behavioral of FIFO is

begin

    --Memory Pointer Process
    fifo_proc : process(CLK)
        type FIFO_Memory is array (0 to FIFO_DEPTH - 1) of STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
        VARIABLE Memory : FIFO_Memory;
        
        VARIABLE Head : NATURAL RANGE 0 TO FIFO_DEPTH - 1;
        VARIABLE Tail : NATURAL RANGE 0 TO FIFO_DEPTH - 1;

        VARIABLE Looped : BOOLEAN;

    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF RST = '1' THEN
                Head := 0;
                Tail := 0;
                
                Looped := false;
                
            ELSE
                Tail := Tail + 1;
            END IF;
        END IF;
        
        IF (WriteEn = '1') THEN
            IF ((Looped = false) OR (Head /= Tail)) THEN
                --Write Data To Memory
                Memory(Head) := DataIn;
                
                -- Increment Head Pointer as needed
                IF (Head = FIFO_DEPTH - 1) THEN
                    Head := 0;
                    
                    Looped := true;
                ELSE
                    Head := Head + 1;
                END IF;
             END IF;
          END IF;
          
        -- Update Empty and Full Flags
        IF (Head = Tail) THEN
            IF Looped THEN
                Full <= '1';
            ELSE
                Empty <= '1';
            END IF;
        ELSE
            Empty <= '0';
            Full <='0';
        END IF;
     END IF;
  END IF;
END PROCESS;  

end Behavioral;
