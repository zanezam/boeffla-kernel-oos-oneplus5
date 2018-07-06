#!/system/bin/sh

# Boeffla-Config controller interface
#
# *******************************
# Oneplus 5 OOS 5.x.x version
#
# V0.1
# *******************************

# ********************************
# Kernel specific initialisation
# ********************************

# kernel specification (hardware; type; target; url)
KERNEL_SPECS="oneplus5;oos;oos5xx;http://kernel.boeffla.de/oneplus5/boeffla-kernel-oos/;boeffla-kernel-#VERSION#-OOS5xx-OnePlus5-anykernel.recovery.zip"

# kernel features 
# (1=enable-busybox,2=enable-frandom,3=wipe-cache,4=disable-zram-control)
# (5=enable-default-zram-control,6=enable-selinux-switch, 7=enable-selinux-control)
# (8=no-hotplugging,9=enable-doze-control, A=reduced KCAL)
KERNEL_FEATURES="-3-4-6-7-9-A-"

# path to kernel libraries
LIBPATH="/system/lib/modules"

# block devices
SYSTEM_DEVICE="/dev/block/bootdevice/by-name/system"
CACHE_DEVICE="/dev/block/bootdevice/by-name/cache"
DATA_DEVICE="/dev/block/bootdevice/by-name/userdata"
BOOT_DEVICE="/dev/block/bootdevice/by-name/boot"
RADIO_DEVICE="/dev/block/bootdevice/by-name/modem"
RECOVERY_DEVICE="/dev/block/bootdevice/by-name/recovery"


# *******************
# List of values
# *******************

if [ "lov_gov_profiles" == "$1" ]; then
	echo "interactive - battery;interactive - battery extreme;interactive - performance"
	exit 0
fi

if [ "lov_gov_profiles_2" == "$1" ]; then
	echo "interactive - battery;interactive - battery extreme;interactive - performance"
	exit 0
fi

if [ "lov_cpu_hotplug_profiles" == "$1" ]; then
	echo "4 cores (default);3 cores;2 cores;1 core"
	exit 0
fi

if [ "lov_cpu_hotplug_profiles_2" == "$1" ]; then
	echo "4 cores (default);3 cores;2 cores;1 core;off"
	exit 0
fi


if [ "lov_system_tweaks" == "$1" ]; then
	#echo "Thermal - Stock;Thermal - Custom;Thermal - Relaxed;Thermal - Performance;Thermal - Gaming;Thermal - Extreme"
	exit 0
fi

if [ "lov_modules" == "$1" ]; then
	ls $LIBPATH/*
	exit 0
fi

if [ "lov_sleep_gesture_texts" == "$1" ]; then
	echo ";;3;4;5;;;"
	exit 0
fi



# *******************
# Parameters
# *******************

if [ "param_readahead" == "$1" ]; then
	# Internal sd (min/max/steps)
	echo "128;3072;128;"
	# External sd (min/max/steps)
	echo "128;3072;128"
	exit 0
fi

if [ "param_boeffla_sound" == "$1" ]; then
	# Headphone min/max, Speaker min/max
	echo "-30;30;-255;0;"
	# Equalizer min/max
	echo "-12;12;"
	# Microphone gain min/max
	echo "-20;30;"
	# Stereo expansion min/max
	echo "0;31;"
	# Earpiece min/max
	echo "-10;20"
	exit 0
fi

if [ "param_cpu_uv" == "$1" ]; then
	# CPU UV min/max/steps
	echo "600;1500;25"
	exit 0
fi

if [ "param_gpu_uv" == "$1" ]; then
	# GPU UV min/max/steps
	echo "500000;1200000;25000"
	exit 0
fi

if [ "param_led" == "$1" ]; then
	# LED speed min/max/steps
	echo "0;20;1;"
	# LED brightness min/max/steps
	echo "0;100;1"
	exit 0
fi

if [ "param_touchwake" == "$1" ]; then
	# Touchwake min/max/steps
	echo "0;600000;5000;"
	# Knockon min/max/steps
	echo "100;2000;100"
	exit 0
fi

if [ "param_early_suspend_delay" == "$1" ]; then
	# Early suspend delay min/max/steps
	echo "0;700;25"
	exit 0
fi

if [ "param_zram" == "$1" ]; then
	# zRam size min/max/steps
	echo "104857600;838860800;20971520"
	exit 0
fi

if [ "param_charge_rates" == "$1" ]; then
	# AC charge min/max/steps
	echo "0;2000;50;"
	# USB charge min/max/steps
	echo "0;1600;50;"
	# Wireless charge min/max/steps
	# echo "100;1000;25"
	exit 0
fi

if [ "param_lmk" == "$1" ]; then
	# LMK size min/max/steps
	echo "5;1200;1"
	exit 0
fi

if [ "param_misc" == "$1" ]; then
	# vibration intensity min/max/steps
	echo "0;25;1;"
	# touch key led duration min/max/steps
	echo "0;30000;500;"
	# touch boost min/max/steps
	echo "40;4000;20"
	exit 0
fi


# *******************
# Get settings
# *******************

if [ "get_tunables" == "$1" ]; then
	if [ -d /sys/devices/system/cpu/cpu0/cpufreq/$2 ]; then
		cd /sys/devices/system/cpu/cpu0/cpufreq/$2
		for file in *
		do
			content="`busybox cat $file`"
			busybox echo -ne "$file~$content;"
		done
	fi
fi

if [ "get_tunables_2" == "$1" ]; then
	if [ -d /sys/devices/system/cpu/cpu4/cpufreq/$2 ]; then
		cd /sys/devices/system/cpu/cpu4/cpufreq/$2
		for file in *
		do
			content="`busybox cat $file`"
			busybox echo -ne "$file~$content;"
		done
	fi
fi

if [ "get_kernel_version2" == "$1" ]; then
	busybox cat /proc/version
	exit 0
fi

if [ "get_kernel_version3" == "$1" ]; then
	cat /proc/version
	exit 0
fi


if [ "get_kernel_specs" == "$1" ]; then
	echo $KERNEL_SPECS
	exit 0
fi

if [ "get_kernel_features" == "$1" ]; then
	echo $KERNEL_FEATURES
	exit 0
fi


# *******************
# Applying settings
# *******************

if [ "apply_cpu_hotplug_profile" == "$1" ]; then

	if [ "3 cores" == "$2" ]; then
		echo 1 > /sys/devices/system/cpu/cpu0/online
		echo 1 > /sys/devices/system/cpu/cpu1/online
		echo 1 > /sys/devices/system/cpu/cpu2/online
		echo 0 > /sys/devices/system/cpu/cpu3/online
		exit 0
	fi

	if [ "2 cores" == "$2" ]; then
		echo 1 > /sys/devices/system/cpu/cpu0/online
		echo 1 > /sys/devices/system/cpu/cpu1/online
		echo 0 > /sys/devices/system/cpu/cpu2/online
		echo 0 > /sys/devices/system/cpu/cpu3/online
		exit 0
	fi

	if [ "1 core" == "$2" ]; then
		echo 1 > /sys/devices/system/cpu/cpu0/online
		echo 0 > /sys/devices/system/cpu/cpu1/online
		echo 0 > /sys/devices/system/cpu/cpu2/online
		echo 0 > /sys/devices/system/cpu/cpu3/online
		exit 0
	fi

	# Default "4 cores (default)", or when no profile set
	echo 1 > /sys/devices/system/cpu/cpu0/online
	echo 1 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu2/online
	echo 1 > /sys/devices/system/cpu/cpu3/online
	exit 0;
fi

if [ "apply_cpu_hotplug_profile_2" == "$1" ] || [ "revert_big_cpu_cluster_online" == "$1" ]; then

	echo 0 > /sys/kernel/boeffla_config_mode/enabled

	if [ "3 cores" == "$2" ]; then
		echo 1 > /sys/devices/system/cpu/cpu4/online
		echo 1 > /sys/devices/system/cpu/cpu5/online
		echo 1 > /sys/devices/system/cpu/cpu6/online
		echo 0 > /sys/devices/system/cpu/cpu7/online
		exit 0
	fi

	if [ "2 cores" == "$2" ]; then
		echo 1 > /sys/devices/system/cpu/cpu4/online
		echo 1 > /sys/devices/system/cpu/cpu5/online
		echo 0 > /sys/devices/system/cpu/cpu6/online
		echo 0 > /sys/devices/system/cpu/cpu7/online
		exit 0
	fi

	if [ "1 core" == "$2" ]; then
		echo 1 > /sys/devices/system/cpu/cpu4/online
		echo 0 > /sys/devices/system/cpu/cpu5/online
		echo 0 > /sys/devices/system/cpu/cpu6/online
		echo 0 > /sys/devices/system/cpu/cpu7/online
		exit 0
	fi

	if [ "off" == "$2" ]; then
		echo 0 > /sys/devices/system/cpu/cpu4/online
		echo 0 > /sys/devices/system/cpu/cpu5/online
		echo 0 > /sys/devices/system/cpu/cpu6/online
		echo 0 > /sys/devices/system/cpu/cpu7/online
		exit 0
	fi

	# Default "4 cores (default)", or when no profile set
	echo 1 > /sys/devices/system/cpu/cpu4/online
	echo 1 > /sys/devices/system/cpu/cpu5/online
	echo 1 > /sys/devices/system/cpu/cpu6/online
	echo 1 > /sys/devices/system/cpu/cpu7/online
	exit 0;
fi


if [ "apply_governor_profile" == "$1" ]; then

	if [ "conservative - standard" == "$2" ]; then
		echo "20" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/down_threshold
		echo "5" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/freq_step
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/ignore_nice_load
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/sampling_down_factor
		echo "200000" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/sampling_rate
		echo "200000" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/sampling_rate_min
		echo "80" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/up_threshold

		busybox sync
	fi

	if [ "ondemand - standard" == "$2" ]; then
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/io_is_busy
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/powersave_bias
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_down_factor
		echo "10000" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate
		echo "10000" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate_min
		echo "95" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold

		busybox sync
	fi

	if [ "interactive - standard" == "$2" ]; then
		echo "19000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo "" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down
		echo "90" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo "1248000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
		echo "79000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo "19000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
		echo "83 1804800:95" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load

		busybox sync
	fi

	if [ "interactive - battery" == "$2" ]; then
		echo "19000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo "" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down
		echo "95" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo "1036800" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
		echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo "10000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
		echo "83 1804800:95" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo "35000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load

		busybox sync
	fi

	if [ "interactive - battery extreme" == "$2" ]; then
		echo "19000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo "" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down
		echo "99" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo "825600" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
		echo "10000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo "5000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
		echo "83 1804800:95" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo "50000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load

		busybox sync
	fi

	if [ "interactive - performance" == "$2" ]; then
		echo "19000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo "" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down
		echo "75" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo "1555200" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
		echo "95000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo "30000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
		echo "83 1804800:95" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo "10000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load

		busybox sync
	fi

	if [ "zzmoove - standard" == "$2" ]; then
		echo "25" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/afs_threshold1
		echo "50" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/afs_threshold2
		echo "75" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/afs_threshold3
		echo "90" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/afs_threshold4
		echo "40" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/down_threshold
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/fast_scaling_down
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/fast_scaling_up
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/ignore_nice_load
		echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/sampling_down_factor
		echo "200000" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/sampling_rate
		echo "200000" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/sampling_rate_min
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/scaling_proportional
		echo "75" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/smooth_up
		echo "80" > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/up_threshold

		busybox sync
	fi

	if [ "blu_active - standard" == "$2" ]; then
		echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/align_windows
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/fastlane
		echo "50" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/fastlane_threshold
		echo "99" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/go_hispeed_load
		echo "1248000" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/hispeed_freq
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/io_is_busy
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/min_sample_time
		echo "90" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/target_loads
		echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/timer_slack

		busybox sync
	fi

	if [ "impulse - standard" == "$2" ]; then
		echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/align_windows
		echo "99" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/go_hispeed_load
		echo "1555200" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/hispeed_freq
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/io_is_busy
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/max_freq_hysteresis
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/min_sample_time
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/powersave_bias
		echo "90" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/target_loads
		echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/impulse/timer_slack

		busybox sync
	fi

	if [ "cultivation - standard" == "$2" ]; then
		echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/align_windows
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/fastlane
		echo "50" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/fastlane_threshold
		echo "99" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/go_hispeed_load
		echo "1555200" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/hispeed_freq
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/io_is_busy
		echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/max_freq_hysteresis
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/min_sample_time
		echo "90" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/target_loads
		echo "20000" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/timer_rate
		echo "50000" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/timer_rate_screenoff
		echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/cultivation/timer_slack

		busybox sync
	fi

	exit 0
fi

if [ "apply_governor_profile_2" == "$1" ]; then

	if [ "conservative - standard" == "$2" ]; then
		echo "20" > /sys/devices/system/cpu/cpu4/cpufreq/conservative/down_threshold
		echo "5" > /sys/devices/system/cpu/cpu4/cpufreq/conservative/freq_step
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/conservative/ignore_nice_load
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/conservative/sampling_down_factor
		echo "200000" > /sys/devices/system/cpu/cpu4/cpufreq/conservative/sampling_rate
		echo "200000" > /sys/devices/system/cpu/cpu4/cpufreq/conservative/sampling_rate_min
		echo "80" > /sys/devices/system/cpu/cpu4/cpufreq/conservative/up_threshold

		busybox sync
	fi

	if [ "ondemand - standard" == "$2" ]; then
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/ignore_nice_load
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/io_is_busy
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/powersave_bias
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/sampling_down_factor
		echo "10000" > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/sampling_rate
		echo "10000" > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/sampling_rate_min
		echo "95" > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/up_threshold

		busybox sync
	fi

	if [ "interactive - standard" == "$2" ]; then
		echo "19000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost
		echo "" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/enable_prediction
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/fast_ramp_down
		echo "90" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
		echo "1574400" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/ignore_hispeed_on_notif
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
		echo "79000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
		echo "19000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
		echo "83 1939200:90 2016000:95" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
		echo "20000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load

		busybox sync
	fi

	if [ "interactive - battery" == "$2" ]; then
		echo "19000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost
		echo "" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/enable_prediction
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/fast_ramp_down
		echo "95" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
		echo "1344000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/ignore_hispeed_on_notif
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
		echo "20000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
		echo "10000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
		echo "83 1939200:90 2016000:95" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
		echo "35000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load

		busybox sync
	fi

	if [ "interactive - battery extreme" == "$2" ]; then
		echo "19000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost
		echo "" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/enable_prediction
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/fast_ramp_down
		echo "99" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
		echo "1132800" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/ignore_hispeed_on_notif
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
		echo "10000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
		echo "5000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
		echo "83 1939200:90 2016000:95" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
		echo "50000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load

		busybox sync
	fi

	if [ "interactive - performance" == "$2" ]; then
		echo "19000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost
		echo "" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/enable_prediction
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/fast_ramp_down
		echo "75" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
		echo "1958400" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/ignore_hispeed_on_notif
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
		echo "95000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
		echo "30000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
		echo "83 1939200:90 2016000:95" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
		echo "10000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load

		busybox sync
	fi

	if [ "zzmoove - standard" == "$2" ]; then
		echo "25" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/afs_threshold1
		echo "50" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/afs_threshold2
		echo "75" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/afs_threshold3
		echo "90" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/afs_threshold4
		echo "40" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/down_threshold
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/fast_scaling_down
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/fast_scaling_up
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/ignore_nice_load
		echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/sampling_down_factor
		echo "200000" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/sampling_rate
		echo "200000" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/sampling_rate_min
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/scaling_proportional
		echo "75" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/smooth_up
		echo "80" > /sys/devices/system/cpu/cpu4/cpufreq/zzmoove/up_threshold
	fi

	if [ "blu_active - standard" == "$2" ]; then
		echo "20000" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/align_windows
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/fastlane
		echo "50" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/fastlane_threshold
		echo "99" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/go_hispeed_load
		echo "1958400" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/hispeed_freq
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/io_is_busy
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/min_sample_time
		echo "90" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/target_loads
		echo "20000" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/blu_active/timer_slack

		busybox sync
	fi

	if [ "impulse - standard" == "$2" ]; then
		echo "20000" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/align_windows
		echo "99" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/go_hispeed_load
		echo "1958400" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/hispeed_freq
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/io_is_busy
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/max_freq_hysteresis
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/min_sample_time
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/powersave_bias
		echo "90" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/target_loads
		echo "20000" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/timer_rate
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/impulse/timer_slack

		busybox sync
	fi

	if [ "cultivation - standard" == "$2" ]; then
		echo "20000" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/above_hispeed_delay
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/align_windows
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/fastlane
		echo "50" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/fastlane_threshold
		echo "99" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/go_hispeed_load
		echo "1958400" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/hispeed_freq
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/io_is_busy
		echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/max_freq_hysteresis
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/min_sample_time
		echo "90" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/target_loads
		echo "20000" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/timer_rate
		echo "50000" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/timer_rate_screenoff
		echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/cultivation/timer_slack

		busybox sync
	fi

	exit 0
fi


if [ "apply_system_tweaks" == "$1" ]; then

	exit 0
fi

if [ "apply_ext4_tweaks" == "$1" ]; then
	if [ "1" == "$2" ]; then
		busybox sync
		busybox mount -o remount,commit=20,noatime $CACHE_DEVICE /cache
		busybox sync
		busybox mount -o remount,commit=20,noatime $DATA_DEVICE /data
		busybox sync
	fi

	if [ "0" == "$2" ]; then
		busybox sync
		busybox mount -o remount,commit=0,noatime $CACHE_DEVICE /cache
		busybox sync
		busybox mount -o remount,commit=0,noatime $DATA_DEVICE /data
		busybox sync
	fi
	exit 0
fi


if [ "apply_cifs" == "$1" ]; then
	if [ "1" == "$2" ]; then
		busybox insmod $LIBPATH/cifs.ko
	fi

	if [ "0" == "$2" ]; then
		rmmod $LIBPATH/cifs.ko	
	fi
	exit 0
fi

if [ "apply_nfs" == "$1" ]; then
	if [ "1" == "$2" ]; then
		busybox insmod $LIBPATH/sunrpc.ko
		busybox insmod $LIBPATH/grace.ko
		busybox insmod $LIBPATH/lockd.ko
		busybox insmod $LIBPATH/dns_resolver.ko
		busybox insmod $LIBPATH/nfs.ko
		busybox insmod $LIBPATH/nfsv3.ko
		busybox insmod $LIBPATH/nfsv4.ko
	fi

	if [ "0" == "$2" ]; then
		rmmod $LIBPATH/nfsv4.ko
		rmmod $LIBPATH/nfsv3.ko
		rmmod $LIBPATH/nfs.ko
		rmmod $LIBPATH/dns_resolver.ko
		rmmod $LIBPATH/lockd.ko
		rmmod $LIBPATH/grace.ko
		rmmod $LIBPATH/sunrpc.ko
	fi
	exit 0
fi

if [ "apply_xbox" == "$1" ]; then
	if [ "1" == "$2" ]; then
		busybox insmod $LIBPATH/ff-memless.ko
		busybox insmod $LIBPATH/xpad.ko
	fi

	if [ "0" == "$2" ]; then
		rmmod $LIBPATH/xpad.ko
		rmmod $LIBPATH/ff-memless.ko
	fi
	exit 0
fi

if [ "apply_exfat" == "$1" ]; then
	if [ "1" == "$2" ]; then
		busybox insmod $LIBPATH/exfat_core.ko
		busybox insmod $LIBPATH/exfat_fs.ko
	fi

	if [ "0" == "$2" ]; then
		rmmod $LIBPATH/exfat_fs.ko
		rmmod $LIBPATH/exfat_core.ko
	fi
	exit 0
fi

if [ "apply_usb_ethernet" == "$1" ]; then
	if [ "1" == "$2" ]; then
		busybox insmod $LIBPATH/asix.ko
		netcfg eth0 up
		dhcpcd eth0
		DNS=`getprop net.eth0.dns1`
		ndc resolver setifdns eth0 "" $DNS  8.8.8.8
		ndc resolver setdefaultif eth0		
	fi

	if [ "0" == "$2" ]; then
		rmmod $LIBPATH/asix.ko
		netcfg eth0 down
	fi
	exit 0
fi

if [ "apply_ntfs" == "$1" ]; then
	if [ "1" == "$2" ]; then
		busybox insmod $LIBPATH/ntfs.ko
	fi

	if [ "0" == "$2" ]; then
		rmmod $LIBPATH/ntfs.ko
	fi
	exit 0
fi


# *******************
# Actions
# *******************

if [ "action_debug_info_file" == "$1" ]; then
	echo $(date) Full debug log file start > $2
	echo -e "\n============================================\n" >> $2

	echo -e "\n**** Boeffla-Kernel version\n" >> $2
	cat /proc/version >> $2

	echo -e "\n**** Firmware information\n" >> $2
	busybox grep ro.build.version /system/build.prop >> $2

	echo -e "\n============================================\n" >> $2

	echo -e "\n**** Boeffla-Kernel log\n" >> $2
	cat /sdcard/boeffla-kernel-data/boeffla-kernel.log >> $2

	echo -e "\n**** Boeffla-Kernel log 1\n" >> $2
	cat /sdcard/boeffla-kernel-data/boeffla-kernel.log.1 >> $2

	echo -e "\n**** Boeffla-Kernel log 2\n" >> $2
	cat /sdcard/boeffla-kernel-data/boeffla-kernel.log.2 >> $2

	echo -e "\n**** Boeffla-Kernel log 3\n" >> $2
	cat /sdcard/boeffla-kernel-data/boeffla-kernel.log.3 >> $2

	echo -e "\n============================================\n" >> $2

	echo -e "\n**** Boeffla-Config app log\n" >> $2
	cat /sdcard/boeffla-kernel-data/bc.log >> $2

	echo -e "\n**** Boeffla-Config app log 1\n" >> $2
	cat /sdcard/boeffla-kernel-data/bc.log.1 >> $2

	echo -e "\n**** Boeffla-Config app log 2\n" >> $2
	cat /sdcard/boeffla-kernel-data/bc.log.2 >> $2

	echo -e "\n**** Boeffla-Config app log 3\n" >> $2
	cat /sdcard/boeffla-kernel-data/bc.log.3 >> $2

	echo -e "\n**** Boeffla-Config crash log\n" >> $2
	cat /sdcard/boeffla-kernel-data/bc.crashlog >> $2

	echo -e "\n============================================\n" >> $2

	#echo -e "\n**** boeffla_sound\n" >> $2
	cd /sys/class/misc/boeffla_sound
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo "\n============================================\n" >> $2

	echo -e "\n**** SELinux:\n" >> $2
	getenforce >> $2

	echo -e "\n**** Loaded modules:\n" >> $2
	lsmod >> $2

	echo -e "\n**** CPU information:\n" >> $2
	cd /sys/devices/system/cpu/cpu0/cpufreq
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2
	cd /sys/devices/system/cpu/cpu1/cpufreq
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2
	cd /sys/devices/system/cpu/cpu2/cpufreq
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2
	cd /sys/devices/system/cpu/cpu3/cpufreq
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2
	cd /sys/devices/system/cpu/cpu4/cpufreq
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2
	cd /sys/devices/system/cpu/cpu5/cpufreq
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2
	cd /sys/devices/system/cpu/cpu6/cpufreq
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2
	cd /sys/devices/system/cpu/cpu7/cpufreq
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** GPU information:\n" >> $2
	cd /sys/class/kgsl/kgsl-3d0
	busybox find * -print -maxdepth 1 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** Root:\n" >> $2
	ls /system/xbin/su >> $2
	ls /system/app/Superuser.apk >> $2

	echo -e "\n**** Busybox:\n" >> $2
	ls /sbin/busybox >> $2
	ls /system/bin/busybox >> $2
	ls /system/xbin/busybox >> $2

	echo -e "\n**** Mounts:\n" >> $2
	mount | busybox grep /system >> $2
	mount | busybox grep /data >> $2
	mount | busybox grep /cache >> $2

	echo -e "\n**** SD Card read ahead:\n" >> $2
	cat /sys/block/sda/queue/read_ahead_kb >> $2

	echo -e "\n**** Various kernel settings by config app:\n" >> $2
	cd /dev
	busybox find bk_* -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** Touch boost:\n" >> $2
	cd /sys/class/misc/touchboost_switch
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** Scheduler:\n" >> $2
	cat /sys/block/sda/queue/scheduler >> $2

	echo -e "\n**** Scheduler hard:\n" >> $2
	cat /sys/block/sda/queue/scheduler_hard >> $2

	echo -e "\n**** Kernel Logger:\n" >> $2
	cat /sys/kernel/printk_mode/printk_mode >> $2

	echo -e "\n**** LED information:\n" >> $2
	cd /sys/class/leds/red/device
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** Color control information:\n" >> $2
	cd /sys/devices/platform/kcal_ctrl.0
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2
	
	echo -e "\n**** Swipe2wake information:\n" >> $2
	cd /proc/touchpanel
	busybox find sweep* -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** Swipe2sleep information:\n" >> $2
	cd /sys/android_touch
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** zRam information:\n" >> $2
	busybox find /sys/block/zram*/* -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** Uptime:\n" >> $2
	cat /proc/uptime >> $2

	echo -e "\n**** Frequency usage table:\n" >> $2
	cat /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state >> $2
	cat /sys/devices/system/cpu/cpu4/cpufreq/stats/time_in_state >> $2

	echo -e "\n**** Memory:\n" >> $2
	busybox free -m >> $2

	echo -e "\n**** Meminfo:\n" >> $2
	cat /proc/meminfo >> $2

	echo -e "\n**** Swap:\n" >> $2
	cat /proc/swaps >> $2

	echo -e "\n**** Low memory killer:\n" >> $2
	cat /sys/module/lowmemorykiller/parameters/minfree >> $2

	echo -e "\n**** Swappiness:\n" >> $2
	cat /proc/sys/vm/swappiness >> $2

	echo -e "\n**** Storage:\n" >> $2
	busybox df >> $2

	echo -e "\n**** Mounts:\n" >> $2
	mount >> $2

	echo -e "\n**** Governor first cluster tuneables\n" >> $2
	GOVERNOR0=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	cd /sys/devices/system/cpu/cpu0/cpufreq/$GOVERNOR0
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n**** Governor second cluster tuneables\n" >> $2
	GOVERNOR2=`cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor`
	cd /sys/devices/system/cpu/cpu4/cpufreq/$GOVERNOR2
	busybox find * -print -maxdepth 0 -type f -exec busybox tail -v -n +1 {} + >> $2

	echo -e "\n============================================\n" >> $2

	echo -e "\n**** /data/app folder\n" >> $2
	ls -l /data/app >> $2

	echo -e "\n**** /system/app folder\n" >> $2
	ls -l /system/app >> $2

	echo -e "\n============================================\n" >> $2

	echo -e "\n**** /system/etc/init.d folder\n" >> $2
	ls -l /system/etc/init.d >> $2

	echo -e "\n**** /etc/init.d folder\n" >> $2
	ls -l /etc/init.d >> $2

	echo -e "\n**** /data/init.d folder\n" >> $2
	ls -l /data/init.d >> $2

	echo -e "\n============================================\n" >> $2

	echo -e "\n**** pstore console-ramoops*\n" >> $2
	cat /sys/fs/pstore/console-ramoops*  >> $2

	echo -e "\n**** pstore dmesg-ramoops*\n" >> $2
	cat /sys/fs/pstore/pmsg-ramoops*  >> $2

	echo -e "\n============================================\n" >> $2

	echo -e "\n**** dmesg\n" >> $2
	dmesg  >> $2

	echo -e "\n============================================\n" >> $2
	echo $(date) Full debug log file end >> $2

	busybox chmod 666 $2
	exit 0
fi


if [ "flash_recovery" == "$1" ]; then
	setenforce 0
	busybox dd if=$2 of=$RECOVERY_DEVICE
	exit 0
fi

if [ "extract_recovery" == "$1" ]; then
	busybox tar -xvf $2 -C $3
	exit 0
fi

if [ "bring_big_cpu_cluster_online" == "$1" ]; then
	echo 1 > /sys/kernel/boeffla_config_mode/enabled
	echo 1 > /sys/devices/system/cpu/cpu4/online
	echo 1 > /sys/devices/system/cpu/cpu5/online
	echo 1 > /sys/devices/system/cpu/cpu6/online
	echo 1 > /sys/devices/system/cpu/cpu7/online
	
	exit 0
fi
