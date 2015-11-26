##########################################################
# Define offsets
##########################################################
set led_offset   0
set pwm_offset   1
set addr_offset  5
set avg_offset   6

##########################################################
# Define parameters
##########################################################
set bram_addr_width 13
set pwm_width       10
set n_pwm           4

set bram_size [expr 2**($bram_addr_width-8)]K

source boards/$board_name/base_system.tcl

source projects/averaging.tcl

###########################################################
# Add ADC BRAMs
###########################################################
for {set i 0} {$i < 2} {incr i} {
  set channel [lindex {a b} $i]
  set adc_bram_name adc${i}_bram
  set avg_name      avg$i
  add_bram $adc_bram_name $bram_size
  # Connect port B of BRAM to ADC clock
  connect_constant ${adc_bram_name}_enb 1 1 blk_mem_gen_$adc_bram_name/enb
  connect_pins blk_mem_gen_$adc_bram_name/clkb    $adc_clk
  connect_pins blk_mem_gen_$adc_bram_name/addrb   $address_name/addr_delayed
  connect_pins blk_mem_gen_$adc_bram_name/rstb    $rst_name/peripheral_reset

  # Add averaging module
  add_averaging_module $avg_name $bram_addr_width $adc_width $adc_clk

  connect_pins $avg_name/start       $address_name/start
  connect_pins $avg_name/cfg         $config_name/Out[expr $avg_offset + $i]
  connect_pins $avg_name/data_in     adc_dac/adc[expr $i + 1]
  connect_pins $avg_name/addr        $address_name/addr
  connect_pins $avg_name/data_out    blk_mem_gen_$adc_bram_name/dinb
  connect_pins $avg_name/wen         blk_mem_gen_$adc_bram_name/web
  connect_pins $avg_name/count_cycle sts/In$i
}
