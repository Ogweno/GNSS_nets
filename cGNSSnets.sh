#!/bin/bash
#plot network forseismo platform
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {
	echo "/******************************************************************************/"
	echo " Program Name : cGNSSnets.sh"
	echo " Version : v-1.0"
	echo " Purpose : Plot cGNSS network stations"
	echo " Usage   : cGNSSnets.sh -r region |  | -o [output] | -jpg "
	echo " Switches: "
	echo "	-r [:= region] region to plot [saegean, sant, extsant]"
	echo "		default : greece region"
	echo "		sant : santorini"
	echo "		extsant : extented santorini"
	echo "		saegean : South aegean region "
	echo "		grCyprus: greece + cyprus"
	echo "	-mt [:= map title] title map default none use quotes"
	echo "	-fgnss : use file for gps inform (*network*.sites)"
	echo "	-dbgnss: use database for gps information"
	echo ""
	echo "/*** NETWORKS  PLOTS **********************************************************/"
	echo "	-ggr [:= gps greece] Plot GPS Stations"
	echo "	-gsa [:= gps santorini] "
	echo "	-gur [:= gps uranus] "
	echo "	-gme [:= gps mterica] "
	echo "  -ghp [:= gps hepos] "
	echo ""
	echo "/*** OTHER OPRTIONS ************************************************************/"
        echo "	-topo [:=topography] use dem for background"
	echo "	-o [:= output] name of output files"
	echo "	-l [:=labels] plot labels"
        echo "	-leg [:=legend] insert legends"
	echo "	-jpg : convert eps file to jpg"
	echo "	-h [:= help] help menu"
	echo " Exit Status:    1 -> help message or error"
	echo " Exit Status:    0 -> sucesseful exit"
	echo ""
	echo "run:"
	echo "/******************************************************************************/"
	exit 1
}

# //////////////////////////////////////////////////////////////////////////////
# GMT parameters
gmtset MAP_FRAME_TYPE fancy
gmtset PS_PAGE_ORIENTATION portrait
gmtset FONT_ANNOT_PRIMARY 10 FONT_LABEL 10 MAP_FRAME_WIDTH 0.12c FONT_TITLE 18p
# gmtset PS_MEDIA 29cx21c

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for bash script
REGION="greece"
TOPOGRAPHY=0
LABELS=0
OUTJPG=0
LEGEND=0

GNET_GREECE=0
GNET_SANT=0
GNET_URANUS=0
GNET_METRICA=0
GNET_HEPOS=0

FGNSS=0
DBGNSS=0

if [ ! -f "gmtparam" ]
then
	echo "gmtparam file does not exist"
	exit 1
else
	source gmtparam
fi

# //////////////////////////////////////////////////////////////////////////////
# Set PATHS parameters
# pth2dems=${HOME}/Map_project/dems

# # //////////////////////////////////////////////////////////////////////////////
# # Set FILE parameters
# greece_sta=greece.sites
# sant_sta=santorini.sites
# uranus_sta=uranus.sites
# metrica_sta=metrica.sites
# gps_sta=${pth2nets}/net-gps.est
# gps_fsta=${pth2nets}/net-gps.fut
# seism_sta=${pth2nets}/net-seism.est
# seism_fsta=${pth2nets}/net-seism.fut
# accel_sta=${pth2nets}/net-accel.est
# accel_fsta=${pth2nets}/net-accel.fut
# tg_sta=${pth2nets}/net-tg.est
# tg_fsta=${pth2nets}/net-tg.fut

# # //////////////////////////////////////////////////////////////////////////////
# # Set Network Style Ploting
# gr_style="-St0.28c -W0.01c/0 -Gred"
# sa_style="-St0.25c -W0.01c/0 -Ggreen"
# ur_style="-St0.24c -W0.01c/0 -Gblue"
# me_style="-St0.20c -W0.01c/0 -Gblack"


# # //////////////////////////////////////////////////////////////////////////////
# # Pre-defined parameters for GMT
# outfile=test.eps
# out_jpg=test.jpg
# inputTopoL=${pth2dems}/ETOPO1_Bed_g_gmt4.grd
# inputTopoB=${pth2dems}/ETOPO1_Bed_g_gmt4.grd
# #inputTopoL=$HOME/Map_project/dems/ETOPO1_Bed_g_gmt4.grd
# #inputTopoB=$HOME/Map_project/dems/ETOPO1_Bed_g_gmt4.grd
# # frame=2
# # scale=-Lf20/34.5/36:24/100+l+jr
# # range=-R19/29/34/42
# # proj=-Jm24/37/1:6000000
# landcpt=land_man.cpt
# bathcpt=bath_man.cpt
# maptitle=""
# pth2logos=$HOME/Map_project/logos



# //////////////////////////////////////////////////////////////////////////////
# GET COMMAND LINE ARGUMENTS
if [ "$#" == "0" ]
then
	help
fi

while [ $# -gt 0 ]
do
	case "$1" in
		-r)
			REGION=$2
			shift
			shift
			;;
		-mt)
			maptitle=$2
			shift
			shift
			;;
		-fgnss)
			FGNSS=1
			shift
			;;
		-dbgnss)
			DBGNSS=1
			shift
			;;
		-ggr)
			GNET_GREECE=1
			shift
			;;
		-gsa)
			GNET_SANT=1
			shift
			;;
		-gur)
			GNET_URANUS=1
			shift
			;;
		-gme)
			GNET_METRICA=1
			shift
			;;
		-ghp)
			GNET_HEPOS=1
			shift
			;;
		-topo)
#                       switch topo not used in server!
			TOPOGRAPHY=1
			shift
			;;
		-o)
			outfile=${2}.eps
			out_jpg=${2}.jpg
			shift
			shift
			;;
		-l)
			LABELS=1
			shift
			;;
		-leg)
			LEGEND=1
			shift
			;;
		-jpg)
			OUTJPG=1
			shift
			;;
		-h)
			help
			;;
	esac
done



# ///////////////// set region //////////////////////////////////
if [ "$REGION" == "sant" ]
then
	gmtset PS_MEDIA 22cx21c
	frame=0.05
        scale=-Lf25.51/36.315/36:24/4+l+jr
        range=-R25.27/25.55/36.3/36.5
        proj=-Jm25.4/36.4/1:150000
        logo_pos=BL/0.2c/0.2c/"DSO[at]NTUA"
        legendc="-Jx1i -R0/8/0/8 -Dx0c/0.3c/3.6c/4.7c/BL"
elif [ "$REGION" == "extsant" ]
then
	gmtset PS_MEDIA 25cx21c
        frame=0.5
        scale=-Lf25.95/36.315/36:24/10+l+jr
        range=-R25.2/26.1/36.2/36.9
        proj=-Jm25.4/36.4/1:500000
        logo_pos=BL/0.2c/0.2c/"DSO[at]NTUA"
        legendc="-Jx1i -R0/8/0/8 -Dx11c/3.3c/3.6c/4.7c/BL"
        
elif [ "$REGION" == "saegean" ] #-------------------saegean 
then
	gmtset PS_MEDIA 29cx21c
        frame=2
        scale=-Lf22/34.3/36:24/100+l+jr
        range=-R21/30.5/34/38.7
        proj=-Jm24/36/1:3450000
	logo_pos=BL/19c/0.2c/"DSO[at]NTUA"
	
	legendc="-Jx1i -R0/8/0/8 -Dx20c/0.3c/3.6c/4.7c/BL"
elif [ "$REGION" == "grCyprus" ] #-------------------greece - cyprus extended
then
	gmtset PS_MEDIA 29cx21c
	frame=2
	scale=-Lf20/34.5/36:24/100+l+jr
	range=-R19/35/34/42
	proj=-Jm24/37/1:6000000
	logo_pos=BL/18c/0.2c/"DSO[at]NTUA"
	logo_pos2="-C22c/13.7c"
	legendc="-Jx1i -R0/8/0/8 -Dx.4c/0.2c/3.6c/4.7c/BL"	
else
	gmtset PS_MEDIA 21cx21c
	frame=2
	scale=-Lf20/34.5/36:24/100+l+jr
	range=-R19/30/34/42
	proj=-Jm24/37/1:6000000
	logo_pos=BL/19c/0.2c/"DSO[at]NTUA"
	logo_pos2="-C14.8c/0.1c"
	legendc="-Jx1i -R0/8/0/8 -Dx0.3c/0.6c/3.6c/4.3c/BL"	
fi

if [ "$DBGNSS" -eq 1 ]
then
	if [ ! -f "dbparameters" ]
	then
		echo "database parameters does not exist"
		echo "copy daparameters.default file to dbparameters and configure db parameters"
		exit 1
	else
		source dbparameters
	fi
fi

# ####################### TOPOGRAPHY ###########################
if [ "$TOPOGRAPHY" -eq 0 ]
then
	################## Plot coastlines only ######################
	pscoast $range $proj -B$frame:."$maptitle": -Df -W0.5/0/0/0 -G195  -U$logo_pos -K > $outfile
	psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
fi
if [ "$TOPOGRAPHY" -eq 1 ]
then
	# ####################### TOPOGRAPHY ###########################
	# bathymetry
	makecpt -Cgebco.cpt -T-7000/0/150 -Z > $bathcpt
	grdimage $inputTopoB $range $proj -C$bathcpt -K > $outfile
	pscoast $proj -P $range -Df -Gc -K -O >> $outfile
	# land
	makecpt -Cgray.cpt -T-3000/1800/50 -Z > $landcpt
	grdimage $inputTopoL $range $proj -C$landcpt  -K -O >> $outfile
	pscoast -R -J -O -K -Q >> $outfile
	#------- coastline -------------------------------------------
	psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
	pscoast -Jm -R -B$frame:."$maptitle": -Df -W -K  -O -U$logo_pos >> $outfile
fi

# start create legend file .legend
echo "G 0.2c" > .legend
echo "H 9 Times-Roman $maptitle" >> .legend
echo "D 0.3c 1p" >> .legend
echo "N 1" >> .legend

# ///////////////// PLOT GREECE NETWORKS //////////////////////////////////
if [ "$GNET_GREECE" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $greece_sta ]
		then
			echo "input file $greece_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $greece_sta | psxy -Jm -O -R $gr_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $greece_sta | pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
	
	
fi


# ///////////////// PLOT SANTORINI NETWORK //////////////////////////////////
if [ "$GNET_SANT" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='SANTORINI';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-sant
		psxy tmp-sant -Jm -O -R $sa_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			pstext tmp-sant -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $sant_sta ]
		then
			echo "input file $sant_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $sant_sta | psxy -Jm -O -R $sa_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $sant_sta | pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
		fi
        fi
        echo "G 0.25c" >> .legend
        echo "S 0.4c t 0.22c green 0.22p 0.6c SANTORINI" >> .legend
fi

# ///////////////// PLOT URANUS NETWORK //////////////////////////////////
if [ "$GNET_URANUS" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='URANUS';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-uranus
		psxy tmp-uranus -Jm -O -R $ur_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			pstext tmp-uranus -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $uranus_sta ]
		then
			echo "input file $uranus_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $uranus_sta | psxy -Jm -O -R $ur_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $uranus_sta | pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
		fi
        fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.22c blue 0.22p 0.6c URANUS" >> .legend
fi

# ///////////////// PLOT metrica NETWORK //////////////////////////////////
if [ "$GNET_METRICA" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='metrica';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-metrica
		psxy tmp-metrica -Jm -O -R $me_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			pstext tmp-metrica -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $metrica_sta ]
		then
			echo "input file $metrica_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $metrica_sta | psxy -Jm -O -R $me_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $metrica_sta | pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	      fi
       fi
	echo "G 0.25c" >> .legend
	echo "S 0.3c t 0.22c black 0.22p 0.6c OTHERS" >> .legend
fi

# ///////////////// PLOT HEPOS NETWORK //////////////////////////////////
if [ "$GNET_HEPOS" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
	echo "Warning: HEPOS net cannot ploted via db until now! use -fgnss switch"
# 		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
# 		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='URANUS';" \
# 		| grep -v + \
# 		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-uranus
# 		psxy tmp-uranus -Jm -O -R $ur_style -K >> $outfile
# 		if [ "$LABELS" -eq 1 ]
# 		then		
# 			pstext tmp-uranus -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
# 			
# 		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $hepos_sta ]
		then
			echo "input file $hepos_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $hepos_sta | psxy -Jm -O -R $hp_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $hepos_sta | pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
		fi
        fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c c 0.15c red 0.22p 0.6c HEPOS" >> .legend
fi









echo "G 0.2c" >> .legend
echo "D 0.3c 1p" >> .legend

# ///////////////// PLOT LEGEND //////////////////////////////////
if [ "$LEGEND" -eq 1 ]
then
        pslegend .legend ${legendc} -C0.1c/0.1c -L1.1 -O -K >> $outfile
fi

#/////////////////FINESH SCRIPT
psimage $pth2logos/DSOlogo2.eps -O $logo_pos2 -W1.1c -F0.4 >>$outfile

#################--- Convert to jpg format ----##########################################
if [ "$OUTJPG" -eq 1 ]
then
	gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=$out_jpg $outfile
fi

rm tmp-*
rm .legend
rm *cpt

echo $?