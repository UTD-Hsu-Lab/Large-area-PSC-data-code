


load_library extract
lib::SetInfoDef 1

set n 9297
set Psolar [expr 100]	;# Intensity [mW/cm2] of am1.5g spectrum
set Xlen 2210
set mobility 200

set cntlen 0.01
set areafactor [expr 1e12/($Xlen*(1+2*$cntlen))]
echo "af = $areafactor \[cm^2\]"
load_file n9296_des.plt -name Plt_IV

echo "plotting I-V & P-V curves"
create_plot -1d -name PlotIV
select_plots {PlotIV}
create_curve -name v -dataset Plt_IV -axisX "pContact OuterVoltage" -axisY "pContact OuterVoltage"
create_curve -name j_orig -dataset Plt_IV -axisX "pContact OuterVoltage" -axisY "nContact TotalCurrent"
create_curve -name j -function "<j_orig>*$areafactor"
create_curve -name P -function "<j>*<v>"

set_curve_prop j -label "I-V Curve" -color blue -line_style solid  \
	-line_width 3 -show_markers -markers_type circle -markers_size 10
set_curve_prop P -label "P-V Curve" -color red -line_style solid  \
	-line_width 3 -show_markers -markers_type square -markers_size 10 -axis right

set_axis_prop -axis x -title {Voltage [V]} -title_font_size 16 \
	-scale_font_size 14 -type linear 
set_axis_prop -axis y -title {Current Density [mA/cm<sup>2</sup>]} \
	-title_font_size 16 -scale_font_size 14 -type linear 
set_axis_prop -axis y2 -title {Power Density [mW/cm<sup>2</sup>]} \
	-title_font_size 16 -scale_font_size 14 -type linear 

set_plot_prop -title "Light I-V & P-V curves" -title_font_size 20
set_legend_prop -location bottom_left -font_size 12 -font_att bold

echo "extracting PV parameters"	
echo "extracting Jsc (mA/cm2) & Voc (V)"	
set Js [get_curve_data j -axisY] 
set Vs [get_curve_data j -axisX] 
set Ps [get_curve_data P -axisY]

ext::ExtractValue -out Jsc -name "out" -x $Vs -y $Js -xo 0.0 -f "%.4g"
ext::ExtractValue -out Voc -name "out" -x $Js -y $Vs -xo 0.0 -f "%.4g"
echo "Jsc=[format %.4g $Jsc] \[mA/cm^2\]" 
echo "Voc=[format %.4g $Voc] \[V\]"

echo "extracting Pmpp (mW/cm2), Jmpp (mA/cm2) & Vmpp (V)"	
ext::ExtractExtremum -out Pmpp -name "out" 	   -x $Vs -y $Ps -extremum "max" -f "%.4g"
ext::ExtractValue 	 -out Vmpp -name "out" -x $Ps -y $Vs -xo $Pmpp 	 	 
ext::ExtractValue 	 -out Jmpp -name "out" -x $Vs -y $Js -xo $Vmpp 	 	 
echo "Vmpp=[format %.4g $Vmpp] \[V\]"
echo "Jmpp=[format %.4g $Jmpp] \[mA/cm^2\]"
echo "Pmpp=[format %.4g $Pmpp] \[mW/cm^2\]"

echo "extracting Fill Factor (%) and power efficiency (%)"	
set FF [expr $Pmpp/($Voc*$Jsc)*100]
echo "FF=[format %.2f $FF] \%"
set Eff [expr $Pmpp/$Psolar*100]
echo "Eff=[format %.3f $Eff] \%"

echo "writing values to SWB"
puts "DOE: FF [format %.2f $FF]"
puts "DOE: Eff [format %.3f $Eff]"

echo "extracting Rsh (kohm) & Rs (ohm)"	
	echo "js = $Js"
	set index_rs 0
	echo "$index_rs"
	while {[lindex $Js $index_rs] > 0} {
			incr index_rs	
	}

	echo "index = $index_rs"

	set dj [expr [lindex $Js $index_rs-1] - [lindex $Js $index_rs]] 
	set dv [expr [lindex $Vs $index_rs] - [lindex $Vs $index_rs-1]]
	echo "dj = $dj"
	echo "dv = $dv"

	set Rs [expr 1000*$dv/$dj]
	set Rsh [expr [lindex $Vs 1]/($Jsc-[lindex $Js 1])]

	echo "Rsh=[format %.4g $Rsh] \[V/A\]" 
	echo "Rs=[format %.4g $Rs] \[V/A\]"

	puts "DOE: Rsh [format %.3f $Rsh]"
	puts "DOE: Rs [format %.3f $Rs]"


	set fp [open  "/jumbo/scheidelerlab/Vann/pin_resistivity_2d_mobility/text_output_2.txt" a ] 

	puts  $fp "JV-Curve\n $mobility size $Xlen" 
	puts  $fp $Vs 
	puts  $fp $Js 

export_curves {j} -plot PlotIV -filename /jumbo/scheidelerlab/Vann/pin_resistivity_lowRecomb/n${n}_iv_original.csv -format csv -overwrite
remove_curves "v j_orig"



