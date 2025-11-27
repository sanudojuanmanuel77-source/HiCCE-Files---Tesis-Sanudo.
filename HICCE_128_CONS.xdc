##########################################################
# CONECTOR FMC. VINCULA EL HICCE CON EL ZEDBOARD.
##########################################################

# INTAN Chip, Digital Control Signals
#set_property PACKAGE_PIN R19 [get_ports {Elec_Test_0[3]}]
#set_property PACKAGE_PIN E15 [get_ports {Elec_Test_0[2]}]
#set_property PACKAGE_PIN F19 [get_ports {Elec_Test_0[1]}]
#set_property PACKAGE_PIN T17 [get_ports {Elec_Test_0[0]}]

#set_property PACKAGE_PIN E21 [get_ports {Elec_Test_en_0[3]}]
#set_property PACKAGE_PIN M20 [get_ports {Elec_Test_en_0[2]}]
#set_property PACKAGE_PIN B16 [get_ports {Elec_Test_en_0[1]}]
#set_property PACKAGE_PIN E20 [get_ports {Elec_Test_en_0[0]}]
#
# Conectados a constente 0...
set_property PACKAGE_PIN D21 [get_ports {Conn_All_0[3]}]
set_property PACKAGE_PIN N22 [get_ports {Conn_All_0[2]}]
set_property PACKAGE_PIN B17 [get_ports {Conn_All_0[1]}]
set_property PACKAGE_PIN A18 [get_ports {Conn_All_0[0]}]

set_property PACKAGE_PIN N19 [get_ports {settle_3}]
set_property PACKAGE_PIN P22 [get_ports {settle_2}]
set_property PACKAGE_PIN B21 [get_ports {settle_1}]
set_property PACKAGE_PIN A19 [get_ports {settle_0}]

set_property PACKAGE_PIN N20 [get_ports {Sel0_Reset_0[3]}]
set_property PACKAGE_PIN J21 [get_ports {Sel0_Reset_0[2]}]
set_property PACKAGE_PIN B22 [get_ports {Sel0_Reset_0[1]}]
set_property PACKAGE_PIN A16 [get_ports {Sel0_Reset_0[0]}]

set_property PACKAGE_PIN J18 [get_ports {STEP_3}]
set_property PACKAGE_PIN J22 [get_ports {STEP_2}]
set_property PACKAGE_PIN P17 [get_ports {STEP_1}]
set_property PACKAGE_PIN A17 [get_ports {STEP_0}]

#set_property PACKAGE_PIN K18 [get_ports {Sel2_Sync_0[3]}]
#set_property PACKAGE_PIN P20 [get_ports {Sel2_Sync_0[2]}]
#set_property PACKAGE_PIN P18 [get_ports {Sel2_Sync_0[1]}]
#set_property PACKAGE_PIN C15 [get_ports {Sel2_Sync_0[0]}]

set_property PACKAGE_PIN R20 [get_ports {Sel3_0[3]}]
set_property PACKAGE_PIN P21 [get_ports {Sel3_0[2]}]
set_property PACKAGE_PIN M21 [get_ports {Sel3_0[1]}]
set_property PACKAGE_PIN B15 [get_ports {Sel3_0[0]}]

set_property PACKAGE_PIN R21 [get_ports {Sel4_0[3]}]
set_property PACKAGE_PIN J20 [get_ports {Sel4_0[2]}]
set_property PACKAGE_PIN M22 [get_ports {Sel4_0[1]}]
set_property PACKAGE_PIN A21 [get_ports {Sel4_0[0]}]

set_property PACKAGE_PIN L17 [get_ports {Mode_0[3]}]
set_property PACKAGE_PIN K21 [get_ports {Mode_0[2]}]
set_property PACKAGE_PIN T16 [get_ports {Mode_0[1]}]
set_property PACKAGE_PIN A22 [get_ports {Mode_0[0]}]

# ADC_AD7982 Interface
set_property PACKAGE_PIN K20 [get_ports {sdo_3}]
set_property PACKAGE_PIN F18 [get_ports {sdo_2}]
set_property PACKAGE_PIN C22 [get_ports {sdo_1}]
set_property PACKAGE_PIN G15 [get_ports {sdo_0}]

set_property PACKAGE_PIN D20 [get_ports {cnv_3}]
set_property PACKAGE_PIN E18 [get_ports {cnv_2}]
set_property PACKAGE_PIN C17 [get_ports {cnv_1}]
set_property PACKAGE_PIN G16 [get_ports {cnv_0}]

set_property PACKAGE_PIN C20 [get_ports {sck_3}]
set_property PACKAGE_PIN M19 [get_ports {sck_2}]
set_property PACKAGE_PIN C18 [get_ports {sck_1}]
set_property PACKAGE_PIN E19 [get_ports {sck_0}]

#HiCEE BOARD LEDs (A AND B)
#set_property PACKAGE_PIN B20 [get_ports {LED_HiCCE_AB_0[0]}]
#set_property PACKAGE_PIN B19 [get_ports {LED_HiCCE_AB_0[1]}]

#------------------------------------------------------------------------------
#set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_0[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_0[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_0[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_0[0]}]

#set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_en_0[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_en_0[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_en_0[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_en_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Conn_All_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Conn_All_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Conn_All_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Conn_All_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {settle_3}]
set_property IOSTANDARD LVCMOS33 [get_ports {settle_2}]
set_property IOSTANDARD LVCMOS33 [get_ports {settle_1}]
set_property IOSTANDARD LVCMOS33 [get_ports {settle_0}]

set_property IOSTANDARD LVCMOS33 [get_ports {Sel0_Reset_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel0_Reset_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel0_Reset_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel0_Reset_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {STEP_3}]
set_property IOSTANDARD LVCMOS33 [get_ports {STEP_2}]
set_property IOSTANDARD LVCMOS33 [get_ports {STEP_1}]
set_property IOSTANDARD LVCMOS33 [get_ports {STEP_0}]

#set_property IOSTANDARD LVCMOS33 [get_ports {Sel2_Sync_0[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Sel2_Sync_0[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Sel2_Sync_0[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Sel2_Sync_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Sel3_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel3_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel3_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel3_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Sel4_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel4_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel4_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel4_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Mode_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Mode_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Mode_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Mode_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {sdo_3}]
set_property IOSTANDARD LVCMOS33 [get_ports {sdo_2}]
set_property IOSTANDARD LVCMOS33 [get_ports {sdo_1}]
set_property IOSTANDARD LVCMOS33 [get_ports {sdo_0}]

set_property IOSTANDARD LVCMOS33 [get_ports {cnv_3}]
set_property IOSTANDARD LVCMOS33 [get_ports {cnv_2}]
set_property IOSTANDARD LVCMOS33 [get_ports {cnv_1}]
set_property IOSTANDARD LVCMOS33 [get_ports {cnv_0}]

set_property IOSTANDARD LVCMOS33 [get_ports {sck_3}]
set_property IOSTANDARD LVCMOS33 [get_ports {sck_2}]
set_property IOSTANDARD LVCMOS33 [get_ports {sck_1}]
set_property IOSTANDARD LVCMOS33 [get_ports {sck_0}]

#set_property IOSTANDARD LVCMOS33 [get_ports {LED_HiCCE_AB_0[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_HiCCE_AB_0[0]}]

##------------------------------------------------------------------------------------------------

