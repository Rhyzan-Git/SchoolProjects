## This file is a general .xdc for the Cmod S7-25 Rev. B
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## 12 MHz System Clock
set_property -dict {PACKAGE_PIN M9 IOSTANDARD LVCMOS33} [get_ports sysClk]
create_clock -add -name sys_clk_pin -period 83.33 -waveform {0 41.66} [get_ports { sysClk }];

#create_clock -period 50000000.000 -name led_clock -waveform {0.000 25000000.000} -add [get_ports LEDclk]
#create_clock -period 83.333 -name sysClk -waveform {0.000 41.667} [get_ports sysClk]
#create_generated_clock -name LEDclk_OBUF -source [get_ports sysClk] -divide_by 600000 [get_pins LEDclk_reg/Q]

create_clock -period 33333333.333 -name led_clock -waveform {0.000 16666666.667} -add [get_ports LEDclk]
set_property IOSTANDARD LVCMOS33 [get_ports LEDclk]
set_property PACKAGE_PIN R14 [get_ports LEDclk]

create_clock -period 333333333.3 -name payout_clock -waveform {0.000 166666666.7} -add [get_ports payout_clk]
set_property IOSTANDARD LVCMOS33 [get_ports payout_clk]
set_property PACKAGE_PIN M10 [get_ports payout_clk]

#create_clock -period 10000.0 -name gen_clock -waveform {0.000 5000.0} -add [get_ports fastClk]
#set_property IOSTANDARD LVCMOS33 [get_ports fastClk]
#set_property PACKAGE_PIN R13 [get_ports fastClk]

## Push Buttons
#set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports player_stop]
#set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports coin_in]

## RGB LEDs
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports LED_OFF[0]]
set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS33} [get_ports LED_OFF[1]]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports LED_OFF[2]]

## 4 LEDs
#set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports testled2]
#set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports testled]
#set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports Rw2]
#set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports payout_clk]

## Pmod Header JA
#set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { ja[0] }]; #IO_L14P_T2_SRCC_34 Sch=ja[1]
#set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { ja[1] }]; #IO_L14N_T2_SRCC_34 Sch=ja[2]
#set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]; #IO_L13P_T2_MRCC_34 Sch=ja[3]
#set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]; #IO_L11N_T1_SRCC_34 Sch=ja[4]
#set_property -dict { PACKAGE_PIN H3    IOSTANDARD LVCMOS33 } [get_ports { ja[4] }]; #IO_L13N_T2_MRCC_34 Sch=ja[7]
#set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { ja[5] }]; #IO_L12P_T1_MRCC_34 Sch=ja[8]
#set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]; #IO_L12N_T1_MRCC_34 Sch=ja[9]
#set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]; #IO_L11P_T1_SRCC_34 Sch=ja[10]

## USB UART
## Note: Port names are from the perspoctive of the FPGA.
#set_property -dict { PACKAGE_PIN L12   IOSTANDARD LVCMOS33 } [get_ports { uart_tx }]; #IO_L6N_T0_D08_VREF_14 Sch=uart_rxd_out
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { uart_rx }]; #IO_L5N_T0_D07_14 Sch=uart_txd_in

## Analog Inputs on PIO Pins 32 and 33
#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { vaux5_p }]; #IO_L12P_T1_MRCC_AD5P_15 Sch=ain_p[32]
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { vaux5_n }]; #IO_L12N_T1_MRCC_AD5N_15 Sch=ain_n[32]
#set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports { vaux12_p }]; #IO_L11P_T1_SRCC_AD12P_15 Sch=ain_p[33]
#set_property -dict { PACKAGE_PIN A12   IOSTANDARD LVCMOS33 } [get_ports { vaux12_n }]; #IO_L11N_T1_SRCC_AD12N_15 Sch=ain_n[33]

## Dedicated Digital I/O on the PIO Headers
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports { Clm0 }]; #pio1
set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports { Clm1 }]; #pio2
set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports { Clm2 }]; #pio3
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports { Clm3 }]; #pio4
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports { Clm4 }]; #pio5
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports { Clm5 }]; #pio6
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports { Clm6 }]; #pio7
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports { Clm7 }]; #pio8
set_property -dict { PACKAGE_PIN N1    IOSTANDARD LVCMOS33 } [get_ports { payout_LED }]; #IO_L22N_T3_34 Sch=pio[09]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { disp[0] }]; #IO_L11P_T1_SRCC_14 Sch=pio[16]
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { disp[1] }]; #IO_L11N_T1_SRCC_14 Sch=pio[17]
set_property -dict { PACKAGE_PIN N13   IOSTANDARD LVCMOS33 } [get_ports { disp[2] }]; #IO_L8N_T1_D12_14 Sch=pio[18]
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { disp[3] }]; #IO_L10N_T1_D15_14 Sch=pio[19]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { disp[4] }]; #IO_L10P_T1_D14_14 Sch=pio[20]
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { disp[5] }]; #IO_L9N_T1_DQS_D13_14 Sch=pio[21]
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { disp[6] }]; #IO_L9P_T1_DQS_14 Sch=pio[22]
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { seg[0] }]; #IO_L4N_T0_D05_14 Sch=pio[23]
set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { seg[1] }]; #IO_L7N_T1_D10_14 Sch=pio[26]
set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { seg[2] }]; #IO_L4P_T0_D04_14 Sch=pio[27]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { seg[3] }]; #IO_L5P_T0_D06_14 Sch=pio[28]
set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS33 } [get_ports { seg[4] }]; #IO_L7P_T1_D09_14 Sch=pio[29]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { seg[5] }]; #IO_L8P_T1_D11_14 Sch=pio[30]
set_property -dict { PACKAGE_PIN J11   IOSTANDARD LVCMOS33 } [get_ports { seg[6] }]; #IO_0_14 Sch=pio[31]
#set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports { pio40 }]; #IO_L5P_T0_34 Sch=pio[40]
#set_property -dict { PACKAGE_PIN A2    IOSTANDARD LVCMOS33 } [get_ports { pio41 }]; #IO_L2N_T0_34 Sch=pio[41]
set_property -dict { PACKAGE_PIN B2    IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L2P_T0_34 Sch=pio[42]
set_property -dict { PACKAGE_PIN B1    IOSTANDARD LVCMOS33 } [get_ports { player_stop }]; #IO_L4N_T0_34 Sch=pio[43]
set_property -dict { PACKAGE_PIN C1    IOSTANDARD LVCMOS33 } [get_ports { coin_in }]; #IO_L4P_T0_34 Sch=pio[44]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports { Rw3 }]; #pio45
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports { Rw2 }]; #pio46
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports { Rw1 }]; #pio47
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports { Rw0 }]; #pio48

## Quad SPI Flash
## Note: QSPI clock can only be accessed through the STARTUPE2 primitive
#set_property -dict { PACKAGE_PIN L11   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_cs
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_dq[0]
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_dq[1]
#set_property -dict { PACKAGE_PIN J12   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
#set_property SEVERITY {Warning}[get_drc_checks NSTD-1]
