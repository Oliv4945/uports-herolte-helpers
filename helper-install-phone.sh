#!/bin/bash


# Make the file system writtable
sudo mount -o remount,rw /

# Setudev rules
sudo mv 70-herolte.rules /usr/lib/lxc-android-config/70-herolte.rules
sudo chown root:root /usr/lib/lxc-android-config/70-herolte.rules

# Add layout data
sudo bash -c 'cat <<EOF > /etc/ubuntu-touch-session.d/android.conf
GRID_UNIT_PX=29
QTWEBKIT_DPR=3.0
NATIVE_ORENTATION=portrait
FORM_FACTOR=handset
EOF'

# Add user for APT, why ? (See Github)
sudo adduser --force-badname --system --home /nonexistent --no-create-home --quiet _apt || true

# Fix dataspace
sudo ubports-qa install xenial_-_fix-dataspace

# Done, reboot
# sudo reboot
sudo reboot
